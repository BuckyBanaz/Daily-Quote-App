import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/models/quote_model.dart';
import '../../data/models/category_model.dart';
import '../../data/repo/quote_repository.dart';
import '../share/share_bottom_sheet.dart';

class FavoritesController extends GetxController {
  final QuoteRepository _quoteRepo = QuoteRepository();
  
  final RxList<Quote> favorites = <Quote>[].obs;
  final RxList<Category> categories = <Category>[].obs;
  final Rx<Category?> selectedCategory = Rx<Category?>(null);
  final RxString searchText = ''.obs;
  final RxBool isLoading = true.obs;

  Future<void> loadInitialData() async {
    isLoading.value = true;
    
    // Load categories
    final cats = await _quoteRepo.getCategories();
    categories.assignAll(cats);
    
    // Load favorites
    await loadFavorites();
    
    isLoading.value = false;
  }

  Future<void> loadFavorites() async {
    final quotes = await _quoteRepo.getFavorites(categoryId: selectedCategory.value?.id);
    print('Favorites Loaded: ${quotes.length} items');
    favorites.assignAll(quotes);
  }

  void onCategorySelected(Category? category) {
    selectedCategory.value = category;
    print('Favorites - Category selected: ${category?.name ?? "All"}');
    update(); // Force GetX to rebuild all observers
    loadFavorites();
  }

  List<Quote> get filteredFavorites {
    if (searchText.value.isEmpty) {
      return favorites;
    }
    return favorites.where((quote) {
      final query = searchText.value.toLowerCase();
      return quote.text.toLowerCase().contains(query) || 
             quote.author.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> removeFavorite(Quote quote) async {
    // Optimistically remove from UI
    favorites.removeWhere((q) => q.id == quote.id);
    
    // Remove from favorites on backend
    await _quoteRepo.unfavoriteQuote(quote.id ?? '');
  }

  void shareQuote(Quote quote) {
    Get.bottomSheet(
      ShareSheet(quote: quote),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}
