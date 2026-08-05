import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/result.dart';
import '../entities/firestore_query_params.dart';
import '../repositories/firestore_query_repository.dart';

class ExecuteQueryUseCase {
  const ExecuteQueryUseCase(
      this._repository,
      );

  final FirestoreQueryRepository _repository;

  Future<Result<List<T>>> call<T>({
    required FirestoreQueryParams params,
    required T Function(
        DocumentSnapshot<Map<String, dynamic>> document,
        ) fromFirestore,
  }) {
    return _repository.execute<T>(
      params: params,
      fromFirestore: fromFirestore,
    );
  }
}