import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../core/errors/result.dart';
import '../../domain/entities/batch_operation.dart';
import '../../domain/usecases/commit_batch_usecase.dart';

class FirestoreBatchBuilder {
  FirestoreBatchBuilder({CommitBatchUseCase? commitBatchUseCase})
    : _commitBatchUseCase =
          commitBatchUseCase ?? Get.find<CommitBatchUseCase>();

  final CommitBatchUseCase _commitBatchUseCase;

  final List<BatchOperation> _operations = [];

  FirestoreBatchBuilder set({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
    SetOptions? options,
  }) {
    _operations.add(
      BatchOperation(
        type: BatchOperationType.set,
        collection: collection,
        documentId: documentId,
        data: data,
        setOptions: options,
      ),
    );

    return this;
  }

  FirestoreBatchBuilder update({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
  }) {
    _operations.add(
      BatchOperation(
        type: BatchOperationType.update,
        collection: collection,
        documentId: documentId,
        data: data,
      ),
    );

    return this;
  }

  FirestoreBatchBuilder delete({
    required String collection,
    required String documentId,
  }) {
    _operations.add(
      BatchOperation(
        type: BatchOperationType.delete,
        collection: collection,
        documentId: documentId,
      ),
    );

    return this;
  }

  Future<Result<void>> commit() async {
    final result = await _commitBatchUseCase(List.unmodifiable(_operations));

    _operations.clear();

    return result;
  }

  void clear() {
    _operations.clear();
  }
}
