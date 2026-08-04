import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../profile/presentation/controllers/profile_controller.dart';
import '../../../profile/presentation/pages/profile_screen.dart';
import '../controllers/auth_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ProfileController profileController;
  late final AuthController authController;

  @override
  void initState() {
    super.initState();

    profileController = Get.find<ProfileController>();
    authController = Get.find<AuthController>();

    // Important because ProfileController may survive/reappear
    // through GetX dependency management.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileController.loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: authController.logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Obx(() {
        if (profileController.isLoading.value &&
            profileController.user.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (profileController.errorMessage.value.isNotEmpty &&
            profileController.user.value == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    profileController.errorMessage.value,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: profileController.loadProfile,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final user = profileController.user.value;

        if (user == null) {
          return const Center(child: Text('Profile not available'));
        }

        return RefreshIndicator(
          onRefresh: profileController.refreshProfile,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            children: [
              const Center(
                child: Text(
                  'Login Successful!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 30),

              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: user.photoUrl.isNotEmpty
                      ? NetworkImage(user.photoUrl)
                      : null,
                  child: user.photoUrl.isEmpty
                      ? const Icon(Icons.person, size: 50)
                      : null,
                ),
              ),

              const SizedBox(height: 30),

              profileItem(
                title: 'Name',
                value: user.name.isNotEmpty ? user.name : 'Not available',
              ),

              profileItem(
                title: 'Email',
                value: user.email.isNotEmpty ? user.email : 'Not available',
              ),

              profileItem(
                title: 'Phone',
                value: user.phone.isNotEmpty ? user.phone : 'Not available',
              ),

              profileItem(
                title: 'Profile Image',
                value: user.photoUrl.isNotEmpty
                    ? user.photoUrl
                    : 'Not available',
              ),

              profileItem(
                title: 'Role',
                value: user.role.isNotEmpty ? user.role : 'user',
              ),

              profileItem(
                title: 'Created At',
                value: user.createdAt?.toString() ?? 'Not available',
              ),

              profileItem(
                title: 'Updated At',
                value: user.updatedAt?.toString() ?? 'Not available',
              ),

              profileItem(title: 'UID', value: user.uid),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => const ProfileScreen());
                  },
                  child: const Text('My Profile'),
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: authController.logout,
                  child: const Text('Logout'),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget profileItem({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$title:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
