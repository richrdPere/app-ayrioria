import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  // =========================================================
  // KEYS
  // =========================================================

  static const String _keyThemeMode = 'app_theme_mode';
  static const String _keyColorIndex = 'app_color_index';

  // Futuras preferencias
  static const String _keyLanguage = 'app_language';
  static const String _keyShowDecimals = 'app_show_decimals';
  static const String _keyConfirmBeforeDelete = 'app_confirm_before_delete';

  // =========================================================
  // THEME MODE
  // =========================================================

  Future<void> saveThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_keyThemeMode, mode);
  }

  Future<String> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_keyThemeMode) ?? 'light';
  }

  // =========================================================
  // COLOR INDEX
  // =========================================================

  Future<void> saveColorIndex(int colorIndex) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_keyColorIndex, colorIndex);
  }

  Future<int> getColorIndex() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt(_keyColorIndex) ?? 0;
  }

  // =========================================================
  // LANGUAGE
  // =========================================================

  Future<void> saveLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_keyLanguage, language);
  }

  Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_keyLanguage) ?? 'es';
  }

  // =========================================================
  // SHOW DECIMALS
  // =========================================================

  Future<void> saveShowDecimals(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_keyShowDecimals, value);
  }

  Future<bool> getShowDecimals() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_keyShowDecimals) ?? true;
  }

  // =========================================================
  // CONFIRM BEFORE DELETE
  // =========================================================

  Future<void> saveConfirmBeforeDelete(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_keyConfirmBeforeDelete, value);
  }

  Future<bool> getConfirmBeforeDelete() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_keyConfirmBeforeDelete) ?? true;
  }

  // =========================================================
  // CLEAR
  // =========================================================

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_keyThemeMode);
    await prefs.remove(_keyColorIndex);
    await prefs.remove(_keyLanguage);
    await prefs.remove(_keyShowDecimals);
    await prefs.remove(_keyConfirmBeforeDelete);
  }
}
