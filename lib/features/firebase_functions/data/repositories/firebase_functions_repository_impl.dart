import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/firestore/typedefs/decoder.dart';
import '../../domain/repositories/firebase_functions_repository.dart';
import '../datasources/firebase_functions_remote_data_source.dart';

class FirebaseFunctionsRepositoryImpl implements FirebaseFunctionsRepository {
  FirebaseFunctionsRepositoryImpl(this._remote);

  final FirebaseFunctionsRemoteDataSource _remote;

  @override
  Future<Result<T>> call<T>({
    required String name,
    Map<String, dynamic>? data,
    Decoder<T>? decoder,
  }) async {
    try {
      final raw = await _remote.call(name: name, data: data);

      final value = decoder != null ? decoder(raw) : raw as T;

      return Success(value);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<T>> callRegion<T>({
    required String region,
    required String name,
    Map<String, dynamic>? data,
    Decoder<T>? decoder,
  }) async {
    try {
      final raw = await _remote.callRegion(
        region: region,
        name: name,
        data: data,
      );

      final value = decoder != null ? decoder(raw) : raw as T;

      return Success(value);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Result<T>> callWithTimeout<T>({
    required String name,
    required Duration timeout,
    Map<String, dynamic>? data,
    Decoder<T>? decoder,
  }) async {
    try {
      final raw = await _remote.callWithTimeout(
        name: name,
        timeout: timeout,
        data: data,
      );

      final value = decoder != null ? decoder(raw) : raw as T;

      return Success(value);
    } catch (e) {
      return Error(ServerFailure(message: e.toString()));
    }
  }
}
