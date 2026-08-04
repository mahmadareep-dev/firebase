class UserEntity {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String photoUrl;
  final String role;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserEntity({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.photoUrl,
    required this.role,
    this.createdAt,
    this.updatedAt,
  });
}
