import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/batch_operation.dart';

abstract interface class FirestoreBatchRemoteDataSource {
  Future<void> commitBatch({required List<BatchOperation> operations});

  Future<T> runTransaction<T>({
    required Future<T> Function(Transaction transaction) action,
  });
}

class FirestoreBatchRemoteDataSourceImpl
    implements FirestoreBatchRemoteDataSource {
  FirestoreBatchRemoteDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Future<void> commitBatch({required List<BatchOperation> operations}) async {
    final batch = _firestore.batch();

    for (final operation in operations) {
      final document = _firestore
          .collection(operation.collection)
          .doc(operation.documentId);

      switch (operation.type) {
        case BatchOperationType.set:
          batch.set(document, operation.data ?? {}, operation.setOptions);
          break;

        case BatchOperationType.update:
          batch.update(document, operation.data ?? {});
          break;

        case BatchOperationType.delete:
          batch.delete(document);
          break;
      }
    }

    await batch.commit();
  }

  @override
  Future<T> runTransaction<T>({
    required Future<T> Function(Transaction transaction) action,
  }) {
    return _firestore.runTransaction<T>((transaction) async {
      return await action(transaction);
    });
  }
}
