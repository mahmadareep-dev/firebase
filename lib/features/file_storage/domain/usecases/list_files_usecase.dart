import '../../../../core/errors/result.dart';
import '../entities/uploaded_file_entity.dart';
import '../repositories/file_storage_repository.dart';

class ListFilesUseCase {
  final FileStorageRepository repository;

  ListFilesUseCase(this.repository);

  Future<Result<List<UploadedFileEntity>>> call(String path) {
    return repository.listFiles(path);
  }
}
