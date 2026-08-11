import '../../../../core/errors/result.dart';
import '../repositories/firebase_functions_repository.dart';

class CallFunctionUseCase {
  CallFunctionUseCase(this._repository);

  final FirebaseFunctionsRepository _repository;

  Future<Result<dynamic>> call({
    required String name,
    Map<String, dynamic>? data,
  }) {
    return _repository.call(name: name, data: data);
  }
}
