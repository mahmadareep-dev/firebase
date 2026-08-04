import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/services/connectivity/connectivity_service.dart';
import '../../core/services/file_picker/file_picker_service.dart';
import '../../core/services/firebase/firestore_service.dart';
import '../../core/services/firebase/notification_service.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/change_password_usecase.dart';
import '../../features/auth/domain/usecases/check_email_verification_usecase.dart';
import '../../features/auth/domain/usecases/complete_profile_usecase.dart';
import '../../features/auth/domain/usecases/delete_account_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/observe_auth_state_usecase.dart';
import '../../features/auth/domain/usecases/reload_current_user_usecase.dart';
import '../../features/auth/domain/usecases/resend_verification_email_usecase.dart';
import '../../features/auth/domain/usecases/send_password_reset_email_usecase.dart';
import '../../features/auth/domain/usecases/send_phone_otp_usecase.dart';
import '../../features/auth/domain/usecases/sign_in_with_email_usecase.dart';
import '../../features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import '../../features/auth/domain/usecases/sign_up_with_email_usecase.dart';
import '../../features/auth/domain/usecases/verify_phone_otp_usecase.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/controllers/auth_session_controller.dart';
import '../../features/auth/presentation/controllers/complete_profile_controller.dart';
import '../../features/auth/presentation/controllers/phone_auth_controller.dart';
import '../../features/connectivity/data/datasources/connectivity_remote_data_source.dart';
import '../../features/connectivity/data/repositories/connectivity_repository_impl.dart';
import '../../features/connectivity/domain/repositories/connectivity_repository.dart';
import '../../features/connectivity/domain/usecases/check_connection_usecase.dart';
import '../../features/connectivity/domain/usecases/watch_connection_usecase.dart';
import '../../features/file_storage/data/datasources/file_storage_remote_data_source.dart';
import '../../features/file_storage/data/repositories/file_storage_repository_impl.dart';
import '../../features/file_storage/domain/repositories/file_storage_repository.dart';
import '../../features/file_storage/domain/usecases/delete_file_usecase.dart';
import '../../features/file_storage/domain/usecases/get_download_url_usecase.dart';
import '../../features/file_storage/domain/usecases/list_files_usecase.dart';
import '../../features/file_storage/domain/usecases/upload_file_usecase.dart';
import '../../features/file_storage/presentation/controllers/file_storage_controller.dart';
import '../../features/notifications/data/datasources/notification_remote_data_source.dart';
import '../../features/notifications/data/repositories/notification_repository_impl.dart';
import '../../features/notifications/domain/repositories/notification_repository.dart';
import '../../features/notifications/domain/usecases/get_fcm_token_usecase.dart';
import '../../features/notifications/domain/usecases/get_initial_message_usecase.dart';
import '../../features/notifications/domain/usecases/initialize_notifications_usecase.dart';
import '../../features/notifications/domain/usecases/request_notification_permission_usecase.dart';
import '../../features/notifications/domain/usecases/show_local_notification_usecase.dart';
import '../../features/notifications/domain/usecases/subscribe_topic_usecase.dart';
import '../../features/notifications/domain/usecases/unsubscribe_topic_usecase.dart';
import '../../features/notifications/presentation/controllers/notification_controller.dart';
import '../../features/posts/data/datasources/post_remote_data_source.dart';
import '../../features/posts/data/repositories/post_repository_impl.dart';
import '../../features/posts/domain/repositories/post_repository.dart';
import '../../features/posts/domain/usecases/add_post_usecase.dart';
import '../../features/posts/domain/usecases/delete_post_usecase.dart';
import '../../features/posts/domain/usecases/get_paginated_posts_usecase.dart';
import '../../features/posts/domain/usecases/get_posts_usecase.dart';
import '../../features/posts/domain/usecases/update_post_usecase.dart';
import '../../features/posts/domain/usecases/watch_posts_usecase.dart';
import '../../features/posts/presentation/controllers/paginated_post_controller.dart';
import '../../features/posts/presentation/controllers/post_controller.dart';
import '../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/ensure_user_profile_usecase.dart';
import '../../features/profile/domain/usecases/get_user_profile_usecase.dart';
import '../../features/profile/domain/usecases/save_user_profile_usecase.dart';
import '../../features/profile/domain/usecases/update_profile_usecase.dart';
import '../../features/profile/presentation/controllers/profile_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    /// 1. EXTERNAL DEPENDENCIES
    Get.lazyPut<FirebaseAuth>(() => FirebaseAuth.instance, fenix: true);

    Get.lazyPut<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
      fenix: true,
    );
    Get.lazyPut<FirebaseMessaging>(
      () => FirebaseMessaging.instance,
      fenix: true,
    );

    Get.lazyPut<FlutterLocalNotificationsPlugin>(
      () => FlutterLocalNotificationsPlugin(),
      fenix: true,
    );
    Get.lazyPut<NotificationService>(
      () => NotificationService(
        Get.find<FirebaseMessaging>(),
        Get.find<FlutterLocalNotificationsPlugin>(),
      ),
      fenix: true,
    );
    Get.lazyPut<GoogleSignIn>(() => GoogleSignIn.instance, fenix: true);

    Get.lazyPut<FirestoreService>(() => FirestoreService.instance, fenix: true);
    Get.lazyPut<ConnectivityService>(() => ConnectivityService(), fenix: true);
    Get.lazyPut<FirebaseStorage>(() => FirebaseStorage.instance, fenix: true);
    Get.lazyPut<FilePickerService>(() => FilePickerServiceImpl(), fenix: true);
    Get.lazyPut(() => Connectivity());

    /// 2. DATA SOURCES
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        firebaseAuth: Get.find<FirebaseAuth>(),
        googleSignIn: Get.find<GoogleSignIn>(),
      ),
      fenix: true,
    );
    Get.lazyPut<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(
        firestoreService: Get.find<FirestoreService>(),
      ),
      fenix: true,
    );
    Get.lazyPut<NotificationRemoteDataSource>(
      () => NotificationRemoteDataSourceImpl(Get.find<NotificationService>()),
      fenix: true,
    );
    Get.lazyPut<PostRemoteDataSource>(
      () => PostRemoteDataSourceImpl(
        firestoreService: Get.find<FirestoreService>(),
      ),
      fenix: true,
    );
    Get.lazyPut<FileStorageRemoteDataSource>(
      () => FileStorageRemoteDataSourceImpl(Get.find<FirebaseStorage>()),
      fenix: true,
    );
    Get.lazyPut<ConnectivityRemoteDataSource>(
      () => ConnectivityRemoteDataSourceImpl(Get.find()),
    );

    /// 3. REPOSITORIES
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: Get.find<AuthRemoteDataSource>(),
      ),
      fenix: true,
    );

    Get.lazyPut<ProfileRepository>(
      () => ProfileRepositoryImpl(
        remoteDataSource: Get.find<ProfileRemoteDataSource>(),
      ),
      fenix: true,
    );
    Get.lazyPut<NotificationRepository>(
      () =>
          NotificationRepositoryImpl(Get.find<NotificationRemoteDataSource>()),
      fenix: true,
    );
    Get.lazyPut<PostRepository>(
      () => PostRepositoryImpl(remoteDataSource: Get.find()),
      fenix: true,
    );
    Get.lazyPut<FileStorageRepository>(
      () => FileStorageRepositoryImpl(remoteDataSource: Get.find()),
      fenix: true,
    );
    Get.lazyPut<ConnectivityRepository>(
      () => ConnectivityRepositoryImpl(Get.find()),
    );

    /// 4. AUTH USE CASES
    Get.lazyPut<SignInWithEmailUseCase>(
      () => SignInWithEmailUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );

    Get.lazyPut<SignUpWithEmailUseCase>(
      () => SignUpWithEmailUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );

    Get.lazyPut<SignInWithGoogleUseCase>(
      () => SignInWithGoogleUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );

    Get.lazyPut<LogoutUseCase>(
      () => LogoutUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );

    Get.lazyPut<CheckEmailVerificationUseCase>(
      () => CheckEmailVerificationUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );

    Get.lazyPut<ResendVerificationEmailUseCase>(
      () => ResendVerificationEmailUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );

    Get.lazyPut<SendPhoneOtpUseCase>(
      () => SendPhoneOtpUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );

    Get.lazyPut<VerifyPhoneOtpUseCase>(
      () => VerifyPhoneOtpUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );

    Get.lazyPut<CompleteProfileUseCase>(
      () => CompleteProfileUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );

    Get.lazyPut<ChangePasswordUseCase>(
      () => ChangePasswordUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );

    Get.lazyPut<DeleteAccountUseCase>(
      () => DeleteAccountUseCase(
        authRepository: Get.find<AuthRepository>(),
        profileRepository: Get.find<ProfileRepository>(),
      ),
      fenix: true,
    );
    Get.lazyPut<ObserveAuthStateUseCase>(
      () => ObserveAuthStateUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );
    Get.lazyPut<ReloadCurrentUserUseCase>(
      () => ReloadCurrentUserUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );
    Get.lazyPut<SendPasswordResetEmailUseCase>(
      () => SendPasswordResetEmailUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );

    /// 5. PROFILE USE CASES
    Get.lazyPut<SaveUserProfileUseCase>(
      () => SaveUserProfileUseCase(Get.find<ProfileRepository>()),
      fenix: true,
    );

    Get.lazyPut<GetUserProfileUseCase>(
      () => GetUserProfileUseCase(Get.find<ProfileRepository>()),
      fenix: true,
    );

    Get.lazyPut<EnsureUserProfileUseCase>(
      () => EnsureUserProfileUseCase(Get.find<ProfileRepository>()),
      fenix: true,
    );
    Get.lazyPut(() => UpdateProfileUseCase(Get.find()));

    /// 6. NOTIFICATIONS USECASES
    Get.lazyPut(() => InitializeNotificationUseCase(Get.find()), fenix: true);

    Get.lazyPut(
      () => RequestNotificationPermissionUseCase(Get.find()),
      fenix: true,
    );

    Get.lazyPut(() => GetFcmTokenUseCase(Get.find()), fenix: true);

    Get.lazyPut(() => GetInitialMessageUseCase(Get.find()), fenix: true);

    Get.lazyPut(() => SubscribeTopicUseCase(Get.find()), fenix: true);

    Get.lazyPut(() => UnsubscribeTopicUseCase(Get.find()), fenix: true);

    Get.lazyPut(() => ShowLocalNotificationUseCase(Get.find()), fenix: true);

    /// 7. POSTS USECASES

    Get.lazyPut(() => AddPostUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => UpdatePostUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => DeletePostUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetPostsUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => WatchPostsUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetPaginatedPostsUseCase(Get.find()), fenix: true);

    /// 8. FILE STORAGE USECASES
    Get.lazyPut(
      () => UploadFileUseCase(Get.find<FileStorageRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => DeleteFileUseCase(Get.find<FileStorageRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => GetDownloadUrlUseCase(Get.find<FileStorageRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => ListFilesUseCase(Get.find<FileStorageRepository>()),
      fenix: true,
    );

    /// 9. CONNECTIVITY USECASES
    Get.lazyPut<ConnectivityRepository>(
      () => ConnectivityRepositoryImpl(Get.find()),
    );

    Get.lazyPut(() => CheckConnectionUseCase(Get.find()));

    Get.lazyPut(() => WatchConnectionUseCase(Get.find()));

    /// 10. SEARCH USECASES

    /// 11. CONTROLLERS
    Get.lazyPut<AuthController>(
      () => AuthController(
        signInWithEmailUseCase: Get.find<SignInWithEmailUseCase>(),
        signInWithGoogleUseCase: Get.find<SignInWithGoogleUseCase>(),
        signUpWithEmailUseCase: Get.find<SignUpWithEmailUseCase>(),
        checkEmailVerificationUseCase:
            Get.find<CheckEmailVerificationUseCase>(),
        resendVerificationEmailUseCase:
            Get.find<ResendVerificationEmailUseCase>(),
        logoutUseCase: Get.find<LogoutUseCase>(),
        changePasswordUseCase: Get.find<ChangePasswordUseCase>(),
        deleteAccountUseCase: Get.find<DeleteAccountUseCase>(),
        authRepository: Get.find<AuthRepository>(),
        ensureUserProfileUseCase: Get.find<EnsureUserProfileUseCase>(),
        sendPasswordResetEmailUseCase:
            Get.find<SendPasswordResetEmailUseCase>(),
      ),

      fenix: true,
    );

    Get.lazyPut<PhoneAuthController>(
      () => PhoneAuthController(
        sendPhoneOtpUseCase: Get.find<SendPhoneOtpUseCase>(),
        verifyPhoneOtpUseCase: Get.find<VerifyPhoneOtpUseCase>(),
      ),
      fenix: true,
    );

    Get.lazyPut<CompleteProfileController>(
      () => CompleteProfileController(
        completeProfileUseCase: Get.find(),
        saveUserProfileUseCase: Get.find(),
        authRepository: Get.find(),
      ),
      fenix: true,
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(
        getUserProfileUseCase: Get.find<GetUserProfileUseCase>(),
        authRepository: Get.find<AuthRepository>(),
        updateProfileUseCase: Get.find(),
      ),
      fenix: true,
    );
    Get.put<AuthSessionController>(
      AuthSessionController(
        observeAuthStateUseCase: Get.find<ObserveAuthStateUseCase>(),
        getUserProfileUseCase: Get.find<GetUserProfileUseCase>(),
        reloadCurrentUserUseCase: Get.find<ReloadCurrentUserUseCase>(),
        authRepository: Get.find<AuthRepository>(),
      ),
      permanent: true,
    );
    Get.put(
      NotificationController(
        initializeNotificationUseCase: Get.find(),
        requestPermissionUseCase: Get.find(),
        getFcmTokenUseCase: Get.find(),
        getInitialMessageUseCase: Get.find(),
        showLocalNotificationUseCase: Get.find(),
        repository: Get.find(),
      ),
      permanent: true,
    );
    Get.lazyPut(
      () => PostController(
        addPostUseCase: Get.find(),
        updatePostUseCase: Get.find(),
        deletePostUseCase: Get.find(),
        getPostsUseCase: Get.find(),
        watchPostsUseCase: Get.find(),
      ),
      fenix: true,
    );

    Get.lazyPut(
      () => PaginatedPostController(
        getPaginatedPostsUseCase: Get.find(),
        addPostUseCase: Get.find(),
        updatePostUseCase: Get.find(),
        deletePostUseCase: Get.find(),
      ),
      fenix: true,
    );
    Get.lazyPut<FileStorageController>(
      () => FileStorageController(
        uploadFileUseCase: Get.find(),
        deleteFileUseCase: Get.find(),
        getDownloadUrlUseCase: Get.find(),
        listFilesUseCase: Get.find(),
        filePickerService: Get.find(),
      ),
      fenix: true,
    );
  }
}
