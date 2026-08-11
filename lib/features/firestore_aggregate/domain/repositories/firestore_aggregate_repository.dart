import '../../../../core/errors/result.dart';
import '../../../firestore_query/domain/entities/firestore_query_params.dart';

abstract interface class FirestoreAggregateRepository {
  Future<Result<int>> count({required FirestoreQueryParams params});
}
