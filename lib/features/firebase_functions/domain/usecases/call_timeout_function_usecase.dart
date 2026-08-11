import '../../../../core/errors/result.dart';
import '../repositories/firebase_functions_repository.dart';

class CallTimeoutFunctionUseCase {
  CallTimeoutFunctionUseCase(this._repository);

  final FirebaseFunctionsRepository _repository;

  Future<Result<dynamic>> call({
    required String name,
    required Duration timeout,
    Map<String, dynamic>? data,
  }) {
    return _repository.callWithTimeout(
      name: name,
      timeout: timeout,
      data: data,
    );
  }
}