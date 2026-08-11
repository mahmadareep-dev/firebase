import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../firestore_query/domain/entities/firestore_query_params.dart';
import '../../domain/repositories/firestore_collection_group_repository.dart';
import '../datasources/firestore_collection_group_remote_data_source.dart';

class FirestoreCollectionGroupRepositoryImpl
    implements FirestoreCollectionGroupRepository {
  FirestoreCollectionGroupRepositoryImpl(this._remoteDataSource);

  final FirestoreCollectionGroupRemoteDataSource _remoteDataSource;

  @override
  Future<Result<List<T>>> execute<T>({
    required FirestoreQueryParams params,
    required T Function(DocumentSnapshot<Map<String, dynamic>> document)
    fromFirestore,
  }) async {
    try {
      final result = await _remoteDataSource.execute(
        params: params,
        fromFirestore: fromFirestore,
      );

      return Success(result);
    } catch (e) {
      return Error(FirestoreFailure(message: e.toString()));
    }
  }

  @override
  Stream<Result<List<T>>> watch<T>({
    required FirestoreQueryParams params,
    required T Function(DocumentSnapshot<Map<String, dynamic>> document)
    fromFirestore,
  }) async* {
    try {
      await for (final data in _remoteDataSource.watch(
        params: params,
        fromFirestore: fromFirestore,
      )) {
        yield Success(data);
      }
    } catch (e) {
      yield Error(FirestoreFailure(message: e.toString()));
    }
  }
}
