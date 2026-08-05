import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/result.dart';
import '../entities/firestore_query_params.dart';

abstract interface class FirestoreQueryRepository {
  Future<Result<List<T>>> execute<T>({
    required FirestoreQueryParams params,
    required T Function(DocumentSnapshot<Map<String, dynamic>> document)
    fromFirestore,
  });

  Stream<Result<List<T>>> watch<T>({
    required FirestoreQueryParams params,
    required T Function(DocumentSnapshot<Map<String, dynamic>> document)
    fromFirestore,
  });
}
