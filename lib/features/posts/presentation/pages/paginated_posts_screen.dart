import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/post_entity.dart';
import '../controllers/paginated_post_controller.dart';
import '../widgets/post_dialog.dart';
import '../widgets/post_list_widget.dart';

class PaginatedPostsScreen extends GetView<PaginatedPostController> {
  const PaginatedPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firestore Pagination')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.clearFields();
          PostDialog.show();
        },
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.items.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.loadFirstPage,
            child: ListView(
              children: const [
                SizedBox(height: 200),
                Center(
                  child: Text('No Posts Found', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshData,
          child: PostListWidget(
            posts: controller.items,
            scrollController: controller.scrollController,

            onEdit: (PostEntity post) {
              controller.fillFields(post);

              Get.dialog(
                AlertDialog(
                  title: const Text('Edit Post'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: controller.titleController,
                        decoration: const InputDecoration(labelText: 'Title'),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: controller.descriptionController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: Get.back,
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        controller.updatePost(post);
                      },
                      child: const Text("Update"),
                    ),
                  ],
                ),
              );
            },

            onDelete: (PostEntity post) {
              Get.defaultDialog(
                title: "Delete",
                middleText: "Delete this post?",
                textCancel: "Cancel",
                textConfirm: "Delete",
                onConfirm: () {
                  Get.back();
                  controller.deletePost(post.id);
                },
              );
            },

            footer: Obx(() {
              if (controller.isLoadingMore.value) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (!controller.hasMore.value) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      'No more posts',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            }),
          ),
        );
      }),
    );
  }
}
