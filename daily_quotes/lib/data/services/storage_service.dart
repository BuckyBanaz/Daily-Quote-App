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
