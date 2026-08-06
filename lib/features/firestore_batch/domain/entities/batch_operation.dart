import 'package:cloud_firestore/cloud_firestore.dart';

enum BatchOperationType { set, update, delete }

class BatchOperation {
  final BatchOperationType type;

  final String collection;

  final String documentId;

  final Map<String, dynamic>? data;

  final SetOptions? setOptions;

  const BatchOperation({
    required this.type,
    required this.collection,
    required this.documentId,
    this.data,
    this.setOptions,
  });

  BatchOperation copyWith({
    BatchOperationType? type,
    String? collection,
    String? documentId,
    Map<String, dynamic>? data,
    SetOptions? setOptions,
  }) {
    return BatchOperation(
      type: type ?? this.type,
      collection: collection ?? this.collection,
      documentId: documentId ?? this.documentId,
      data: data ?? this.data,
      setOptions: setOptions ?? this.setOptions,
    );
  }
}
