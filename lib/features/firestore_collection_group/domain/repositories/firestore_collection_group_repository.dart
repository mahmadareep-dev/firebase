import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/errors/result.dart';
import '../../../firestore_query/domain/entities/firestore_query_params.dart';

abstract interface class FirestoreCollectionGroupRepository {
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
