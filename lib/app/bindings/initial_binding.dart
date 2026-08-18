import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
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
import '../../features/auth/domain/usecases/reauthenticate_with_phone_otp_usecase.dart';
import '../../features/auth/domain/usecases/reload_current_user_usecase.dart';
import '../../features/auth/domain/usecases/resend_verification_email_usecase.dart';
import '../../features/auth/domain/usecases/send_password_reset_email_usecase.dart';
import '../../features/auth/domain/usecases/send_phone_otp_usecase.dart';
import '../../features/auth/domain/usecases/send_phone_reauth_otp_usecase.dart';
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
import '../../features/firebase_analytics/data/datasources/analytics_remote_data_source.dart';
import '../../features/firebase_analytics/data/repositories/firebase_analytics_repository_impl.dart';
import '../../features/firebase_analytics/domain/repositories/firebase_analytics_repository.dart';
import '../../features/firebase_analytics/domain/usecases/log_event_usecase.dart';
import '../../features/firebase_analytics/domain/usecases/log_login_usecase.dart';
import '../../features/firebase_analytics/domain/usecases/log_screen_view_usecase.dart';
import '../../features/firebase_analytics/domain/usecases/log_signup_usecase.dart';
import '../../features/firebase_analytics/domain/usecases/reset_analytics_data_usecase.dart';
import '../../features/firebase_analytics/domain/usecases/set_collection_enabled_usecase.dart';
import '../../features/firebase_analytics/domain/usecases/set_user_property_usecase.dart';
import '../../features/firebase_app_check/data/datasources/app_check_remote_data_source.dart';
import '../../features/firebase_app_check/data/repositories/firebase_app_check_repository_impl.dart';
import '../../features/firebase_app_check/domain/repositories/firebase_app_check_repository.dart';
import '../../features/firebase_app_check/domain/usecases/activate_app_check_usecase.dart';
import '../../features/firebase_app_check/domain/usecases/get_app_check_token_usecase.dart';
import '../../features/firebase_app_check/domain/usecases/get_limited_use_token_usecase.dart';
import '../../features/firebase_app_check/domain/usecases/set_token_auto_refresh_usecase.dart';
import '../../features/firebase_crashlytics/data/datasources/crashlytics_remote_data_source.dart';
import '../../features/firebase_crashlytics/data/repositories/firebase_crashlytics_repository_impl.dart';
import '../../features/firebase_crashlytics/domain/repositories/firebase_crashlytics_repository.dart';
import '../../features/firebase_crashlytics/domain/usecases/enable_collection_usecase.dart';
import '../../features/firebase_crashlytics/domain/usecases/log_usecase.dart';
import '../../features/firebase_crashlytics/domain/usecases/record_error_usecase.dart';
import '../../features/firebase_crashlytics/domain/usecases/record_flutter_error_usecase.dart';
import '../../features/firebase_crashlytics/domain/usecases/set_custom_key_usecase.dart';
import '../../features/firebase_crashlytics/domain/usecases/set_custom_keys_usecase.dart';
import '../../features/firebase_crashlytics/domain/usecases/set_user_id_usecase.dart';
import '../../features/firebase_functions/data/datasources/firebase_functions_remote_data_source.dart';
import '../../features/firebase_functions/data/repositories/firebase_functions_repository_impl.dart';
import '../../features/firebase_functions/domain/repositories/firebase_functions_repository.dart';
import '../../features/firebase_functions/domain/usecases/call_function_usecase.dart';
import '../../features/firebase_functions/domain/usecases/call_region_function_usecase.dart';
import '../../features/firebase_functions/domain/usecases/call_timeout_function_usecase.dart';
import '../../features/firebase_remote_config/data/datasources/remote_config_remote_data_source.dart';
import '../../features/firebase_remote_config/data/repositories/remote_config_repository_impl.dart';
import '../../features/firebase_remote_config/domain/repositories/remote_config_repository.dart';
import '../../features/firebase_remote_config/domain/usecases/activate_usecase.dart';
import '../../features/firebase_remote_config/domain/usecases/fetch_and_activate_usecase.dart';
import '../../features/firebase_remote_config/domain/usecases/fetch_usecase.dart';
import '../../features/firebase_remote_config/domain/usecases/get_bool_usecase.dart';
import '../../features/firebase_remote_config/domain/usecases/get_double_usecase.dart';
import '../../features/firebase_remote_config/domain/usecases/get_int_usecase.dart';
import '../../features/firebase_remote_config/domain/usecases/get_string_usecase.dart';
import '../../features/firebase_remote_config/domain/usecases/set_defaults_usecase.dart';
import '../../features/firebase_remote_config/domain/usecases/set_settings_usecase.dart';
import '../../features/firestore_aggregate/data/datasources/firestore_aggregate_remote_data_source.dart';
import '../../features/firestore_aggregate/data/repositories/firestore_aggregate_repository_impl.dart';
import '../../features/firestore_aggregate/domain/repositories/firestore_aggregate_repository.dart';
import '../../features/firestore_aggregate/domain/usecases/count_query_usecase.dart';
import '../../features/firestore_batch/data/datasources/firestore_batch_remote_data_source.dart';
import '../../features/firestore_batch/data/repositories/firestore_batch_repository_impl.dart';
import '../../features/firestore_batch/domain/repositories/firestore_batch_repository.dart';
import '../../features/firestore_batch/domain/usecases/commit_batch_usecase.dart';
import '../../features/firestore_batch/domain/usecases/run_transaction_usecase.dart';
import '../../features/firestore_collection_group/data/datasources/firestore_collection_group_remote_data_source.dart';
import '../../features/firestore_collection_group/data/repositories/firestore_collection_group_repository_impl.dart';
import '../../features/firestore_collection_group/domain/repositories/firestore_collection_group_repository.dart';
import '../../features/firestore_collection_group/domain/usecases/execute_collection_group_query_usecase.dart';
import '../../features/firestore_collection_group/domain/usecases/watch_collection_group_query_usecase.dart';
import '../../features/firestore_listener/data/datasources/firestore_listener_remote_data_source.dart';
import '../../features/firestore_listener/data/repositories/firestore_listener_repository_impl.dart';
import '../../features/firestore_listener/domain/repositories/firestore_listener_repository.dart';
import '../../features/firestore_listener/domain/usecases/listen_query_usecase.dart';
import '../../features/firestore_pagination/data/datasources/firestore_pagination_remote_data_source.dart';
import '../../features/firestore_pagination/data/repositories/firestore_pagination_repository_impl.dart';
import '../../features/firestore_pagination/domain/repositories/firestore_pagination_repository.dart';
import '../../features/firestore_pagination/domain/usecases/load_page_usecase.dart';
import '../../features/firestore_query/data/datasources/firestore_query_remote_data_source.dart';
import '../../features/firestore_query/data/repositories/firestore_query_repository_impl.dart';
import '../../features/firestore_query/domain/repositories/firestore_query_repository.dart';
import '../../features/firestore_query/domain/usecases/execute_query_usecase.dart';
import '../../features/firestore_query/domain/usecases/watch_query_usecase.dart';
import '../../features/notifications/data/datasources/notification_remote_data_source.dart';
import '../../features/notifications/data/repositories/notification_repository_impl.dart';
import '../../features/notifications/domain/repositories/notification_repository.dart';
import '../../features/notifications/domain/usecases/get_fcm_token_usecase.dart';
import '../../features/notifications/domain/usecases/get_initial_message_usecase.dart';
import '../../features/notifications/domain/usecases/initialize_notifications_usecase.dart';
import '../../features/notifications/domain/usecases/listen_foreground_messages_usecase.dart';
import '../../features/notifications/domain/usecases/listen_notification_opened_usecase.dart';
import '../../features/notifications/domain/usecases/listen_token_refresh_usecase.dart';
import '../../features/notifications/domain/usecases/request_notification_permission_usecase.dart';
import '../../features/notifications/domain/usecases/show_local_notification_usecase.dart';
import '../../features/notifications/domain/usecases/subscribe_topic_usecase.dart';
import '../../features/notifications/domain/usecases/unsubscribe_topic_usecase.dart';
import '../../features/notifications/presentation/controllers/notification_controller.dart';
import '../../features/posts/data/datasources/post_remote_data_source.dart';
import '../../features/posts/data/models/post_model.dart';
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
import '../../features/search/data/datasources/search_remote_data_source.dart';
import '../../features/search/data/repositories/search_repository_impl.dart';
import '../../features/search/domain/repositories/search_repository.dart';
import '../../features/search/domain/usecases/search_usecase.dart';
import '../../features/search/presentation/controllers/search_controller.dart';

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

    /// 2. AUTH
    // ***** datasource *****
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        firebaseAuth: Get.find<FirebaseAuth>(),
        googleSignIn: Get.find<GoogleSignIn>(),
      ),
      fenix: true,
    );
    // ***** repository *****
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: Get.find<AuthRemoteDataSource>(),
      ),
      fenix: true,
    );
    // ***** usecases *****
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
    Get.lazyPut<SendPhoneReauthOtpUseCase>(
          () => SendPhoneReauthOtpUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );

    Get.lazyPut<ReauthenticateWithPhoneOtpUseCase>(
          () => ReauthenticateWithPhoneOtpUseCase(Get.find<AuthRepository>()),
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
          () =>
          DeleteAccountUseCase(authRepository: Get.find<AuthRepository>()),
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

    /// 3. PROFILE
    // ***** datasource *****
    Get.lazyPut<ProfileRemoteDataSource>(
          () =>
          ProfileRemoteDataSourceImpl(
            firestoreService: Get.find<FirestoreService>(),
          ),
      fenix: true,
    );
    // ***** repository *****
    Get.lazyPut<ProfileRepository>(
          () =>
          ProfileRepositoryImpl(
            remoteDataSource: Get.find<ProfileRemoteDataSource>(),
          ),
      fenix: true,
    );
    // ***** usecases *****
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

    /// 4. NOTIFICATION
    // ***** datasource *****
    Get.lazyPut<NotificationRemoteDataSource>(
          () =>
          NotificationRemoteDataSourceImpl(Get.find<NotificationService>()),
      fenix: true,
    );
    // ***** repository *****
    Get.lazyPut<NotificationRepository>(
          () =>
          NotificationRepositoryImpl(Get.find<NotificationRemoteDataSource>()),
      fenix: true,
    );
    // ***** usecases *****
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
    Get.lazyPut<ListenForegroundMessagesUseCase>(
          () =>
              ListenForegroundMessagesUseCase(
                  Get.find<NotificationRepository>()),
      fenix: true,
    );

    Get.lazyPut<ListenNotificationOpenedUseCase>(
          () =>
              ListenNotificationOpenedUseCase(
                  Get.find<NotificationRepository>()),
      fenix: true,
    );

    Get.lazyPut<ListenTokenRefreshUseCase>(
          () => ListenTokenRefreshUseCase(Get.find<NotificationRepository>()),
      fenix: true,
    );

    /// 5. POSTS
    // ***** datasource *****
    Get.lazyPut<PostRemoteDataSource>(
          () =>
              PostRemoteDataSourceImpl(
                firestoreService: Get.find<FirestoreService>(),
          ),
      fenix: true,
    );
    // ***** repository *****
    Get.lazyPut<PostRepository>(
          () => PostRepositoryImpl(remoteDataSource: Get.find()),
      fenix: true,
    );
    // ***** usecases *****
    Get.lazyPut(() => AddPostUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => UpdatePostUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => DeletePostUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetPostsUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => WatchPostsUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetPaginatedPostsUseCase(Get.find()), fenix: true);

    /// FILE STORAGE
    // ***** datasource *****
    Get.lazyPut<FileStorageRemoteDataSource>(
          () => FileStorageRemoteDataSourceImpl(Get.find<FirebaseStorage>()),
      fenix: true,
    );
    // ***** repository *****
    Get.lazyPut<FileStorageRepository>(
          () => FileStorageRepositoryImpl(remoteDataSource: Get.find()),
      fenix: true,
    );
    // ***** usecases *****
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

    /// 6. CONNECTIVITY
    // ***** datasource *****
    Get.lazyPut<ConnectivityRemoteDataSource>(
          () => ConnectivityRemoteDataSourceImpl(Get.find()),
    );
    // ***** repository *****
    Get.lazyPut<ConnectivityRepository>(
      () => ConnectivityRepositoryImpl(Get.find()),
    );
    // ***** usecases *****
    Get.lazyPut(() => CheckConnectionUseCase(Get.find()));

    Get.lazyPut(() => WatchConnectionUseCase(Get.find()));

    /// 7. SEARCH
    // ***** datasource *****
    Get.lazyPut<SearchRemoteDataSource<PostModel>>(
          () =>
          SearchRemoteDataSourceImpl<PostModel>(Get.find<FirebaseFirestore>()),
      fenix: true,
    );
    // ***** repository *****
    Get.lazyPut<SearchRepository<PostModel>>(
          () =>
          SearchRepositoryImpl<PostModel>(
            remoteDataSource: Get.find<SearchRemoteDataSource<PostModel>>(),
            collection: 'posts',
            searchField: 'title',
            fromFirestore: PostModel.fromFirestore,
          ),
      fenix: true,
    );
    // ***** usecases *****
    Get.lazyPut<SearchUseCase<PostModel>>(
          () =>
          SearchUseCase<PostModel>(Get.find<SearchRepository<PostModel>>()),
      fenix: true,
    );

    /// 8. FIRESTORE QUERY
    // ***** datasource *****
    Get.lazyPut<FirestoreQueryRemoteDataSource>(
          () =>
          FirestoreQueryRemoteDataSourceImpl(Get.find<FirebaseFirestore>()),
      fenix: true,
    );
    // ***** repository *****
    Get.lazyPut<FirestoreQueryRepository>(
          () => FirestoreQueryRepositoryImpl(remoteDataSource: Get.find()),
      fenix: true,
    );
    // ***** usecases *****
    Get.lazyPut(
          () => ExecuteQueryUseCase(Get.find<FirestoreQueryRepository>()),
      fenix: true,
    );
    Get.lazyPut(
          () => WatchQueryUseCase(Get.find<FirestoreQueryRepository>()),
      fenix: true,
    );

    /// 9. FIRESTORE BATCH
    // ***** datasource *****
    Get.lazyPut<FirestoreBatchRemoteDataSource>(
          () =>
          FirestoreBatchRemoteDataSourceImpl(Get.find<FirebaseFirestore>()),
      fenix: true,
    );
    // ***** repository *****
    Get.lazyPut<FirestoreBatchRepository>(
          () => FirestoreBatchRepositoryImpl(remoteDataSource: Get.find()),
      fenix: true,
    );
    // ***** usecases *****
    Get.lazyPut(
          () => CommitBatchUseCase(Get.find<FirestoreBatchRepository>()),
      fenix: true,
    );
    Get.lazyPut(
          () => RunTransactionUseCase(Get.find<FirestoreBatchRepository>()),
      fenix: true,
    );


    /// 10. FIRESTORE PAGINATION
    Get.lazyPut<FirestorePaginationRemoteDataSource>(
          () =>
          FirestorePaginationRemoteDataSourceImpl(
            Get.find<FirebaseFirestore>(),
          ),
      fenix: true,
    );

    Get.lazyPut<FirestorePaginationRepository>(
          () =>
          FirestorePaginationRepositoryImpl(
            Get.find<FirestorePaginationRemoteDataSource>(),
          ),
      fenix: true,
    );

    Get.lazyPut(
          () => LoadPageUseCase(Get.find<FirestorePaginationRepository>()),
      fenix: true,
    );

    /// 11. FIRESTORE LISTENER
    Get.lazyPut<FirestoreListenerRemoteDataSource>(
          () =>
              FirestoreListenerRemoteDataSourceImpl(
                  Get.find<FirebaseFirestore>()),
      fenix: true,
    );

    Get.lazyPut<FirestoreListenerRepository>(
          () =>
          FirestoreListenerRepositoryImpl(
            Get.find<FirestoreListenerRemoteDataSource>(),
          ), fenix: true,
    );

    Get.lazyPut(
          () => ListenQueryUseCase(Get.find<FirestoreListenerRepository>()),
      fenix: true,
    );

    /// 12. FIRESTORE AGGREGATE

    Get.lazyPut<FirestoreAggregateRemoteDataSource>(
          () =>
              FirestoreAggregateRemoteDataSourceImpl(
                  Get.find<FirebaseFirestore>()),
      fenix: true,
    );

    Get.lazyPut<FirestoreAggregateRepository>(
          () =>
          FirestoreAggregateRepositoryImpl(
            Get.find<FirestoreAggregateRemoteDataSource>(),
          ), fenix: true,
    );

    Get.lazyPut(
          () => CountQueryUseCase(Get.find<FirestoreAggregateRepository>()),
      fenix: true,
    );

    /// 13. FIRESTORE COLLECTION GROUP
    Get.lazyPut<FirestoreCollectionGroupRemoteDataSource>(
          () =>
          FirestoreCollectionGroupRemoteDataSourceImpl(
            Get.find<FirebaseFirestore>(),
          ), fenix: true,
    );

    Get.lazyPut<FirestoreCollectionGroupRepository>(
          () =>
          FirestoreCollectionGroupRepositoryImpl(
            Get.find<FirestoreCollectionGroupRemoteDataSource>(),
          ), fenix: true,
    );

    Get.lazyPut(
          () =>
          ExecuteCollectionGroupQueryUseCase(
            Get.find<FirestoreCollectionGroupRepository>(),
          ), fenix: true,
    );

    Get.lazyPut(
          () =>
          WatchCollectionGroupQueryUseCase(
            Get.find<FirestoreCollectionGroupRepository>(),
          ), fenix: true,
    );

    /// 14. FIRESTORE REMOTE CONFIG
    Get.lazyPut<RemoteConfigRemoteDataSource>(
          () => RemoteConfigRemoteDataSourceImpl(FirebaseRemoteConfig.instance),
      fenix: true,
    );

    Get.lazyPut<RemoteConfigRepository>(
          () =>
              RemoteConfigRepositoryImpl(
                  Get.find<RemoteConfigRemoteDataSource>()),
      fenix: true,
    );

    Get.lazyPut(() => FetchUseCase(Get.find()), fenix: true,);
    Get.lazyPut(() => ActivateUseCase(Get.find()), fenix: true,);
    Get.lazyPut(() => FetchAndActivateUseCase(Get.find()), fenix: true,);
    Get.lazyPut(() => GetStringUseCase(Get.find()), fenix: true,);
    Get.lazyPut(() => GetBoolUseCase(Get.find()), fenix: true,);
    Get.lazyPut(() => GetIntUseCase(Get.find()), fenix: true,);
    Get.lazyPut(() => GetDoubleUseCase(Get.find()), fenix: true,);
    Get.lazyPut(() => SetDefaultsUseCase(Get.find()), fenix: true,);
    Get.lazyPut(() => SetSettingsUseCase(Get.find()), fenix: true,);

    /// 15. FIRESTORE FUNCTIONS

    Get.lazyPut<FirebaseFunctionsRemoteDataSource>(
          () => FirebaseFunctionsRemoteDataSourceImpl(), fenix: true,
    );

    Get.lazyPut<FirebaseFunctionsRepository>(
          () =>
          FirebaseFunctionsRepositoryImpl(
            Get.find<FirebaseFunctionsRemoteDataSource>(),
          ), fenix: true,
    );

    Get.lazyPut(
          () => CallFunctionUseCase(Get.find<FirebaseFunctionsRepository>()),
      fenix: true,
    );

    Get.lazyPut(
          () =>
              CallRegionFunctionUseCase(
                  Get.find<FirebaseFunctionsRepository>()),
      fenix: true,
    );

    Get.lazyPut(
          () =>
              CallTimeoutFunctionUseCase(
                  Get.find<FirebaseFunctionsRepository>()),
      fenix: true,
    );

    /// 16. FIRESTORE CRASHLYTICS
    Get.lazyPut<CrashlyticsRemoteDataSource>(
          () => const CrashlyticsRemoteDataSourceImpl(), fenix: true,
    );

    Get.lazyPut<FirebaseCrashlyticsRepository>(
          () =>
          FirebaseCrashlyticsRepositoryImpl(
            Get.find<CrashlyticsRemoteDataSource>(),
          ), fenix: true,
    );

    Get.lazyPut(() => LogUseCase(Get.find<FirebaseCrashlyticsRepository>()),
      fenix: true,);

    Get.lazyPut(
          () => RecordErrorUseCase(Get.find<FirebaseCrashlyticsRepository>()),
      fenix: true,
    );

    Get.lazyPut(
          () =>
              RecordFlutterErrorUseCase(
                  Get.find<FirebaseCrashlyticsRepository>()),
      fenix: true,
    );

    Get.lazyPut(
          () => SetUserIdUseCase(Get.find<FirebaseCrashlyticsRepository>()),
      fenix: true,
    );

    Get.lazyPut(
          () => SetCustomKeyUseCase(Get.find<FirebaseCrashlyticsRepository>()),
      fenix: true,
    );

    Get.lazyPut(
          () => SetCustomKeysUseCase(Get.find<FirebaseCrashlyticsRepository>()),
      fenix: true,
    );

    Get.lazyPut(
          () =>
              EnableCollectionUseCase(
                  Get.find<FirebaseCrashlyticsRepository>()),
      fenix: true,
    );

    /// 17. FIRESTORE ANALYTICS
    Get.lazyPut<AnalyticsRemoteDataSource>(
          () => const AnalyticsRemoteDataSourceImpl(), fenix: true,
    );

    Get.lazyPut<FirebaseAnalyticsRepository>(
          () =>
          FirebaseAnalyticsRepositoryImpl(
            Get.find<AnalyticsRemoteDataSource>(),
          ), fenix: true,
    );

    Get.lazyPut(() => LogEventUseCase(Get.find()), fenix: true,);
    Get.lazyPut(() => SetUserIdUseCase(Get.find()), fenix: true,);
    Get.lazyPut(() => SetUserPropertyUseCase(Get.find()), fenix: true,);
    Get.lazyPut(() => LogLoginUseCase(Get.find()), fenix: true,);
    Get.lazyPut(() => LogSignUpUseCase(Get.find()), fenix: true,);
    Get.lazyPut(() => LogScreenViewUseCase(Get.find()), fenix: true,);
    Get.lazyPut(() => ResetAnalyticsDataUseCase(Get.find()), fenix: true,);
    Get.lazyPut(() => SetCollectionEnabledUseCase(Get.find()), fenix: true,);

    /// 18. FIRESTORE APP CHECK
    Get.lazyPut<AppCheckRemoteDataSource>(
          () => const AppCheckRemoteDataSourceImpl(), fenix: true,
    );

    Get.lazyPut<FirebaseAppCheckRepository>(
          () =>
              FirebaseAppCheckRepositoryImpl(
                  Get.find<AppCheckRemoteDataSource>()),
      fenix: true,
    );

    Get.lazyPut<ActivateAppCheckUseCase>(
          () => ActivateAppCheckUseCase(Get.find<FirebaseAppCheckRepository>()),
      fenix: true,
    );

    Get.lazyPut<GetAppCheckTokenUseCase>(
          () => GetAppCheckTokenUseCase(Get.find<FirebaseAppCheckRepository>()),
      fenix: true,
    );

    Get.lazyPut<GetLimitedUseTokenUseCase>(
          () =>
              GetLimitedUseTokenUseCase(Get.find<FirebaseAppCheckRepository>()),
      fenix: true,
    );

    Get.lazyPut<SetTokenAutoRefreshUseCase>(
          () =>
              SetTokenAutoRefreshUseCase(
                  Get.find<FirebaseAppCheckRepository>()),
      fenix: true,
    );

    /// 19. CONTROLLERS
    Get.lazyPut<AuthController>(
          () =>
          AuthController(
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
            sendPhoneReauthOtpUseCase: Get.find<SendPhoneReauthOtpUseCase>(),
            reauthenticateWithPhoneOtpUseCase:
            Get.find<ReauthenticateWithPhoneOtpUseCase>(),
          ),

      fenix: true,
    );

    Get.lazyPut<PhoneAuthController>(
          () =>
          PhoneAuthController(
            sendPhoneOtpUseCase: Get.find<SendPhoneOtpUseCase>(),
            verifyPhoneOtpUseCase: Get.find<VerifyPhoneOtpUseCase>(),
          ),
      fenix: true,
    );

    Get.lazyPut<CompleteProfileController>(
          () =>
          CompleteProfileController(
            completeProfileUseCase: Get.find(),
            saveUserProfileUseCase: Get.find(),
            authRepository: Get.find(),
          ),
      fenix: true,
    );
    Get.lazyPut<ProfileController>(
          () =>
          ProfileController(
            getUserProfileUseCase: Get.find<GetUserProfileUseCase>(),
            authRepository: Get.find<AuthRepository>(),
            updateProfileUseCase: Get.find(),
            completeProfileUseCase: Get.find(),
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
          () =>
          PostController(
            addPostUseCase: Get.find(),
            updatePostUseCase: Get.find(),
            deletePostUseCase: Get.find(),
            getPostsUseCase: Get.find(),
            watchPostsUseCase: Get.find(),
          ),
      fenix: true,
    );

    Get.lazyPut(
          () =>
          PaginatedPostController(
            getPaginatedPostsUseCase: Get.find(),
            addPostUseCase: Get.find(),
            updatePostUseCase: Get.find(),
            deletePostUseCase: Get.find(),
          ),
      fenix: true,
    );

    Get.lazyPut<SearchController<PostModel>>(
          () =>
          SearchController<PostModel>(
            searchUseCase: Get.find<SearchUseCase<PostModel>>(),
          ),
      fenix: true,
    );
  }
}
