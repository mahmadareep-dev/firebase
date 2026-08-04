
import '../repositories/search_repository.dart';

class SaveRecentSearchUseCase<T> {
  const SaveRecentSearchUseCase(
      this._repository,
      );

  final SearchRepository<T> _repository;

  Future<void> call(
      String query,
      ) {
    return _repository.saveRecentSearch(query);
  }
}