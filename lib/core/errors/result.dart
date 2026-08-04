import 'failure.dart';

sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;

  bool get isFailure => this is Error<T>;

  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  });
}

class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) {
    return success(data);
  }
}

class Error<T> extends Result<T> {
  final Failure failureData;

  const Error(this.failureData);

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) {
    return failure(failureData);
  }
}
