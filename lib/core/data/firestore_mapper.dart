abstract class FirestoreMapper<T> {
  T fromFirestore(Map<String, dynamic> json, String id);

  Map<String, dynamic> toFirestore(T entity);
}
