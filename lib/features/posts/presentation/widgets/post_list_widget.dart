import 'package:flutter/material.dart';

import '../../domain/entities/post_entity.dart';

class PostListWidget extends StatelessWidget {
  const PostListWidget({
    super.key,
    required this.posts,
    required this.onEdit,
    required this.onDelete,
    this.scrollController,
    this.footer,
  });

  final List<PostEntity> posts;
  final ScrollController? scrollController;
  final Widget? footer;

  final void Function(PostEntity post) onEdit;
  final void Function(PostEntity post) onDelete;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: posts.length + (footer == null ? 0 : 1),
      itemBuilder: (_, index) {
        if (footer != null && index == posts.length) {
          return footer!;
        }

        final post = posts[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 5,
          child: ListTile(
            title: Text(
              post.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(post.description),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit(post);
                }

                if (value == 'delete') {
                  onDelete(post);
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ),
        );
      },
    );
  }
}
