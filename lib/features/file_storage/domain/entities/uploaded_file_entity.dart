class UploadedFileEntity {
  final String name;
  final String path;
  final String downloadUrl;
  final String? contentType;
  final int size;
  final DateTime uploadedAt;

  const UploadedFileEntity({
    required this.name,
    required this.path,
    required this.downloadUrl,
    this.contentType,
    required this.size,
    required this.uploadedAt,
  });

  String get extension {
    final index = name.lastIndexOf('.');
    if (index == -1) return '';
    return name.substring(index + 1);
  }

  bool get isImage =>
      ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension.toLowerCase());

  bool get isVideo =>
      ['mp4', 'mov', 'avi', 'mkv'].contains(extension.toLowerCase());

  bool get isPdf => extension.toLowerCase() == 'pdf';
}
