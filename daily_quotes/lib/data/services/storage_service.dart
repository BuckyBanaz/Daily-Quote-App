import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quote_model.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;
  static const String FAVORITES_KEY = 'favorite_quotes';

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  T? read<T>(String key) {
    if (T == String) {
      return _prefs.getString(key) as T?;
    } else if (T == int) {
      return _prefs.getInt(key) as T?;
    } else if (T == double) {
      return _prefs.getDouble(key) as T?;
    } else if (T == bool) {
      return _prefs.getBool(key) as T?;
    } else if (T == List<String>) {
      return _prefs.getStringList(key) as T?;
    } else {
      // For dynamic or list dynamic, we might need special handling
      // For List<int>, SharedPreferences doesn't directly support it unless stored as String (json)
      // BUT, let's see what SharedPreferences supports.
      // It supports getInt, getBool, getDouble, getString, getStringList.
      // If we want to store List<dynamic>, we usually use JSON.
      // But _storageService.read('notification_weekdays') expects List<dynamic>? or List<int>?
      // In Dart, generics at runtime can be tricky.
      
      // Let's implement a dynamic read that tries to guess
      final val = _prefs.get(key);
      if (val == null) return null;
      
      if (val is T) return val as T?;
      
      // If T is List<int> but stored as List<String> (json) or something else?
      // SharedPreferences 'get' returns Object?.
      
      // Special case for our json encoded stuff
      if (val is String) {
         try {
           final decoded = jsonDecode(val);
           if (decoded is T) return decoded;
           // If T is List<int> and decoded is List<dynamic>, we cast?
           if (decoded is List) {
             return decoded as T;
           }
         } catch (e) {
           // Not json
         }
      }
      
      return val as T?;
    }
  }

  Future<void> write(String key, dynamic value) async {
    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    } else {
      // Fallback to JSON for other lists/objects
      await _prefs.setString(key, jsonEncode(value));
    }
  }

  static const String USER_TOKEN_KEY = 'user_token';
  static const String USER_DATA_KEY = 'user_data';
  static const String IS_DARK_MODE_KEY = 'is_dark_mode';
  static const String THEME_COLOR_KEY = 'theme_color';
  static const String FONT_SIZE_KEY = 'font_size';

  Future<void> saveUserToken(String token) async {
    await _prefs.setString(USER_TOKEN_KEY, token);
  }

  String? getUserToken() {
    return _prefs.getString(USER_TOKEN_KEY);
  }

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _prefs.setString(USER_DATA_KEY, jsonEncode(userData));
  }

  Map<String, dynamic>? getUserData() {
    final String? data = _prefs.getString(USER_DATA_KEY);
    if (data == null) return null;
    return jsonDecode(data);
  }

  Future<void> saveDarkMode(bool isDark) async {
    await _prefs.setBool(IS_DARK_MODE_KEY, isDark);
  }

  bool getDarkMode() {
    return _prefs.getBool(IS_DARK_MODE_KEY) ?? false;
  }

  Future<void> saveThemeColor(int color) async {
    await _prefs.setInt(THEME_COLOR_KEY, color);
  }

  int getThemeColor() {
    return _prefs.getInt(THEME_COLOR_KEY) ?? 0xFF26A69A; // Default Teal
  }

  Future<void> saveFontSize(double size) async {
    await _prefs.setDouble(FONT_SIZE_KEY, size);
  }

  double getFontSize() {
    return _prefs.getDouble(FONT_SIZE_KEY) ?? 1.0; // Default Medium (multiplier)
  }

  Future<void> clearUser() async {
    await _prefs.remove(USER_TOKEN_KEY);
    await _prefs.remove(USER_DATA_KEY);
  }

  List<Quote> getFavorites() {
    final String? favoritesString = _prefs.getString(FAVORITES_KEY);
    if (favoritesString == null) return [];
    
    final List<dynamic> decoded = jsonDecode(favoritesString);
    return decoded.map((e) => Quote.fromJson(e)).toList();
  }
  static const String STREAK_COUNT_KEY = 'streak_count';
  static const String LAST_OPEN_DATE_KEY = 'last_open_date';

  Future<void> saveFavorites(List<Quote> quotes) async {
    final String encoded = jsonEncode(quotes.map((e) => e.toJson()).toList());
    await _prefs.setString(FAVORITES_KEY, encoded);
  }

  static const String STREAK_DATES_KEY = 'streak_dates';

  int getStreak() {
    return _prefs.getInt(STREAK_COUNT_KEY) ?? 0;
  }
  
  List<DateTime> getStreakDates() {
    final List<String> dates = _prefs.getStringList(STREAK_DATES_KEY) ?? [];
    return dates.map((e) => DateTime.parse(e)).toList();
  }

  Future<void> updateStreak() async {
    final String? lastDateStr = _prefs.getString(LAST_OPEN_DATE_KEY);
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    
    int currentStreak = getStreak();
    List<String> streakDates = _prefs.getStringList(STREAK_DATES_KEY) ?? [];

    // Add today to streak dates if not present
    final String todayStr = today.toIso8601String();
    if (!streakDates.contains(todayStr)) {
      streakDates.add(todayStr);
      await _prefs.setStringList(STREAK_DATES_KEY, streakDates);
    }

    if (lastDateStr == null) {
      // First time opening
      currentStreak = 1;
    } else {
      final DateTime lastDate = DateTime.parse(lastDateStr);
      final DateTime lastDateMidnight = DateTime(lastDate.year, lastDate.month, lastDate.day);
      
      if (lastDateMidnight.isBefore(today.subtract(const Duration(days: 1)))) {
        // Missed a day > 1, reset streak
         if (today.difference(lastDateMidnight).inDays > 1) {
           currentStreak = 1; 
        } else if (today.difference(lastDateMidnight).inDays == 1) {
           currentStreak++;
        }
      } else if (today.difference(lastDateMidnight).inDays == 1) {
        currentStreak++;
      }
    }

    await _prefs.setInt(STREAK_COUNT_KEY, currentStreak);
    await _prefs.setString(LAST_OPEN_DATE_KEY, today.toIso8601String());
  }
}
