import '../repositories/search_repository.dart';

class GetRecentSearchesUseCase<T> {
  const GetRecentSearchesUseCase(
      this._repository,
      );

  final SearchRepository<T> _repository;

  Future<List<String>> call() {
    return _repository.getRecentSearches();
  }
}
