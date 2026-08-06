import 'package:cloud_firestore/cloud_firestore.dart';

class PaginationResult<T> {
  const PaginationResult({
    required this.items,
    required this.hasMore,
    required this.lastDocument,
  });

  final List<T> items;

  final bool hasMore;

  final DocumentSnapshot<Map<String, dynamic>>? lastDocument;
}
