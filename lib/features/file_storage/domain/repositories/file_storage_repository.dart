import 'dart:io';

import '../../../../core/errors/result.dart';
import '../entities/uploaded_file_entity.dart';

abstract class FileStorageRepository {
  Future<Result<UploadedFileEntity>> uploadFile({
    required File file,
    required String path,
    String? fileName,
    Map<String, String>? metadata,
  });

  Future<Result<void>> deleteFile(String path);

  Future<Result<String>> getDownloadUrl(String path);

  Future<Result<List<UploadedFileEntity>>> listFiles(String path);
}
