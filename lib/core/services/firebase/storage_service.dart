import 'dart:io';

abstract class StorageService {
  Future<String> uploadFile({required String path, required File file});

  Future<void> deleteFile(String path);

  Future<String> getDownloadUrl(String path);
}
