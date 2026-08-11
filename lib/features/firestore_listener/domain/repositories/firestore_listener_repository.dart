import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/result.dart';
import '../../../firestore_query/domain/entities/firestore_query_params.dart';

abstract interface class FirestoreListenerRepository {
  Stream<Result<List<T>>> listen<T>({
    required FirestoreQueryParams params,
    required T Function(
        DocumentSnapshot<Map<String, dynamic>> document,
        ) fromFirestore,
  });
}