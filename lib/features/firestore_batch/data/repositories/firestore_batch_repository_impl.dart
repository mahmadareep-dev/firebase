import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/batch_operation.dart';
import '../../domain/repositories/firestore_batch_repository.dart';
import '../datasources/firestore_batch_remote_data_source.dart';

class FirestoreBatchRepositoryImpl implements FirestoreBatchRepository {
  const FirestoreBatchRepositoryImpl({required this.remoteDataSource});

  final FirestoreBatchRemoteDataSource remoteDataSource;

  @override
  Future<Result<void>> commitBatch({
    required List<BatchOperation> operations,
  }) async {
    try {
      await remoteDataSource.commitBatch(operations: operations);

      return const Success(null);
    } on FirebaseException catch (e) {
      return Error(
        FirestoreFailure(message: e.message ?? e.code, code: e.code),
      );
    } catch (e) {
      return Error(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<T>> runTransaction<T>({
    required Future<T> Function(Transaction transaction) action,
  }) async {
    try {
      final result = await remoteDataSource.runTransaction<T>(action: action);

      return Success(result);
    } on FirebaseException catch (e) {
      return Error(
        FirestoreFailure(message: e.message ?? e.code, code: e.code),
      );
    } catch (e) {
      return Error(UnknownFailure(message: e.toString()));
    }
  }
}
