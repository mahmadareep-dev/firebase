import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/result.dart';
import '../entities/firestore_query_params.dart';
import '../repositories/firestore_query_repository.dart';

class WatchQueryUseCase {
  const WatchQueryUseCase(this._repository);

  final FirestoreQueryRepository _repository;

  Stream<Result<List<T>>> call<T>({
    required FirestoreQueryParams params,
    required T Function(DocumentSnapshot<Map<String, dynamic>> document)
    fromFirestore,
  }) {
    return _repository.watch<T>(params: params, fromFirestore: fromFirestore);
  }
}
