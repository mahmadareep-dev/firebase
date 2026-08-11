import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../firestore_query/domain/entities/firestore_query_params.dart';
import '../../domain/repositories/firestore_aggregate_repository.dart';
import '../datasources/firestore_aggregate_remote_data_source.dart';

class FirestoreAggregateRepositoryImpl implements FirestoreAggregateRepository {
  FirestoreAggregateRepositoryImpl(this._remoteDataSource);

  final FirestoreAggregateRemoteDataSource _remoteDataSource;

  @override
  Future<Result<int>> count({required FirestoreQueryParams params}) async {
    try {
      final result = await _remoteDataSource.count(params: params);

      return Success(result);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }
}
