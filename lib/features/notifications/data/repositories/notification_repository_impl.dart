import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl(this._remoteDataSource);

  final NotificationRemoteDataSource _remoteDataSource;

  @override
  Future<Result<void>> initialize() async {
    try {
      await _remoteDataSource.initialize();
      return const Success(null);
    } on AppException catch (e) {
      return Error(e.failure);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<NotificationSettings>> requestPermission() async {
    try {
      final settings = await _remoteDataSource.requestPermission();
      return Success(settings);
    } on AppException catch (e) {
      return Error(e.failure);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<String?>> getToken() async {
    try {
      final token = await _remoteDataSource.getToken();
      return Success(token);
    } on AppException catch (e) {
      return Error(e.failure);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> subscribeToTopic(String topic) async {
    try {
      await _remoteDataSource.subscribeToTopic(topic);
      return const Success(null);
    } on AppException catch (e) {
      return Error(e.failure);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> unsubscribeFromTopic(String topic) async {
    try {
      await _remoteDataSource.unsubscribeFromTopic(topic);
      return const Success(null);
    } on AppException catch (e) {
      return Error(e.failure);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<RemoteMessage?>> getInitialMessage() async {
    try {
      final message = await _remoteDataSource.getInitialMessage();
      return Success(message);
    } on AppException catch (e) {
      return Error(e.failure);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> showLocalNotification(RemoteMessage message) async {
    try {
      await _remoteDataSource.showLocalNotification(message);
      return const Success(null);
    } on AppException catch (e) {
      return Error(e.failure);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Stream<RemoteMessage> get foregroundMessages =>
      _remoteDataSource.onForegroundMessage;

  @override
  Stream<RemoteMessage> get notificationOpened =>
      _remoteDataSource.onNotificationOpened;

  @override
  Stream<String> get tokenRefresh => _remoteDataSource.onTokenRefresh;
}
