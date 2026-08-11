import 'package:cloud_functions/cloud_functions.dart';

abstract interface class FirebaseFunctionsRemoteDataSource {
  Future<dynamic> call({
    required String name,
    Map<String, dynamic>? data,
  });

  Future<dynamic> callRegion({
    required String region,
    required String name,
    Map<String, dynamic>? data,
  });

  Future<dynamic> callWithTimeout({
    required String name,
    required Duration timeout,
    Map<String, dynamic>? data,
  });
}class FirebaseFunctionsRemoteDataSourceImpl
    implements FirebaseFunctionsRemoteDataSource {

  FirebaseFunctionsRemoteDataSourceImpl();

  @override
  Future<dynamic> call({
    required String name,
    Map<String, dynamic>? data,
  }) async {
    final callable =
    FirebaseFunctions.instance.httpsCallable(name);

    final result = await callable.call(data);

    return result.data;
  }

  @override
  Future<dynamic> callRegion({
    required String region,
    required String name,
    Map<String, dynamic>? data,
  }) async {
    final callable = FirebaseFunctions.instanceFor(
      region: region,
    ).httpsCallable(name);

    final result = await callable.call(data);

    return result.data;
  }

  @override
  Future<dynamic> callWithTimeout({
    required String name,
    required Duration timeout,
    Map<String, dynamic>? data,
  }) async {
    final callable =
    FirebaseFunctions.instance
        .httpsCallable(
      name,
      options: HttpsCallableOptions(
        timeout: timeout,
      ),
    );

    final result = await callable.call(data);

    return result.data;
  }
}