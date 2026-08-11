import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../features/firestore_query/domain/entities/firestore_query_params.dart';

class FirestoreCursorEngine {
  const FirestoreCursorEngine();

  Query<Map<String, dynamic>> apply(Query<Map<String, dynamic>> query,
      FirestoreQueryParams params,) {
    if (params.limit != null) {
      query = params.limitToLast
          ? query.limitToLast(params.limit!)
          : query.limit(params.limit!);
    }

    if (params.startAfter != null) {
      query = query.startAfterDocument(
        params.startAfter!,
      );
    }

    if (params.startAt != null) {
      query = query.startAtDocument(
        params.startAt!,
      );
    }

    if (params.endBefore != null) {
      query = query.endBeforeDocument(
        params.endBefore!,
      );
    }

    if (params.endAt != null) {
      query = query.endAtDocument(
        params.endAt!,
      );
    }

    return query;
  }
}