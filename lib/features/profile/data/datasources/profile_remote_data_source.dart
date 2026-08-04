import 'package:firebase/core/constants/firebase/firestore_collections.dart';
import 'package:firebase/core/services/firebase/firestore_service.dart';

import '../models/user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel?> getProfile(String uid);

  Future<void> saveProfile(UserModel user);

  Future<void> updateProfile(UserModel user);

  Future<void> deleteProfile(String uid);

  Future<bool> profileExists(String uid);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirestoreService firestoreService;

  ProfileRemoteDataSourceImpl({required this.firestoreService});

  @override
  Future<UserModel?> getProfile(String uid) async {
    final document = await firestoreService.getDocument(
      collection: FirestoreCollections.users,
      documentId: uid,
    );

    if (!document.exists) {
      return null;
    }

    return UserModel.fromFirestore(document);
  }

  @override
  Future<void> saveProfile(UserModel user) async {
    await firestoreService.create(
      collection: FirestoreCollections.users,
      documentId: user.uid,
      data: user.toFirestore(),
    );
  }

  @override
  Future<void> updateProfile(UserModel user) async {
    await firestoreService
        .document(FirestoreCollections.users, user.uid)
        .update(user.toFirestore());
  }

  @override
  Future<void> deleteProfile(String uid) async {
    await firestoreService.delete(
      collection: FirestoreCollections.users,
      documentId: uid,
    );
  }

  @override
  Future<bool> profileExists(String uid) async {
    final document = await firestoreService.getDocument(
      collection: FirestoreCollections.users,
      documentId: uid,
    );

    return document.exists;
  }
}
