class NotificationConstants {
  const NotificationConstants._();

  /// Android notification channel
  static const String channelId = 'high_importance_channel';

  static const String channelName = 'High Importance Notifications';

  static const String channelDescription =
      'This channel is used for important notifications.';

  /// Notification icon
  static const String notificationIcon = '@mipmap/ic_launcher';

  /// Default topic (optional)
  static const String defaultTopic = 'all_users';
}
