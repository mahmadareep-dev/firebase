import 'dart:io';

import '../../../../core/errors/result.dart';
import '../entities/uploaded_file_entity.dart';
import '../repositories/file_storage_repository.dart';

class UploadFileUseCase {
  final FileStorageRepository repository;

  UploadFileUseCase(this.repository);

  Future<Result<UploadedFileEntity>> call({
    required File file,
    required String path,
    String? fileName,
    Map<String, String>? metadata,
  }) {
    return repository.uploadFile(
      file: file,
      path: path,
      fileName: fileName,
      metadata: metadata,
    );
  }
}
