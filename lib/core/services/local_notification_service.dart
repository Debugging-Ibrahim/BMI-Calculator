import 'package:flutter/material.dart' show Color, debugPrint;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const int reminderId = 100;

  static Future<void> init() async {
    try {
      // 1. Initialize Timezones
      tz.initializeTimeZones();
      final String timeZoneName =
          (await FlutterTimezone.getLocalTimezone()).identifier;
      tz.setLocalLocation(tz.getLocation(timeZoneName));

      // 2. Configure Android initialization settings using our hourglass logo
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('ic_notification');

      // iOS Settings
      const DarwinInitializationSettings initializationSettingsDarwin =
          DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          );

      const InitializationSettings initializationSettings =
          InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
          );

      await _localNotificationsPlugin.initialize(
        settings: initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) {
          debugPrint("Local notification tapped: ${details.payload}");
        },
      );

      debugPrint("LocalNotificationService successfully initialized.");
    } catch (e) {
      debugPrint("Error initializing LocalNotificationService: $e");
    }
  }

  /// Request permissions dynamically for local notifications
  static Future<bool> requestPermissions() async {
    try {
      // For Android 13+
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _localNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
      if (androidImplementation != null) {
        final bool? grantedNotification = await androidImplementation
            .requestNotificationsPermission();
        final bool? grantedExactAlarm = await androidImplementation
            .requestExactAlarmsPermission();
        debugPrint(
          "Android permission check - Notifications: $grantedNotification, ExactAlarms: $grantedExactAlarm",
        );
        return (grantedNotification ?? false);
      }

      // For iOS
      final IOSFlutterLocalNotificationsPlugin? iosImplementation =
          _localNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin
              >();
      if (iosImplementation != null) {
        final bool? granted = await iosImplementation.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return granted ?? false;
      }

      return true;
    } catch (e) {
      debugPrint("Error requesting notification permissions: $e");
      return false;
    }
  }

  /// Schedule a daily reminder at 09:00 AM
  static Future<void> scheduleDailyReminder() async {
    try {
      // Cancel any existing reminder first to prevent duplicates
      await cancelDailyReminder();

      final scheduledDate = tz.TZDateTime.now(
        tz.local,
      ).add(const Duration(seconds: 5));

      debugPrint(
        "Scheduling daily local reminder at: $scheduledDate (Timezone: ${tz.local.name})",
      );

      await _localNotificationsPlugin.zonedSchedule(
        id: reminderId,
        title: 'Daily BMI Check',
        body: "Don't forget to log your BMI today!",
        scheduledDate: scheduledDate,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_bmi_reminders_channel',
            'Daily Reminders',
            channelDescription: 'Daily reminders to log your BMI',
            importance: Importance.max,
            priority: Priority.high,
            color: Color(0xFF7CA613), // Match brand green
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        // matchDateTimeComponents: DateTimeComponents.time,
      );

      debugPrint("Successfully scheduled daily reminder.");
    } catch (e) {
      debugPrint("Error scheduling daily reminder: $e");
    }
  }

  /// Trigger an instant notification to confirm reminders are enabled
  static Future<void> showInstantNotification() async {
    try {
      await _localNotificationsPlugin.show(
        id: reminderId + 1,
        title: 'Daily Reminders Enabled',
        body: "We'll remind you daily at 9:00 AM to log your BMI!",
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_bmi_reminders_channel',
            'Daily Reminders',
            channelDescription: 'Daily reminders to log your BMI',
            importance: Importance.max,
            priority: Priority.high,
            color: Color(0xFF7CA613), // Match brand green
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
      debugPrint("Instant confirmation notification sent successfully.");
    } catch (e) {
      debugPrint("Error sending instant notification: $e");
    }
  }

  /// Cancel the daily reminder
  static Future<void> cancelDailyReminder() async {
    try {
      await _localNotificationsPlugin.cancel(id: reminderId);
      debugPrint("Cancelled scheduled daily local reminder.");
    } catch (e) {
      debugPrint("Error cancelling daily reminder: $e");
    }
  }

  // ignore: unused_element
  static tz.TZDateTime _nextInstanceOfNineAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      9,
      0,
    );

    // If it's already past 9 AM today, schedule for 9 AM tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
