import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class SearchRemoteDataSource<T> {
  Future<List<T>> search({
    required String collection,
    required String searchField,
    required String query,
    required T Function(
        DocumentSnapshot<Map<String, dynamic>> document,
        ) fromFirestore,
    int limit = 20,
  });
}

class SearchRemoteDataSourceImpl<T>
    implements SearchRemoteDataSource<T> {
  SearchRemoteDataSourceImpl(
      this._firestore,
      );

  final FirebaseFirestore _firestore;

  @override
  Future<List<T>> search({
    required String collection,
    required String searchField,
    required String query,
    required T Function(
        DocumentSnapshot<Map<String, dynamic>> document,
        ) fromFirestore,
    int limit = 20,
  }) async {
    if (query.trim().isEmpty) {
      return [];
    }

    final snapshot = await _firestore
        .collection(collection)
        .orderBy(searchField)
        .startAt([query])
        .endAt(['$query\uf8ff'])
        .limit(limit)
        .get();

    return snapshot.docs
        .map(fromFirestore)
        .toList();
  }
}
