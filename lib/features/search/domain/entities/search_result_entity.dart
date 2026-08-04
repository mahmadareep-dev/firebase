class SearchResultEntity<T> {
  /// Search results
  final List<T> items;

  /// Original query
  final String query;

  /// Whether more data is available
  final bool hasMore;

  /// Total results (optional)
  final int? totalCount;

  const SearchResultEntity({
    required this.items,
    required this.query,
    required this.hasMore,
    this.totalCount,
  });

  bool get isEmpty => items.isEmpty;

  bool get isNotEmpty => items.isNotEmpty;

  SearchResultEntity<T> copyWith({
    List<T>? items,
    String? query,
    bool? hasMore,
    int? totalCount,
  }) {
    return SearchResultEntity<T>(
      items: items ?? this.items,
      query: query ?? this.query,
      hasMore: hasMore ?? this.hasMore,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}
