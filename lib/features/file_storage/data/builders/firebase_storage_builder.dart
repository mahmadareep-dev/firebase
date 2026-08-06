import 'dart:io';

import 'package:get/get.dart';

import '../../../../core/errors/result.dart';
import '../../domain/entities/uploaded_file_entity.dart';
import '../../domain/usecases/delete_file_usecase.dart';
import '../../domain/usecases/get_download_url_usecase.dart';
import '../../domain/usecases/list_files_usecase.dart';
import '../../domain/usecases/upload_file_usecase.dart';

class FirebaseStorageBuilder {
  FirebaseStorageBuilder({
    UploadFileUseCase? uploadFileUseCase,
    DeleteFileUseCase? deleteFileUseCase,
    ListFilesUseCase? listFilesUseCase,
    GetDownloadUrlUseCase? getDownloadUrlUseCase,
  }) : _uploadFileUseCase = uploadFileUseCase ?? Get.find<UploadFileUseCase>(),
       _deleteFileUseCase = deleteFileUseCase ?? Get.find<DeleteFileUseCase>(),
       _listFilesUseCase = listFilesUseCase ?? Get.find<ListFilesUseCase>(),
       _getDownloadUrlUseCase =
           getDownloadUrlUseCase ?? Get.find<GetDownloadUrlUseCase>();

  final UploadFileUseCase _uploadFileUseCase;
  final DeleteFileUseCase _deleteFileUseCase;
  final ListFilesUseCase _listFilesUseCase;
  final GetDownloadUrlUseCase _getDownloadUrlUseCase;

  /// Upload any file
  Future<Result<UploadedFileEntity>> uploadFile({
    required File file,
    required String path,
    String? fileName,
    Map<String, String>? metadata,
  }) {
    return _uploadFileUseCase(
      file: file,
      path: path,
      fileName: fileName,
      metadata: metadata,
    );
  }

  /// Upload image
  Future<Result<UploadedFileEntity>> uploadImage({
    required File image,
    required String path,
    String? fileName,
    Map<String, String>? metadata,
  }) {
    return _uploadFileUseCase(
      file: image,
      path: path,
      fileName: fileName,
      metadata: metadata,
    );
  }

  /// Delete file
  Future<Result<void>> deleteFile({required String path}) {
    return _deleteFileUseCase(path);
  }

  /// Get download url
  Future<Result<String>> getDownloadUrl({required String path}) {
    return _getDownloadUrlUseCase(path);
  }

  /// List all files under a path
  Future<Result<List<UploadedFileEntity>>> listFiles({required String path}) {
    return _listFilesUseCase(path);
  }
}
