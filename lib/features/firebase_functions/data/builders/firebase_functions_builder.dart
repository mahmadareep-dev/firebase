import 'package:get/get.dart';

import '../../../../core/errors/result.dart';
import '../../domain/usecases/call_function_usecase.dart';
import '../../domain/usecases/call_region_function_usecase.dart';
import '../../domain/usecases/call_timeout_function_usecase.dart';

class FirebaseFunctionsBuilder {
  FirebaseFunctionsBuilder({
    CallFunctionUseCase? callFunctionUseCase,
    CallRegionFunctionUseCase? callRegionFunctionUseCase,
    CallTimeoutFunctionUseCase? callTimeoutFunctionUseCase,
  }) : _callFunctionUseCase =
           callFunctionUseCase ?? Get.find<CallFunctionUseCase>(),
       _callRegionFunctionUseCase =
           callRegionFunctionUseCase ?? Get.find<CallRegionFunctionUseCase>(),
       _callTimeoutFunctionUseCase =
           callTimeoutFunctionUseCase ?? Get.find<CallTimeoutFunctionUseCase>();

  final CallFunctionUseCase _callFunctionUseCase;
  final CallRegionFunctionUseCase _callRegionFunctionUseCase;
  final CallTimeoutFunctionUseCase _callTimeoutFunctionUseCase;

  String? _region;
  Duration? _timeout;

  /// Region

  FirebaseFunctionsBuilder region(String region) {
    _region = region;
    return this;
  }

  /// Timeout

  FirebaseFunctionsBuilder timeout(Duration timeout) {
    _timeout = timeout;
    return this;
  }

  /// Execute Function

  Future<Result<dynamic>> call({
    required String name,
    Map<String, dynamic>? data,
  }) {
    if (_region != null) {
      return _callRegionFunctionUseCase.call(
        region: _region!,
        name: name,
        data: data,
      );
    }

    if (_timeout != null) {
      return _callTimeoutFunctionUseCase.call(
        name: name,
        timeout: _timeout!,
        data: data,
      );
    }

    return _callFunctionUseCase.call(name: name, data: data);
  }
}
