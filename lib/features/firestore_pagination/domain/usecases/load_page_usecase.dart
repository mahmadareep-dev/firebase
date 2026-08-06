import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/result.dart';
import '../entities/firestore_pagination_params.dart';
import '../entities/pagination_result.dart';
import '../repositories/firestore_pagination_repository.dart';

class LoadPageUseCase {
  const LoadPageUseCase(this._repository);

  final FirestorePaginationRepository _repository;

  Future<Result<PaginationResult<T>>> call<T>({
    required FirestorePaginationParams params,
    required T Function(DocumentSnapshot<Map<String, dynamic>> document)
    fromFirestore,
  }) {
    return _repository.load<T>(params: params, fromFirestore: fromFirestore);
  }
}
