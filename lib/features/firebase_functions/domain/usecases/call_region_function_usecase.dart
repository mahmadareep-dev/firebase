import '../../../../core/errors/result.dart';
import '../repositories/firebase_functions_repository.dart';

class CallRegionFunctionUseCase {
  CallRegionFunctionUseCase(this._repository);

  final FirebaseFunctionsRepository _repository;

  Future<Result<dynamic>> call({
    required String region,
    required String name,
    Map<String, dynamic>? data,
  }) {
    return _repository.callRegion(
      region: region,
      name: name,
      data: data,
    );
  }
}