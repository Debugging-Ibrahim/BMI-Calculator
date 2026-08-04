import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:digital_khata/core/services/local_notification_service.dart';

class ReminderProvider extends ChangeNotifier {
  bool _isReminderEnabled = false;
  bool get isReminderEnabled => _isReminderEnabled;

  StreamSubscription<User?>? _authSubscription;
  final SharedPreferences? _prefs;
  static const String _reminderKey = 'daily_reminder_enabled';

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
            if (data.containsKey('isReminderEnabled')) {
              final bool isEnabled = data['isReminderEnabled'] as bool;
              if (_isReminderEnabled != isEnabled) {
                _isReminderEnabled = isEnabled;
                _applyReminderState(isEnabled);
                notifyListeners();
              }
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
      final isEnabled = prefs.getBool(_reminderKey) ?? false;
      _isReminderEnabled = isEnabled;
      _applyReminderState(isEnabled);
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading reminder from SharedPreferences: $e");
    }
  }

  Future<void> toggleReminder(bool isEnabled) async {
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
    notifyListeners();
    _applyReminderState(isEnabled);

    if (isEnabled) {
      LocalNotificationService.showInstantNotification();
    }

    try {
      final prefs = _prefs ?? await SharedPreferences.getInstance();
      await prefs.setBool(_reminderKey, isEnabled);
    } catch (e) {
      debugPrint("Error saving reminder to SharedPreferences: $e");
    }

    // Save to Firestore if user is logged in
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'isReminderEnabled': isEnabled,
        });
      } catch (e) {
        debugPrint("Error updating reminder preference in Firestore: $e");
      }
    }
  }

  void _applyReminderState(bool isEnabled) {
    if (isEnabled) {
      LocalNotificationService.scheduleDailyReminder();
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
