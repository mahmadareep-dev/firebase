import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/result.dart';
import '../entities/batch_operation.dart';

abstract interface class FirestoreBatchRepository {
  Future<Result<void>> commitBatch({required List<BatchOperation> operations});

  Future<Result<T>> runTransaction<T>({
    required Future<T> Function(Transaction transaction) action,
  });
}
