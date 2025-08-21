import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/post_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  late final Stream<List<Map<String, dynamic>>> _postsStream;

  @override
  void initState() {
    super.initState();
    _postsStream = supabase
        .from('items')
        .stream(primaryKey: ['id'])
        .eq('kind', 'post')
        .eq('is_deleted', false)
        .order('created_at', ascending: false);
  }

  Future<void> _createPost() async {
    final controller = TextEditingController();
    final text = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Post'),
          content: TextField(
            controller: controller,
            decoration:
                const InputDecoration(labelText: 'What\'s on your mind?'),
            maxLines: null,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Post'),
            ),
          ],
        );
      },
    );
    if (text != null && text.trim().isNotEmpty) {
      final user = supabase.auth.currentUser!;
      await supabase.from('items').insert({
        'kind': 'post',
        'author_id': user.id,
        'author_email': user.email,
        'body': text.trim(),
        'created_at': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<void> _logout() async {
    await supabase.auth.signOut();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FamilyNest'),
        actions: [
          IconButton(onPressed: _logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _postsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final posts = snapshot.data!;
          if (posts.isEmpty) {
            return const Center(child: Text('No posts yet'));
          }
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return PostCard(
                authorEmail: post['author_email'] ?? '',
                body: post['body'] ?? '',
                createdAt: post['created_at'],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createPost,
        child: const Icon(Icons.add),
      ),
    );
  }
}
