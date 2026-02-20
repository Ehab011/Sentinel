import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _keyThemeMode = 'theme_mode';

class ThemeModeProvider extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.system;
  bool _loaded = false;

  ThemeMode get mode => _mode;
  bool get isLoaded => _loaded;

  ThemeModeProvider() {
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final i = prefs.getInt(_keyThemeMode);
      if (i != null && i >= 0 && i <= 2) {
        _mode = ThemeMode.values[i];
      }
    } catch (_) {}
    _loaded = true;
    notifyListeners();
  }

  Future<void> setMode(ThemeMode mode) async {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_keyThemeMode, mode.index);
    } catch (_) {}
  }

  void cycleNext() {
    final next = switch (_mode) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };
    setMode(next);
  }

  IconData get icon => switch (_mode) {
        ThemeMode.system => Icons.brightness_auto,
        ThemeMode.light => Icons.light_mode,
        ThemeMode.dark => Icons.dark_mode,
      };

  String get label => switch (_mode) {
        ThemeMode.system => 'System',
        ThemeMode.light => 'Light',
        ThemeMode.dark => 'Dark',
      };
}
