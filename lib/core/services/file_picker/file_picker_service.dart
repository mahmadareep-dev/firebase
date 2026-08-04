import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

abstract class FilePickerService {
  Future<File?> pickImageFromGallery();

  Future<File?> pickImageFromCamera();

  Future<File?> pickVideoFromGallery();

  Future<File?> pickVideoFromCamera();

  Future<File?> pickDocument();

  Future<List<File>> pickMultipleImages();
}

class FilePickerServiceImpl implements FilePickerService {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Future<File?> pickImageFromGallery() async {
    final XFile? file = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (file == null) return null;

    return File(file.path);
  }

  @override
  Future<File?> pickImageFromCamera() async {
    final XFile? file = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (file == null) return null;

    return File(file.path);
  }

  @override
  Future<File?> pickVideoFromGallery() async {
    final XFile? file = await _imagePicker.pickVideo(
      source: ImageSource.gallery,
    );

    if (file == null) return null;

    return File(file.path);
  }

  @override
  Future<File?> pickVideoFromCamera() async {
    final XFile? file = await _imagePicker.pickVideo(
      source: ImageSource.camera,
    );

    if (file == null) return null;

    return File(file.path);
  }

  @override
  Future<File?> pickDocument() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );

    if (result == null || result.files.single.path == null) {
      return null;
    }

    return File(result.files.single.path!);
  }

  @override
  Future<List<File>> pickMultipleImages() async {
    final List<XFile> images = await _imagePicker.pickMultiImage(
      imageQuality: 80,
    );

    return images.map((e) => File(e.path)).toList();
  }
}
