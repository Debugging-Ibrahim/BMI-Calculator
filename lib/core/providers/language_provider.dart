import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  static const String _languageKey = 'selected_language_code';
  final SharedPreferences? _prefs;

  Locale _locale = const Locale('en');

  LanguageProvider(this._prefs) {
    _loadLanguageFromPrefs();
  }

  Locale get locale => _locale;

  bool get isUrdu => _locale.languageCode == 'ur';

  void _loadLanguageFromPrefs() {
    final languageCode = _prefs?.getString(_languageKey) ?? 'en';
    _locale = Locale(languageCode);
  }

  Future<void> setLocale(Locale newLocale) async {
    if (_locale.languageCode == newLocale.languageCode) return;
    _locale = newLocale;
    notifyListeners();
    await _prefs?.setString(_languageKey, newLocale.languageCode);
  }

  Future<void> toggleLanguage() async {
    final newCode = _locale.languageCode == 'en' ? 'ur' : 'en';
    await setLocale(Locale(newCode));
  }
}
