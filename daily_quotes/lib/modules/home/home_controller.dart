import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/models/quote_model.dart';
import '../../data/models/category_model.dart';
import '../../data/repo/quote_repository.dart';
import '../../data/services/storage_service.dart';
import '../share/share_bottom_sheet.dart';

class HomeController extends GetxController {
  final QuoteRepository _quoteRepo = QuoteRepository();
  final StorageService _storageService = Get.find<StorageService>();

  // Observables
  final RxList<Category> categories = <Category>[].obs;
  final Rx<Category?> selectedCategory = Rx<Category?>(null); // Null means 'All'
  
  final Rx<Quote?> quoteOfTheDay = Rx<Quote?>(null);
  final RxList<Quote> forYouQuotes = <Quote>[].obs;
  
  final RxBool isLoading = true.obs;
  final RxBool isMainLoading = true.obs;
  
  // Streak
  final RxInt streak = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    isMainLoading.value = true;
    
    // Load Streak
    _storageService.updateStreak();
    streak.value = _storageService.getStreak();

    // Load Categories
    final cats = await _quoteRepo.getCategories();
    categories.assignAll(cats);
    
    // Load QOTD
    await fetchQuoteOfTheDay();
    
    // Load For You list
    await fetchForYouQuotes();
    
    isMainLoading.value = false;
  }

  Future<void> fetchQuoteOfTheDay() async {
    final quote = await _quoteRepo.getRandomQuote(categoryId: selectedCategory.value?.id);
    if (quote != null) {
      quoteOfTheDay.value = quote;
    }
  }

  Future<void> fetchForYouQuotes() async {
    // For now just page 1
    final quotes = await _quoteRepo.getQuotes(page: 1, categoryId: selectedCategory.value?.id);
    forYouQuotes.assignAll(quotes);
  }

  void onCategorySelected(Category? category) {
    // Update UI immediately
    selectedCategory.value = category;
    print('Category selected: ${category?.name ?? "All"}');
    update(); // Force GetX to rebuild all observers
    
    // Then load data in background
    _loadCategoryData();
  }
  
  Future<void> _loadCategoryData() async {
    isLoading.value = true;
    
    try {
      // Reload content based on category
      await Future.wait([
        fetchQuoteOfTheDay(),
        fetchForYouQuotes(),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  void shareQuote(Quote quote) {
    Get.bottomSheet(
      ShareSheet(quote: quote),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> copyToClipboard(Quote quote) async {
    await Clipboard.setData(ClipboardData(text: '"${quote.text}" - ${quote.author}'));
    Get.snackbar('Success', 'Quote copied to clipboard', snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> saveQuote(Quote quote) async {
    print('💖 saveQuote called for: ${quote.text.substring(0, 30)}...');
    print('💖 Current state - isLiked: ${quote.isLiked}, likesCount: ${quote.likesCount}');
    
    // Optimistically update UI
    final currentLiked = quote.isLiked;
    final currentCount = quote.likesCount;
    
    // Toggle the state immediately for UI
    final optimisticQuote = Quote(
      id: quote.id,
      text: quote.text,
      author: quote.author,
      categoryId: quote.categoryId,
      isLiked: !currentLiked,
      likesCount: currentLiked ? currentCount - 1 : currentCount + 1,
    );
    
    print('💖 Optimistic update - isLiked: ${optimisticQuote.isLiked}, likesCount: ${optimisticQuote.likesCount}');
    
    // Update QOTD if it's the same quote
    if (quoteOfTheDay.value?.id == quote.id) {
      quoteOfTheDay.value = optimisticQuote;
    }
    
    // Update in For You list
    final index = forYouQuotes.indexWhere((q) => q.id == quote.id);
    if (index != -1) {
      forYouQuotes[index] = optimisticQuote;
    }
    
    // Make API call
    try {
      Quote? updatedQuote;
      if (currentLiked) {
        print('💖 Calling UNLIKE API...');
        updatedQuote = await _quoteRepo.unlikeQuote(quote.id ?? '');
      } else {
        print('💖 Calling LIKE API...');
        updatedQuote = await _quoteRepo.likeQuote(quote.id ?? '');
      }
      
      print('💖 API Response - updatedQuote: ${updatedQuote != null ? "Success" : "Failed"}');
      
      // Update with actual backend data if available
      if (updatedQuote != null) {
        print('💖 Backend response - isLiked: ${updatedQuote.isLiked}, likesCount: ${updatedQuote.likesCount}');
        if (quoteOfTheDay.value?.id == quote.id) {
          quoteOfTheDay.value = updatedQuote;
        }
        if (index != -1) {
          forYouQuotes[index] = updatedQuote;
        }
      }
    } catch (e) {
      print('💖 ERROR: $e');
      // Revert on error
      if (quoteOfTheDay.value?.id == quote.id) {
        quoteOfTheDay.value = quote;
      }
      if (index != -1) {
        forYouQuotes[index] = quote;
      }
      Get.snackbar('Error', 'Failed to update like status');
    }
  }

  // Bookmark/Save to backend favorites
  Future<void> bookmarkQuote(Quote quote) async {
    final isCurrentlyFavorited = quote.isFavorited;
    
    // Optimistic update
    final optimisticQuote = Quote(
      id: quote.id,
      text: quote.text,
      author: quote.author,
      categoryId: quote.categoryId,
      isLiked: quote.isLiked,
      isFavorited: !isCurrentlyFavorited,
      likesCount: quote.likesCount,
    );

    // Update locally
    if (quoteOfTheDay.value?.id == quote.id) {
      quoteOfTheDay.value = optimisticQuote;
    }
    final index = forYouQuotes.indexWhere((q) => q.id == quote.id);
    if (index != -1) {
      forYouQuotes[index] = optimisticQuote;
    }
    update();

    try {
      Quote? updatedQuote;
      if (isCurrentlyFavorited) {
        updatedQuote = await _quoteRepo.unfavoriteQuote(quote.id ?? '');
      } else {
        updatedQuote = await _quoteRepo.favoriteQuote(quote.id ?? '');
      }

      if (updatedQuote != null) {
        if (quoteOfTheDay.value?.id == quote.id) {
          quoteOfTheDay.value = updatedQuote;
        }
        if (index != -1) {
          forYouQuotes[index] = updatedQuote;
        }
        Get.snackbar(
          updatedQuote.isFavorited ? 'Saved' : 'Removed',
          updatedQuote.isFavorited ? 'Quote added to favorites' : 'Quote removed from favorites',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      // Revert on error
      if (quoteOfTheDay.value?.id == quote.id) {
        quoteOfTheDay.value = quote;
      }
      if (index != -1) {
        forYouQuotes[index] = quote;
      }
      Get.snackbar('Error', 'Failed to update favorites');
    }
    update();
  }

  // Check if quote is bookmarked
  bool isQuoteBookmarked(Quote quote) {
    return quote.isFavorited;
  }
}
