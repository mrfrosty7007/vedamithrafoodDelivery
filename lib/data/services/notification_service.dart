import 'package:firebase_messaging/firebase_messaging.dart';

/// Service for Firebase Cloud Messaging (push notifications).
class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permission (iOS)
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get FCM token
    final token = await _messaging.getToken();
    if (token != null) {
      // TODO: Save token to Firestore for the current user
    }

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // TODO: Show local notification
    });

    // Handle notification taps when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // TODO: Navigate to relevant screen
    });
  }

  Future<String?> getToken() async {
    return await _messaging.getToken();
  }
}
