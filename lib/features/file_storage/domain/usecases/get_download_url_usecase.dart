import '../../../../core/errors/result.dart';
import '../repositories/file_storage_repository.dart';

class GetDownloadUrlUseCase {
  final FileStorageRepository repository;

  GetDownloadUrlUseCase(this.repository);

  Future<Result<String>> call(String path) {
    return repository.getDownloadUrl(path);
  }
}
