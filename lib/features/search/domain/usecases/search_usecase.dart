import '../../../../core/errors/result.dart';
import '../entities/search_params.dart';
import '../entities/search_result_entity.dart';
import '../repositories/search_repository.dart';

class SearchUseCase<T> {
  const SearchUseCase(this._repository);

  final SearchRepository<T> _repository;

  Future<Result<SearchResultEntity<T>>> call(SearchParams params) {
    return _repository.search(params);
  }
}
