import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/search_params.dart';
import '../../domain/entities/search_result_entity.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_data_source.dart';

class SearchRepositoryImpl<T> implements SearchRepository<T> {
  SearchRepositoryImpl({
    required this.remoteDataSource,
    required this.collection,
    required this.searchField,
    required this.fromFirestore,
  });

  final SearchRemoteDataSource<T> remoteDataSource;

  /// Firestore Collection
  final String collection;

  /// Field used for searching
  final String searchField;

  /// Converts Firestore document into Model
  final T Function(dynamic document) fromFirestore;

  @override
  Future<Result<SearchResultEntity<T>>> search(SearchParams params) async {
    try {
      final items = await remoteDataSource.search(
        collection: collection,
        searchField: searchField,
        query: params.query,
        limit: params.limit,
        fromFirestore: fromFirestore,
      );

      return Success(
        SearchResultEntity<T>(
          items: items,
          query: params.query,
          hasMore: items.length >= params.limit,
          totalCount: items.length,
        ),
      );
    } catch (e) {
      return Error(FirestoreFailure(message: e.toString()));
    }
  }

  @override
  Future<List<String>> getRecentSearches() async {
    return [];
  }

  @override
  Future<void> saveRecentSearch(String query) async {}

  @override
  Future<void> clearRecentSearches() async {}
}
