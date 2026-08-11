import '../../../../core/errors/result.dart';
import '../../../../core/firestore/typedefs/decoder.dart';

abstract interface class FirebaseFunctionsRepository {
  Future<Result<T>> call<T>({
    required String name,
    Map<String, dynamic>? data,
    Decoder<T>? decoder,
  });

  Future<Result<T>> callRegion<T>({
    required String region,
    required String name,
    Map<String, dynamic>? data,
    Decoder<T>? decoder,
  });

  Future<Result<T>> callWithTimeout<T>({
    required String name,
    required Duration timeout,
    Map<String, dynamic>? data,
    Decoder<T>? decoder,
  });
}
