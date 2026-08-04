class PaginatedResult<T> {
  const PaginatedResult({
    required this.items,
    required this.lastDocument,
    required this.hasMore,
  });

  final List<T> items;

  /// Firestore document used for the next page.
  final Object? lastDocument;
  final bool hasMore;
}
