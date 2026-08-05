import '../../../../core/errors/result.dart';
import '../entities/search_params.dart';
import '../entities/search_result_entity.dart';

abstract interface class SearchRepository<T> {
  /// Search documents
  Future<Result<SearchResultEntity<T>>> search(SearchParams params);

  /// Recent Searches
  Future<List<String>> getRecentSearches();

  /// Save Search Query
  Future<void> saveRecentSearch(String query);

  /// Clear Search History
  Future<void> clearRecentSearches();
}
