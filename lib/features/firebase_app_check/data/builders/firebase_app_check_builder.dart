import 'package:get/get.dart';

import '../../../../core/errors/result.dart';
import '../../domain/usecases/activate_app_check_usecase.dart';
import '../../domain/usecases/get_app_check_token_usecase.dart';
import '../../domain/usecases/get_limited_use_token_usecase.dart';
import '../../domain/usecases/set_token_auto_refresh_usecase.dart';

class FirebaseAppCheckBuilder {
  FirebaseAppCheckBuilder({
    ActivateAppCheckUseCase? activateUseCase,
    GetAppCheckTokenUseCase? getTokenUseCase,
    GetLimitedUseTokenUseCase? getLimitedUseTokenUseCase,
    SetTokenAutoRefreshUseCase? setTokenAutoRefreshUseCase,
  }) : _activateUseCase =
           activateUseCase ?? Get.find<ActivateAppCheckUseCase>(),
       _getTokenUseCase =
           getTokenUseCase ?? Get.find<GetAppCheckTokenUseCase>(),
       _getLimitedUseTokenUseCase =
           getLimitedUseTokenUseCase ?? Get.find<GetLimitedUseTokenUseCase>(),
       _setTokenAutoRefreshUseCase =
           setTokenAutoRefreshUseCase ?? Get.find<SetTokenAutoRefreshUseCase>();

  final ActivateAppCheckUseCase _activateUseCase;
  final GetAppCheckTokenUseCase _getTokenUseCase;
  final GetLimitedUseTokenUseCase _getLimitedUseTokenUseCase;
  final SetTokenAutoRefreshUseCase _setTokenAutoRefreshUseCase;

  Future<Result<void>> activate() {
    return _activateUseCase();
  }

  Future<Result<String?>> getToken() {
    return _getTokenUseCase();
  }

  Future<Result<String>> getLimitedUseToken() {
    return _getLimitedUseTokenUseCase();
  }

  Future<Result<void>> setTokenAutoRefreshEnabled(bool enabled) {
    return _setTokenAutoRefreshUseCase(enabled);
  }
}
