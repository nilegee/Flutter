import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String authorEmail;
  final String body;
  final String? createdAt;

  const PostCard({
    super.key,
    required this.authorEmail,
    required this.body,
    this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(authorEmail, style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 8),
            Text(body, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 12),
            if (createdAt != null)
              Text(createdAt!,
                  style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
