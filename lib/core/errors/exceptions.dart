class ServerException implements Exception {
  final String message;

  const ServerException(this.message);
}

class FirestoreException implements Exception {
  final String message;

  const FirestoreException(this.message);
}

class AuthException implements Exception {
  final String message;

  const AuthException(this.message);
}

class CacheException implements Exception {
  final String message;

  const CacheException(this.message);
}
