import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();

  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> collection(String path) {
    return _firestore.collection(path);
  }

  DocumentReference<Map<String, dynamic>> document(
    String collection,
    String documentId,
  ) {
    return _firestore.collection(collection).doc(documentId);
  }

  Future<void> create({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.collection(collection).doc(documentId).set(data);
  }

  Future<void> update({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.collection(collection).doc(documentId).update(data);
  }

  Future<void> delete({
    required String collection,
    required String documentId,
  }) async {
    await _firestore.collection(collection).doc(documentId).delete();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument({
    required String collection,
    required String documentId,
  }) async {
    return await _firestore.collection(collection).doc(documentId).get();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamDocument({
    required String collection,
    required String documentId,
  }) {
    return _firestore.collection(collection).doc(documentId).snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getCollection({
    required String collection,
  }) async {
    return await _firestore.collection(collection).get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamCollection({
    required String collection,
  }) {
    return _firestore.collection(collection).snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> query({
    required String collection,
    String? field,
    dynamic isEqualTo,
    int? limit,
  }) async {
    Query<Map<String, dynamic>> query = _firestore.collection(collection);

    if (field != null) {
      query = query.where(field, isEqualTo: isEqualTo);
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    return await query.get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> paginate({
    required String collection,
    int limit = 10,
    DocumentSnapshot? lastDocument,
  }) async {
    Query<Map<String, dynamic>> query = _firestore
        .collection(collection)
        .limit(limit);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    return await query.get();
  }

  Future<void> batchWrite(
    Future<void> Function(WriteBatch batch) action,
  ) async {
    final batch = _firestore.batch();

    await action(batch);

    await batch.commit();
  }

  Future<T> runTransaction<T>(
    Future<T> Function(Transaction transaction) action,
  ) {
    return _firestore.runTransaction(action);
  }
}
