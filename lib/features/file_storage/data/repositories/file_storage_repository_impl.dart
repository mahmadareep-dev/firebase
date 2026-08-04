import 'dart:io';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/uploaded_file_entity.dart';
import '../../domain/repositories/file_storage_repository.dart';
import '../datasources/file_storage_remote_data_source.dart';

class FileStorageRepositoryImpl implements FileStorageRepository {
  final FileStorageRemoteDataSource remoteDataSource;

  FileStorageRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<UploadedFileEntity>> uploadFile({
    required File file,
    required String path,
    String? fileName,
    Map<String, String>? metadata,
  }) async {
    try {
      final uploadedFile = await remoteDataSource.uploadFile(
        file: file,
        path: path,
        fileName: fileName,
        metadata: metadata,
      );

      return Success(uploadedFile);
    } on AppException catch (e) {
      return Error(e.failure);
    }
  }

  @override
  Future<Result<void>> deleteFile(String path) async {
    try {
      await remoteDataSource.deleteFile(path);

      return const Success(null);
    } on AppException catch (e) {
      return Error(e.failure);
    }
  }

  @override
  Future<Result<String>> getDownloadUrl(String path) async {
    try {
      final url = await remoteDataSource.getDownloadUrl(path);

      return Success(url);
    } on AppException catch (e) {
      return Error(e.failure);
    }
  }

  @override
  Future<Result<List<UploadedFileEntity>>> listFiles(String path) async {
    try {
      final files = await remoteDataSource.listFiles(path);

      return Success(files);
    } on AppException catch (e) {
      return Error(e.failure);
    }
  }
}
