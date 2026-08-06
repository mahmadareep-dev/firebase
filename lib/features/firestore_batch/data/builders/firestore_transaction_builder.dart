import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../core/errors/result.dart';
import '../../domain/usecases/run_transaction_usecase.dart';

class FirestoreTransactionBuilder {
  FirestoreTransactionBuilder({RunTransactionUseCase? runTransactionUseCase})
    : _runTransactionUseCase =
          runTransactionUseCase ?? Get.find<RunTransactionUseCase>();

  final RunTransactionUseCase _runTransactionUseCase;

  Future<Result<T>> run<T>({
    required Future<T> Function(Transaction transaction) action,
  }) {
    return _runTransactionUseCase(action: action);
  }
}
