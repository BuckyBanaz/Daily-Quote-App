import 'package:get/get.dart';
import '../../data/models/quote_model.dart';
import '../../data/services/storage_service.dart';
import 'package:share_plus/share_plus.dart';

class FavoritesController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  final RxList<Quote> favorites = <Quote>[].obs;
  final RxString searchText = ''.obs;

  @override
  void onInit() {
    super.onInit();
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

  void loadFavorites() {
    favorites.value = _storageService.getFavorites();
  }

  void removeFavorite(Quote quote) {
    favorites.remove(quote);
    _storageService.saveFavorites(favorites);
    update();
  }

  void shareQuote(Quote quote) {
    Share.share('"${quote.text}" - ${quote.author}');
  }
}
