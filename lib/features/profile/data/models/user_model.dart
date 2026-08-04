import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firebase/firestore_fields.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.name,
    required super.email,
    required super.phone,
    required super.photoUrl,
    required super.role,
    super.createdAt,
    super.updatedAt,
  });

  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? {};

    return UserModel(
      uid: data[FirestoreFields.uid] as String? ?? document.id,
      name: data[FirestoreFields.name] as String? ?? '',
      email: data[FirestoreFields.email] as String? ?? '',
      phone: data[FirestoreFields.phone] as String? ?? '',
      photoUrl: data[FirestoreFields.photoUrl] as String? ?? '',
      role: data[FirestoreFields.role] as String? ?? 'user',
      createdAt: _timestampToDateTime(data[FirestoreFields.createdAt]),
      updatedAt: _timestampToDateTime(data[FirestoreFields.updatedAt]),
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      uid: entity.uid,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      photoUrl: entity.photoUrl,
      role: entity.role,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      FirestoreFields.uid: uid,
      FirestoreFields.name: name,
      FirestoreFields.email: email,
      FirestoreFields.phone: phone,
      FirestoreFields.photoUrl: photoUrl,
      FirestoreFields.role: role,
      FirestoreFields.createdAt: createdAt,
      FirestoreFields.updatedAt: updatedAt,
    };
  }

  static DateTime? _timestampToDateTime(dynamic value) {
    if (value is Timestamp) return value.toDate();

    if (value is DateTime) return value;

    return null;
  }
}
