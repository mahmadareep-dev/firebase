import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/result.dart';
import '../../../firestore_query/domain/entities/firestore_query_params.dart';
import '../repositories/firestore_listener_repository.dart';

class ListenQueryUseCase {
  const ListenQueryUseCase(this._repository);

  final FirestoreListenerRepository _repository;

  Stream<Result<List<T>>> call<T>({
    required FirestoreQueryParams params,
    required T Function(
        DocumentSnapshot<Map<String, dynamic>> document,
        ) fromFirestore,
  }) {
    return _repository.listen(
      params: params,
      fromFirestore: fromFirestore,
    );
  }
}