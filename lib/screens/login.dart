import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final SupabaseClient supabase = Supabase.instance.client;

  static const allowList = [
    'nilezat@gmail.com',
    'abdessamia.mariem@gmail.com',
    'yazidgeemail@gmail.com',
    'yahyageemail@gmail.com',
  ];

  @override
  void initState() {
    super.initState();
    final session = supabase.auth.currentSession;
    if (session != null) {
      _handleRedirect();
    }
    supabase.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn) {
        _handleRedirect();
      }
    });
  }

  Future<void> _handleRedirect() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;
    if (allowList.contains(user.email)) {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/dashboard');
    } else {
      await supabase.auth.signOut();
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/access-denied');
    }
  }

  Future<void> _signIn() async {
    await supabase.auth.signInWithOAuth(Provider.google);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: _signIn,
          icon: const Icon(Icons.login),
          label: const Text('Login with Google'),
        ),
      ),
    );
  }
}
