import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/post_entity.dart';
import '../controllers/post_controller.dart';

class PostDialog extends GetView<PostController> {
  const PostDialog({super.key, this.post});

  final PostEntity? post;

  static Future<void> show({PostEntity? post}) {
    final controller = Get.find<PostController>();

    if (post != null) {
      controller.fillFields(post);
    } else {
      controller.clearFields();
    }

    return Get.dialog(PostDialog(post: post));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(post == null ? 'Add Post' : 'Edit Post'),
      content: SingleChildScrollView(
        child: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (controller.fileStorageController.isSaving.value)
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: LinearProgressIndicator(),
                ),

              if (controller.imageUrl.value.isNotEmpty)
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        controller.imageUrl.value,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: InkWell(
                        onTap: () {
                          controller.imageUrl.value = '';
                        },
                        child: const CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.black54,
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: controller.fileStorageController.isSaving.value
                        ? null
                        : controller.pickPostImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Add Image'),
                  ),
                ),

              const SizedBox(height: 16),

              TextField(
                controller: controller.titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: controller.descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: Get.back, child: const Text('Cancel')),
        Obx(
          () => ElevatedButton(
            onPressed:
                controller.isSaving.value ||
                    controller.fileStorageController.isSaving.value
                ? null
                : () {
                    if (post == null) {
                      controller.addPost();
                    } else {
                      controller.updatePost(post!);
                    }
                  },
            child: controller.isSaving.value
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(post == null ? 'Save' : 'Update'),
          ),
        ),
      ],
    );
  }
}
