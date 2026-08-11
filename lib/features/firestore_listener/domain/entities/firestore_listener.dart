import 'dart:async';

class FirestoreListener<T> {
  FirestoreListener(this._subscription);

  final StreamSubscription<T> _subscription;

  bool _disposed = false;

  bool get isDisposed => _disposed;

  void pause() {
    _subscription.pause();
  }

  void resume() {
    _subscription.resume();
  }

  Future<void> cancel() async {
    if (_disposed) return;

    _disposed = true;

    await _subscription.cancel();
  }
}
