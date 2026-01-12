import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/models/quote_model.dart';
import '../../data/services/api_service.dart';
import '../../data/services/storage_service.dart';
import '../favorites/favorites_controller.dart';

class HomeController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();

  final Rx<Quote?> currentQuote = Rx<Quote?>(null);
  final RxInt streak = 0.obs;
  final RxList<DateTime> streakDates = <DateTime>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isFavorite = false.obs;
  final RxList<Quote> favorites = <Quote>[].obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _storageService.updateStreak().then((_) => loadStreak());
    loadFavorites();
    fetchNewQuote();
    startAutoRefresh();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void startAutoRefresh() {
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      fetchNewQuote();
    });
  }

  void loadStreak() {
    streak.value = _storageService.getStreak();
    streakDates.value = _storageService.getStreakDates();
  }


  void loadFavorites() {
    favorites.value = _storageService.getFavorites();
  }

  Future<void> fetchNewQuote() async {
    isLoading.value = true;
    try {
      final quote = await _apiService.getRandomQuote();
      currentQuote.value = quote;
      checkIfFavorite();
    } catch (e) {
      Get.snackbar('Error', 'Could not load quote');
    } finally {
      isLoading.value = false;
    }
  }

  void checkIfFavorite() {
    if (currentQuote.value == null) return;
    isFavorite.value = favorites.any((q) => q.text == currentQuote.value!.text);
  }

  void toggleFavorite() {
    if (currentQuote.value == null) return;
    
    if (isFavorite.value) {
      favorites.removeWhere((q) => q.text == currentQuote.value!.text);
    } else {
      favorites.add(currentQuote.value!);
    }
    
    _storageService.saveFavorites(favorites);
    isFavorite.toggle();
    
    // instant update for Favorites Tab
    if (Get.isRegistered<FavoritesController>()) {
      Get.find<FavoritesController>().loadFavorites();
    }
    
    update(); // Force update if needed, though obs should handle it
  }

  void shareQuote() {
    // This will now be handled by the UI to show the bottom sheet, 
    // but we keep the logic for the "System Share" button.
    if (currentQuote.value == null) return;
    Share.share('"${currentQuote.value!.text}" - ${currentQuote.value!.author}');
  }

  Future<void> copyToClipboard() async {
    if (currentQuote.value == null) return;
    await Clipboard.setData(ClipboardData(text: '"${currentQuote.value!.text}" - ${currentQuote.value!.author}'));
    Get.snackbar('Success', 'Quote copied to clipboard', snackPosition: SnackPosition.BOTTOM);
  }
}
