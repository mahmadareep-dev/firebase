import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../search/presentation/pages/search_screen.dart';
import '../../../search/presentation/widgets/search_result_tile.dart';
import '../../data/models/post_model.dart';
import '../controllers/post_controller.dart';
import '../widgets/post_dialog.dart';
import '../widgets/post_list_widget.dart';

class PostsScreen extends GetView<PostController> {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore CRUD'),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.search),
          //   onPressed: (){}
          // ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Get.to(
                () => SearchScreen<PostModel>(
                  title: 'Search Posts',
                  hintText: 'Search posts...',
                  itemBuilder: (context, post) {
                    return SearchResultTile(
                      title: post.title,
                      subtitle: post.description,
                      onTap: () {
                        Get.back();
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.posts.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.posts.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.loadPosts,
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
          onRefresh: controller.loadPosts,
          child: PostListWidget(
            posts: controller.posts,
            onEdit: (post) {
              PostDialog.show(post: post);
            },
            onDelete: (post) {
              Get.defaultDialog(
                title: 'Delete',
                middleText: 'Are you sure you want to delete this post?',
                textCancel: 'Cancel',
                textConfirm: 'Delete',
                onConfirm: () {
                  Get.back();
                  controller.deletePost(post);
                },
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          PostDialog.show();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
