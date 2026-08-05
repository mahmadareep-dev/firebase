import '../repositories/search_repository.dart';

class ClearRecentSearchesUseCase<T> {
  const ClearRecentSearchesUseCase(this._repository);

  final SearchRepository<T> _repository;

  Future<void> call() {
    return _repository.clearRecentSearches();
  }
}
