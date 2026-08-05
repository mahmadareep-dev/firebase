import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/firestore_query_params.dart';
import '../../domain/repositories/firestore_query_repository.dart';
import '../datasources/firestore_query_remote_data_source.dart';

class FirestoreQueryRepositoryImpl implements FirestoreQueryRepository {
  const FirestoreQueryRepositoryImpl({required this.remoteDataSource});

  final FirestoreQueryRemoteDataSource remoteDataSource;

  @override
  Future<Result<List<T>>> execute<T>({
    required FirestoreQueryParams params,
    required T Function(DocumentSnapshot<Map<String, dynamic>> document)
    fromFirestore,
  }) async {
    try {
      final result = await remoteDataSource.execute<T>(
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
      await for (final result in remoteDataSource.watch<T>(
        params: params,
        fromFirestore: fromFirestore,
      )) {
        yield Success(result);
      }
    } catch (e) {
      yield Error(FirestoreFailure(message: e.toString()));
    }
  }
}
