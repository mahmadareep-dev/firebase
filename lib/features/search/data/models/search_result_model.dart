import '../../domain/entities/search_result_entity.dart';

class SearchResultModel<T> extends SearchResultEntity<T> {
  const SearchResultModel({
    required super.items,
    required super.query,
    required super.hasMore,
    super.totalCount,
  });

  factory SearchResultModel.fromEntity(SearchResultEntity<T> entity) {
    return SearchResultModel(
      items: entity.items,
      query: entity.query,
      hasMore: entity.hasMore,
      totalCount: entity.totalCount,
    );
  }
}
