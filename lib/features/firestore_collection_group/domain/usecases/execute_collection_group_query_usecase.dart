import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/result.dart';
import '../../../firestore_query/domain/entities/firestore_query_params.dart';
import '../repositories/firestore_collection_group_repository.dart';

class ExecuteCollectionGroupQueryUseCase {
  ExecuteCollectionGroupQueryUseCase(this._repository);

  final FirestoreCollectionGroupRepository _repository;

  Future<Result<List<T>>> call<T>({
    required FirestoreQueryParams params,
    required T Function(DocumentSnapshot<Map<String, dynamic>> document)
    fromFirestore,
  }) {
    return _repository.execute(params: params, fromFirestore: fromFirestore);
  }
}
