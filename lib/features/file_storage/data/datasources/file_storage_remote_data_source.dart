import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../../../../core/errors/app_exception.dart';
import '../models/uploaded_file_model.dart';

abstract class FileStorageRemoteDataSource {
  Future<UploadedFileModel> uploadFile({
    required File file,
    required String path,
    String? fileName,
    Map<String, String>? metadata,
  });

  Future<void> deleteFile(String path);

  Future<String> getDownloadUrl(String path);

  Future<List<UploadedFileModel>> listFiles(String path);
}

class FileStorageRemoteDataSourceImpl implements FileStorageRemoteDataSource {
  final FirebaseStorage firebaseStorage;

  FileStorageRemoteDataSourceImpl(this.firebaseStorage);

  @override
  Future<UploadedFileModel> uploadFile({
    required File file,
    required String path,
    String? fileName,
    Map<String, String>? metadata,
  }) async {
    try {
      final String name = fileName ?? file.uri.pathSegments.last;

      final String fullPath = path.endsWith('/') ? '$path$name' : '$path/$name';

      final Reference reference = firebaseStorage.ref(fullPath);

      final storageMetadata = metadata == null
          ? null
          : SettableMetadata(customMetadata: metadata);

      final TaskSnapshot snapshot = await reference.putFile(
        file,
        storageMetadata,
      );

      final String downloadUrl = await snapshot.ref.getDownloadURL();

      final FullMetadata fileMetadata = await snapshot.ref.getMetadata();

      return UploadedFileModel(
        name: name,
        path: fullPath,
        downloadUrl: downloadUrl,
        contentType: fileMetadata.contentType,
        size: fileMetadata.size ?? 0,
        uploadedAt: fileMetadata.timeCreated ?? DateTime.now(),
      );
    } on FirebaseException catch (e) {
      throw AppException(message: e.message ?? 'Failed to upload file.');
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }

  @override
  Future<void> deleteFile(String path) async {
    try {
      await firebaseStorage.ref(path).delete();
    } on FirebaseException catch (e) {
      throw AppException(message: e.message ?? 'Failed to delete file.');
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }

  @override
  Future<String> getDownloadUrl(String path) async {
    try {
      return await firebaseStorage.ref(path).getDownloadURL();
    } on FirebaseException catch (e) {
      throw AppException(message: e.message ?? 'Failed to get download URL.');
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }

  @override
  Future<List<UploadedFileModel>> listFiles(String path) async {
    try {
      final ListResult result = await firebaseStorage.ref(path).listAll();

      final List<UploadedFileModel> files = [];

      for (final Reference item in result.items) {
        final FullMetadata metadata = await item.getMetadata();
        final String downloadUrl = await item.getDownloadURL();

        files.add(
          UploadedFileModel(
            name: item.name,
            path: item.fullPath,
            downloadUrl: downloadUrl,
            contentType: metadata.contentType,
            size: metadata.size ?? 0,
            uploadedAt: metadata.timeCreated ?? DateTime.now(),
          ),
        );
      }

      return files;
    } on FirebaseException catch (e) {
      throw AppException(message: e.message ?? 'Failed to list files.');
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }
}
