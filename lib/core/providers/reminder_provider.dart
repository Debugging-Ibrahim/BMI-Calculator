import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:digital_khata/core/services/local_notification_service.dart';

class ReminderProvider extends ChangeNotifier {
  bool _isReminderEnabled = false;
  bool get isReminderEnabled => _isReminderEnabled;

  int _reminderHour = 9;
  int get reminderHour => _reminderHour;

  int _reminderMinute = 0;
  int get reminderMinute => _reminderMinute;

  StreamSubscription<User?>? _authSubscription;
  final SharedPreferences? _prefs;

  static const String _reminderKey = 'daily_reminder_enabled';
  static const String _reminderHourKey = 'reminder_hour';
  static const String _reminderMinuteKey = 'reminder_minute';

  String get formattedTime {
    final period = _reminderHour >= 12 ? 'PM' : 'AM';
    final displayHour = _reminderHour > 12 ? _reminderHour - 12 : (_reminderHour == 0 ? 12 : _reminderHour);
    final displayMinute = _reminderMinute.toString().padLeft(2, '0');
    return "$displayHour:$displayMinute $period";
  }

  ReminderProvider(this._prefs) {
    _loadReminderFromPrefs();
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        try {
          final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
          if (doc.exists && doc.data() != null) {
            final data = doc.data()!;
            bool changed = false;

            if (data.containsKey('isReminderEnabled')) {
              final bool isEnabled = data['isReminderEnabled'] as bool;
              if (_isReminderEnabled != isEnabled) {
                _isReminderEnabled = isEnabled;
                changed = true;
              }
            }
            if (data.containsKey('reminderHour')) {
              final int hour = data['reminderHour'] as int;
              if (_reminderHour != hour) {
                _reminderHour = hour;
                changed = true;
              }
            }
            if (data.containsKey('reminderMinute')) {
              final int minute = data['reminderMinute'] as int;
              if (_reminderMinute != minute) {
                _reminderMinute = minute;
                changed = true;
              }
            }

            if (changed) {
              _applyReminderState(_isReminderEnabled);
              notifyListeners();
            }
          }
        } catch (e) {
          debugPrint("Error fetching reminder preference from Firestore: $e");
        }
      } else {
        // Fallback to local settings when user logs out
        _loadReminderFromPrefs();
      }
    });
  }

  Future<void> _loadReminderFromPrefs() async {
    try {
      final prefs = _prefs ?? await SharedPreferences.getInstance();
      _isReminderEnabled = prefs.getBool(_reminderKey) ?? false;
      _reminderHour = prefs.getInt(_reminderHourKey) ?? 9;
      _reminderMinute = prefs.getInt(_reminderMinuteKey) ?? 0;
      _applyReminderState(_isReminderEnabled);
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading reminder from SharedPreferences: $e");
    }
  }

  Future<void> toggleReminder(bool isEnabled, {int? hour, int? minute}) async {
    // If enabling, request platform permissions
    if (isEnabled) {
      final hasPermission = await LocalNotificationService.requestPermissions();
      if (!hasPermission) {
        // If user denies permission, keep reminder turned off and notify UI
        _isReminderEnabled = false;
        notifyListeners();
        return;
      }
    }

    _isReminderEnabled = isEnabled;
    if (hour != null) _reminderHour = hour;
    if (minute != null) _reminderMinute = minute;

    notifyListeners();
    _applyReminderState(isEnabled);

    if (isEnabled) {
      LocalNotificationService.showInstantNotification(formattedTime);
    }

    try {
      final prefs = _prefs ?? await SharedPreferences.getInstance();
      await prefs.setBool(_reminderKey, isEnabled);
      await prefs.setInt(_reminderHourKey, _reminderHour);
      await prefs.setInt(_reminderMinuteKey, _reminderMinute);
    } catch (e) {
      debugPrint("Error saving reminder to SharedPreferences: $e");
    }

    // Save to Firestore if user is logged in
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'isReminderEnabled': isEnabled,
          'reminderHour': _reminderHour,
          'reminderMinute': _reminderMinute,
        });
      } catch (e) {
        debugPrint("Error updating reminder preference in Firestore: $e");
      }
    }
  }

  Future<void> updateReminderTime(int hour, int minute) async {
    _reminderHour = hour;
    _reminderMinute = minute;
    notifyListeners();

    if (_isReminderEnabled) {
      _applyReminderState(true);
      LocalNotificationService.showInstantNotification(formattedTime);
    }

    try {
      final prefs = _prefs ?? await SharedPreferences.getInstance();
      await prefs.setInt(_reminderHourKey, hour);
      await prefs.setInt(_reminderMinuteKey, minute);
    } catch (e) {
      debugPrint("Error saving reminder time to SharedPreferences: $e");
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'reminderHour': hour,
          'reminderMinute': minute,
        });
      } catch (e) {
        debugPrint("Error updating reminder time in Firestore: $e");
      }
    }
  }

  void _applyReminderState(bool isEnabled) {
    if (isEnabled) {
      LocalNotificationService.scheduleDailyReminder(_reminderHour, _reminderMinute);
    } else {
      LocalNotificationService.cancelDailyReminder();
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
