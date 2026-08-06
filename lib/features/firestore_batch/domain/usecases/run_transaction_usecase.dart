import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/result.dart';
import '../repositories/firestore_batch_repository.dart';

class RunTransactionUseCase {
  const RunTransactionUseCase(this._repository);

  final FirestoreBatchRepository _repository;

  Future<Result<T>> call<T>({
    required Future<T> Function(Transaction transaction) action,
  }) {
    return _repository.runTransaction<T>(action: action);
  }
}
