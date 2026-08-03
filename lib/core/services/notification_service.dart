import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling a background message: ${message.messageId}");
}

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> init() async {
    try {
      // Set background message handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Request notification permission
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      debugPrint('User granted permission: ${settings.authorizationStatus}');

      // Get FCM token
      String? token = await _messaging.getToken();
      debugPrint('==================================================');
      debugPrint('FCM Registration Token:');
      debugPrint('$token');
      debugPrint('==================================================');

      // Listen to token refresh
      _messaging.onTokenRefresh.listen((newToken) {
        debugPrint('FCM Token Refreshed: $newToken');
      });

      // Handle foreground notifications presentation options
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // Listen for foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('Received a foreground message: ${message.notification?.title}');
      });
    } catch (e) {
      debugPrint("Error initializing NotificationService: $e");
    }
  }
}
