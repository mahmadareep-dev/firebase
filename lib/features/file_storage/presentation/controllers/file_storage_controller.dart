import 'dart:io';

import 'package:get/get.dart';

import '../../../../core/base/base_controller.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/services/file_picker/file_picker_service.dart';
import '../../domain/entities/uploaded_file_entity.dart';
import '../../domain/usecases/delete_file_usecase.dart';
import '../../domain/usecases/get_download_url_usecase.dart';
import '../../domain/usecases/list_files_usecase.dart';
import '../../domain/usecases/upload_file_usecase.dart';

class FileStorageController extends BaseController {
  final UploadFileUseCase _uploadFileUseCase;
  final DeleteFileUseCase _deleteFileUseCase;
  final GetDownloadUrlUseCase _getDownloadUrlUseCase;
  final ListFilesUseCase _listFilesUseCase;
  final FilePickerService _filePickerService;

  FileStorageController({
    required this._uploadFileUseCase,
    required this._deleteFileUseCase,
    required this._getDownloadUrlUseCase,
    required this._listFilesUseCase,
    required this._filePickerService,
  });

  final Rx<UploadedFileEntity?> uploadedFile = Rx<UploadedFileEntity?>(null);

  final RxList<UploadedFileEntity> files = <UploadedFileEntity>[].obs;

  final RxString downloadUrl = ''.obs;

  final RxDouble uploadProgress = 0.0.obs;

  Future<bool> uploadFile({
    required File file,
    required String path,
    String? fileName,
    Map<String, String>? metadata,
  }) async {
    setSaving(true);

    final result = await _uploadFileUseCase(
      file: file,
      path: path,
      fileName: fileName,
      metadata: metadata,
    );

    setSaving(false);

    return result.when(
      success: (data) {
        uploadedFile.value = data;
        downloadUrl.value = data.downloadUrl;
        return true;
      },
      failure: (failure) {
        setError(failure.message);
        return false;
      },
    );
  }

  Future<bool> deleteFile(String path) async {
    setLoading(true);

    final result = await _deleteFileUseCase(path);

    setLoading(false);

    return result.when(
      success: (_) {
        return true;
      },
      failure: (failure) {
        setError(failure.message);
        return false;
      },
    );
  }

  Future<void> loadFiles(String path) async {
    setLoading(true);

    final Result<List<UploadedFileEntity>> result = await _listFilesUseCase(
      path,
    );

    setLoading(false);

    result.when(
      success: (data) {
        files.assignAll(data);
      },
      failure: (failure) {
        setError(failure.message);
        return false;
      },
    );
  }

  Future<String?> getDownloadUrl(String path) async {
    final result = await _getDownloadUrlUseCase(path);

    return result.when(
      success: (url) {
        downloadUrl.value = url;
        return url;
      },
      failure: (failure) {
        setError(failure.message);
        return null;
      },
    );
  }

  Future<bool> pickAndUploadImage({
    required String path,
    String? fileName,
    Map<String, String>? metadata,
  }) async {
    final File? file = await _filePickerService.pickImageFromGallery();

    if (file == null) {
      return false;
    }

    return uploadFile(
      file: file,
      path: path,
      fileName: fileName,
      metadata: metadata,
    );
  }

  Future<bool> pickAndUploadImageFromCamera({
    required String path,
    String? fileName,
    Map<String, String>? metadata,
  }) async {
    final File? file = await _filePickerService.pickImageFromCamera();

    if (file == null) {
      return false;
    }

    return uploadFile(
      file: file,
      path: path,
      fileName: fileName,
      metadata: metadata,
    );
  }

  Future<bool> pickAndUploadDocument({
    required String path,
    String? fileName,
    Map<String, String>? metadata,
  }) async {
    final File? file = await _filePickerService.pickDocument();

    if (file == null) {
      return false;
    }

    return uploadFile(
      file: file,
      path: path,
      fileName: fileName,
      metadata: metadata,
    );
  }

  Future<bool> pickAndUploadVideo({
    required String path,
    String? fileName,
    Map<String, String>? metadata,
  }) async {
    final File? file = await _filePickerService.pickVideoFromGallery();

    if (file == null) {
      return false;
    }

    return uploadFile(
      file: file,
      path: path,
      fileName: fileName,
      metadata: metadata,
    );
  }

  void clear() {
    uploadedFile.value = null;
    files.clear();
    downloadUrl.value = '';
    uploadProgress.value = 0;
  }
}
