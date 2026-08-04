import '../../domain/entities/uploaded_file_entity.dart';

class UploadedFileModel extends UploadedFileEntity {
  const UploadedFileModel({
    required super.name,
    required super.path,
    required super.downloadUrl,
    super.contentType,
    required super.size,
    required super.uploadedAt,
  });

  factory UploadedFileModel.fromMap(Map<String, dynamic> map) {
    return UploadedFileModel(
      name: map['name'] ?? '',
      path: map['path'] ?? '',
      downloadUrl: map['downloadUrl'] ?? '',
      contentType: map['contentType'],
      size: map['size'] ?? 0,
      uploadedAt: DateTime.parse(map['uploadedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'path': path,
      'downloadUrl': downloadUrl,
      'contentType': contentType,
      'size': size,
      'uploadedAt': uploadedAt.toIso8601String(),
    };
  }
}
