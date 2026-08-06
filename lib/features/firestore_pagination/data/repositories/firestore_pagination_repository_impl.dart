import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/firestore_pagination_params.dart';
import '../../domain/entities/pagination_result.dart';
import '../../domain/repositories/firestore_pagination_repository.dart';
import '../datasources/firestore_pagination_remote_data_source.dart';

class FirestorePaginationRepositoryImpl
    implements FirestorePaginationRepository {
  const FirestorePaginationRepositoryImpl(this._remoteDataSource);

  final FirestorePaginationRemoteDataSource _remoteDataSource;

  @override
  Future<Result<PaginationResult<T>>> load<T>({
    required FirestorePaginationParams params,
    required T Function(DocumentSnapshot<Map<String, dynamic>> document)
    fromFirestore,
  }) async {
    try {
      final result = await _remoteDataSource.load<T>(
        params: params,
        fromFirestore: fromFirestore,
      );

      return Success(result);
    } catch (e) {
      return Error(UnknownFailure(message: e.toString()));
    }
  }
}
