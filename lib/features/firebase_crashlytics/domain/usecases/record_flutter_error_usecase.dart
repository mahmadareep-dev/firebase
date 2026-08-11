import 'package:flutter/foundation.dart';

import '../../../../core/errors/result.dart';
import '../repositories/firebase_crashlytics_repository.dart';

class RecordFlutterErrorUseCase {
  RecordFlutterErrorUseCase(this._repository);

  final FirebaseCrashlyticsRepository _repository;

  Future<Result<void>> call(FlutterErrorDetails details) {
    return _repository.recordFlutterError(details);
  }
}
