import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityProvider extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _isOffline = false;

  bool get isOffline => _isOffline;
  bool get isOnline => !_isOffline;

  ConnectivityProvider() {
    _initConnectivity();
  }

  Future<void> _initConnectivity() async {
    try {
      final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
      _updateStatus(results);
    } catch (e) {
      debugPrint('Failed to check connectivity: $e');
    }

    _subscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      _updateStatus(results);
    });
  }

  void _updateStatus(List<ConnectivityResult> results) {
    // If the list contains none, or is empty, the device is offline.
    final bool offline = results.isEmpty || (results.length == 1 && results.first == ConnectivityResult.none);
    if (_isOffline != offline) {
      _isOffline = offline;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
