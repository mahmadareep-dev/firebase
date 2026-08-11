import 'package:get/get.dart';

import '../../../../core/errors/result.dart';
import '../../domain/usecases/log_event_usecase.dart';
import '../../domain/usecases/log_login_usecase.dart';
import '../../domain/usecases/log_screen_view_usecase.dart';
import '../../domain/usecases/log_signup_usecase.dart';
import '../../domain/usecases/reset_analytics_data_usecase.dart';
import '../../domain/usecases/set_collection_enabled_usecase.dart';
import '../../domain/usecases/set_user_id_usecase.dart';
import '../../domain/usecases/set_user_property_usecase.dart';

class FirebaseAnalyticsBuilder {
  FirebaseAnalyticsBuilder({
    LogEventUseCase? logEventUseCase,
    SetUserIdUseCase? setUserIdUseCase,
    SetUserPropertyUseCase? setUserPropertyUseCase,
    LogLoginUseCase? logLoginUseCase,
    LogSignUpUseCase? logSignUpUseCase,
    LogScreenViewUseCase? logScreenViewUseCase,
    ResetAnalyticsDataUseCase? resetAnalyticsDataUseCase,
    SetCollectionEnabledUseCase? setCollectionEnabledUseCase,
  }) : _logEventUseCase = logEventUseCase ?? Get.find<LogEventUseCase>(),
       _setUserIdUseCase = setUserIdUseCase ?? Get.find<SetUserIdUseCase>(),
       _setUserPropertyUseCase =
           setUserPropertyUseCase ?? Get.find<SetUserPropertyUseCase>(),
       _logLoginUseCase = logLoginUseCase ?? Get.find<LogLoginUseCase>(),
       _logSignUpUseCase = logSignUpUseCase ?? Get.find<LogSignUpUseCase>(),
       _logScreenViewUseCase =
           logScreenViewUseCase ?? Get.find<LogScreenViewUseCase>(),
       _resetAnalyticsDataUseCase =
           resetAnalyticsDataUseCase ?? Get.find<ResetAnalyticsDataUseCase>(),
       _setCollectionEnabledUseCase =
           setCollectionEnabledUseCase ??
           Get.find<SetCollectionEnabledUseCase>();

  final LogEventUseCase _logEventUseCase;
  final SetUserIdUseCase _setUserIdUseCase;
  final SetUserPropertyUseCase _setUserPropertyUseCase;
  final LogLoginUseCase _logLoginUseCase;
  final LogSignUpUseCase _logSignUpUseCase;
  final LogScreenViewUseCase _logScreenViewUseCase;
  final ResetAnalyticsDataUseCase _resetAnalyticsDataUseCase;
  final SetCollectionEnabledUseCase _setCollectionEnabledUseCase;

  Future<Result<void>> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) {
    return _logEventUseCase(name: name, parameters: parameters);
  }

  Future<Result<void>> setUserId(String? userId) {
    return _setUserIdUseCase(userId);
  }

  Future<Result<void>> setUserProperty({
    required String name,
    required String? value,
  }) {
    return _setUserPropertyUseCase(name: name, value: value);
  }

  Future<Result<void>> logLogin({String? method}) {
    return _logLoginUseCase(method: method);
  }

  Future<Result<void>> logSignUp({required String method}) {
    return _logSignUpUseCase(method: method);
  }

  Future<Result<void>> logScreenView({
    required String screenName,
    String? screenClass,
  }) {
    return _logScreenViewUseCase(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  Future<Result<void>> resetAnalyticsData() {
    return _resetAnalyticsDataUseCase();
  }

  Future<Result<void>> setAnalyticsCollectionEnabled(bool enabled) {
    return _setCollectionEnabledUseCase(enabled);
  }
}
