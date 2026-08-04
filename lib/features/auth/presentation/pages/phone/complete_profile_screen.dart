import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/complete_profile_controller.dart';

class CompleteProfileScreen extends GetView<CompleteProfileController> {
  const CompleteProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Profile image
              Obx(
                () => Column(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundImage: controller.selectedImage.value != null
                          ? FileImage(controller.selectedImage.value!)
                          : null,
                      child: controller.selectedImage.value == null
                          ? const Icon(Icons.person, size: 55)
                          : null,
                    ),

                    const SizedBox(height: 12),

                    OutlinedButton.icon(
                      onPressed: controller.isSavingProfile.value
                          ? null
                          : controller.pickProfileImage,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Choose Profile Image'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Name
              TextField(
                controller: controller.nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // Email
              TextField(
                controller: controller.emailController,
                readOnly: controller.hasAuthEmail,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  border: const OutlineInputBorder(),
                  helperText: controller.hasAuthEmail
                      ? 'Email linked with your account'
                      : 'Enter your email',
                ),
              ),

              const SizedBox(height: 16),

              // Phone
              TextField(
                controller: controller.phoneController,
                readOnly: controller.hasAuthPhone,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  prefixIcon: const Icon(Icons.phone),
                  border: const OutlineInputBorder(),
                  helperText: controller.hasAuthPhone
                      ? 'Phone linked with your account'
                      : 'Enter your phone number',
                ),
              ),

              const SizedBox(height: 16),

              // Created At
              TextField(
                enabled: false,
                controller: TextEditingController(text: controller.createdAt),
                decoration: const InputDecoration(
                  labelText: 'Created At',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // Updated At
              const TextField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Updated At',
                  hintText: 'Will be managed by Firestore',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 25),

              // Save Profile
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.isSavingProfile.value
                        ? null
                        : controller.saveProfile,
                    child: controller.isSavingProfile.value
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save Profile'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
