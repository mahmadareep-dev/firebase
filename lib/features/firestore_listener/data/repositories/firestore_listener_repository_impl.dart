import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../firestore_query/domain/entities/firestore_query_params.dart';
import '../../domain/repositories/firestore_listener_repository.dart';
import '../datasources/firestore_listener_remote_data_source.dart';

class FirestoreListenerRepositoryImpl
    implements FirestoreListenerRepository {
  const FirestoreListenerRepositoryImpl(
      this._remoteDataSource,
      );

  final FirestoreListenerRemoteDataSource _remoteDataSource;

  @override
  Stream<Result<List<T>>> listen<T>({
    required FirestoreQueryParams params,
    required T Function(
        DocumentSnapshot<Map<String, dynamic>> document,
        ) fromFirestore,
  }) async* {
    try {
      await for (final data in _remoteDataSource.listen<T>(
        params: params,
        fromFirestore: fromFirestore,
      )) {
        yield Success(data);
      }
    } catch (e) {
      yield Error(
        UnknownFailure(
          message: e.toString(),
        ),
      );
    }
  }
}