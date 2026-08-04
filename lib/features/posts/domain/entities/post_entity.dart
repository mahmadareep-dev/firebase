class PostEntity {
  final String id;
  final String title;
  final String description;
  final String userId;
  final String userName;
  final String userPhoto;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PostEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.userId,
    required this.userName,
    required this.userPhoto,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  PostEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? userId,
    String? userName,
    String? userPhoto,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PostEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhoto: userPhoto ?? this.userPhoto,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          userId == other.userId &&
          userName == other.userName &&
          userPhoto == other.userPhoto &&
          imageUrl == other.imageUrl &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    userId,
    userName,
    userPhoto,
    imageUrl,
    createdAt,
    updatedAt,
  );
}
