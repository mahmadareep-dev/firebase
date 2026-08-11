import '../../../../core/errors/result.dart';
import '../../../firestore_query/domain/entities/firestore_query_params.dart';
import '../repositories/firestore_aggregate_repository.dart';

class CountQueryUseCase {
  CountQueryUseCase(this._repository);

  final FirestoreAggregateRepository _repository;

  Future<Result<int>> call({required FirestoreQueryParams params}) {
    return _repository.count(params: params);
  }
}
