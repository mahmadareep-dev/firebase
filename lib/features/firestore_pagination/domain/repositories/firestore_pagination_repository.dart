import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/result.dart';
import '../entities/firestore_pagination_params.dart';
import '../entities/pagination_result.dart';

abstract interface class FirestorePaginationRepository {
  Future<Result<PaginationResult<T>>> load<T>({
    required FirestorePaginationParams params,
    required T Function(
        DocumentSnapshot<Map<String, dynamic>> document,
        ) fromFirestore,
  });
}