import '../../../../core/errors/result.dart';
import '../entities/batch_operation.dart';
import '../repositories/firestore_batch_repository.dart';

class CommitBatchUseCase {
  const CommitBatchUseCase(this._repository);

  final FirestoreBatchRepository _repository;

  Future<Result<void>> call(List<BatchOperation> operations) {
    return _repository.commitBatch(operations: operations);
  }
}
