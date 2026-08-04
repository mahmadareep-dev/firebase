class SearchParams {
  final String query;
  final int limit;

  const SearchParams({required this.query, this.limit = 20});

  SearchParams copyWith({String? query, int? limit}) {
    return SearchParams(query: query ?? this.query, limit: limit ?? this.limit);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchParams && query == other.query && limit == other.limit;

  @override
  int get hashCode => Object.hash(query, limit);
}
