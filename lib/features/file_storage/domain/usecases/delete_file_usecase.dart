import '../../../../core/errors/result.dart';
import '../repositories/file_storage_repository.dart';

class DeleteFileUseCase {
  final FileStorageRepository repository;

  DeleteFileUseCase(this.repository);

  Future<Result<void>> call(String path) {
    return repository.deleteFile(path);
  }
}
