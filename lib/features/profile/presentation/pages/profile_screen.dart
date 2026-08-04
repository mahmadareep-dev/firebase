import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../posts/presentation/pages/paginated_posts_screen.dart';
import '../../../posts/presentation/pages/posts_screen.dart';
import '../controllers/profile_controller.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final profileController = Get.find<ProfileController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileController.refreshProfile();
    });

    return Scaffold(
      appBar: AppBar(title: const Text("My Profile"), centerTitle: true),
      body: Obx(() {
        final profile = profileController.user.value;
        final authUser = authController.currentUser;

        if (profileController.isLoading.value && profile == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final bool isPasswordUser = authUser?.isPasswordUser == true;

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            /// Profile Header
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: profile != null && profile.photoUrl.isNotEmpty
                    ? NetworkImage(profile.photoUrl)
                    : null,
                child: profile == null || profile.photoUrl.isEmpty
                    ? Text(
                        (profile?.name.isNotEmpty == true)
                            ? profile!.name[0].toUpperCase()
                            : "U",
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
            ),

            const SizedBox(height: 16),

            Center(
              child: Text(
                profile?.name ?? authUser?.displayName ?? "",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 6),

            Center(
              child: Text(
                profile?.email ?? authUser?.email ?? "",
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),

            if ((profile?.phone ?? "").isNotEmpty) ...[
              const SizedBox(height: 4),
              Center(
                child: Text(
                  profile!.phone,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            ],

            const SizedBox(height: 30),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  /// Edit Profile
                  ListTile(
                    leading: const Icon(Icons.edit_outlined),
                    title: const Text("Edit Profile"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Get.to(() => EditProfileScreen());
                    },
                  ),

                  const Divider(height: 1),

                  /// Change Password
                  if (isPasswordUser)
                    ListTile(
                      leading: const Icon(Icons.lock_outline),
                      title: const Text("Change Password"),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // Next step
                        // Open Change Password Screen
                      },
                    ),

                  if (isPasswordUser) const Divider(height: 1),

                  /// Logout
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.orange),
                    title: const Text("Logout"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: authController.logout,
                  ),

                  const Divider(height: 1),

                  /// Delete Account
                  ListTile(
                    leading: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                    title: const Text(
                      "Delete Account",
                      style: TextStyle(color: Colors.red),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: authController.deleteAccount,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Center(
              child: Text(
                "Version 1.0.0",
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            SizedBox(height: 30),
            Card(
              child: ListTile(
                leading: const Icon(Icons.post_add_sharp),
                title: const Text("Posts"),
                trailing: const Icon(Icons.add),
                onTap: () {
                  Get.to(() => const PostsScreen());
                },
              ),
            ),
            SizedBox(height: 15),
            Card(
              child: ListTile(
                leading: const Icon(Icons.post_add_sharp),
                title: const Text("Paginated Posts"),
                trailing: const Icon(Icons.add),
                onTap: () {
                  Get.to(() => const PaginatedPostsScreen());
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
