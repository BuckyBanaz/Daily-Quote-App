import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constant/app_colors.dart';
import '../../core/utils/animations.dart';
import '../../constant/app_strings.dart';
import '../../data/models/quote_model.dart';
import '../../data/models/category_model.dart';
import '../../modules/share/share_bottom_sheet.dart';
import '../../modules/dashboard/dashboard_controller.dart';
import '../../routes/app_routes.dart';
import 'favorites_controller.dart';

class FavoritesView extends GetView<FavoritesController> {
  const FavoritesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      extendBodyBehindAppBar: true, 
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Center(
                  child: Text(
                    "Favorites",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
              ),

              // Search Bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 52,
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
                ),
                child: TextField(
                  onChanged: (val) => controller.searchText.value = val,
                  decoration: InputDecoration(
                    hintText: "Search your favorites...",
                    hintStyle: GoogleFonts.roboto(color: isDark ? theme.hintColor.withOpacity(0.5) : theme.hintColor.withOpacity(0.8), fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: isDark ? theme.hintColor.withOpacity(0.5) : theme.hintColor.withOpacity(0.8), size: 20),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  style: GoogleFonts.roboto(color: theme.textTheme.bodyLarge?.color, fontSize: 14),
                  cursorColor: theme.primaryColor,
                ),
              ),

              // Categories
              _buildCategories(context),

              const SizedBox(height: 10),

              // Favorites List
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value && controller.favorites.isEmpty) {
                    return Center(
                      child: CircularProgressIndicator(color: theme.primaryColor),
                    );
                  }

                  final displayList = controller.filteredFavorites;

                  if (controller.favorites.isEmpty) {
                    return _buildEmptyState(context);
                  }
                  
                  if (displayList.isEmpty) {
                    return _buildNoResultsState(context);
                  }

                  return RefreshIndicator(
                    onRefresh: controller.loadFavorites,
                    color: theme.primaryColor,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: displayList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final quote = displayList[index];
                        return StaggeredSlideFade(
                          index: index,
                          child: _buildFavoriteCard(context, quote),
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.favorite_border,
                size: 50,
                color: theme.primaryColor.withOpacity(0.5),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "No favorites yet",
            style: GoogleFonts.roboto(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Tap the heart icon to save your favorite quotes and find them here later.",
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: isDark ? theme.hintColor.withOpacity(0.5) : theme.hintColor.withOpacity(0.8),
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              if (Get.isRegistered<DashboardController>()) {
                Get.find<DashboardController>().changeTab(0);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              "Explore Quotes",
              style: GoogleFonts.roboto(
                fontSize: 14, 
                fontWeight: FontWeight.w600
              ),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildNoResultsState(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: theme.hintColor.withOpacity(0.2)),
          const SizedBox(height: 16),
          Text(
            "No matches found",
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Try searching with different keywords",
            style: GoogleFonts.roboto(color: isDark ? theme.hintColor.withOpacity(0.5) : theme.hintColor.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteCard(BuildContext context, Quote quote) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => Get.bottomSheet(
         ShareSheet(quote: quote),
         isScrollControlled: true,
         backgroundColor: Colors.transparent,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          ],
          border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "\"${quote.text}\"",
                    style: GoogleFonts.roboto(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    quote.author.toUpperCase(),
                    style: GoogleFonts.roboto(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isDark ? theme.hintColor.withOpacity(0.5) : theme.hintColor.withOpacity(0.8),
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Theme(
              data: theme.copyWith(
                useMaterial3: true,
                popupMenuTheme: PopupMenuThemeData(
                  color: theme.cardColor,
                  surfaceTintColor: theme.cardColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                ),
              ),
              child: PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: isDark ? theme.hintColor.withOpacity(0.3) : theme.hintColor.withOpacity(0.6), size: 24),
                onSelected: (value) {
                  if (value == 'share') {
                    Get.bottomSheet(
                      ShareSheet(quote: quote),
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                    );
                  } else if (value == 'delete') {
                    controller.removeFavorite(quote);
                    Get.snackbar(
                      "Deleted", 
                      "Quote removed from favorites", 
                      snackPosition: SnackPosition.BOTTOM,
                      margin: const EdgeInsets.all(20),
                      duration: const Duration(seconds: 2),
                    );
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                   PopupMenuItem<String>(
                    value: 'share',
                    height: 40,
                    child: Row(
                      children: [
                         Icon(Icons.share_outlined, size: 18, color: isDark ? theme.hintColor.withOpacity(0.5) : theme.hintColor.withOpacity(0.8)),
                         const SizedBox(width: 12),
                         Text(
                           'Share', 
                           style: GoogleFonts.roboto(fontSize: 14, color: theme.textTheme.bodyLarge?.color)
                         ),
                      ],
                    ),
                  ),
                   const PopupMenuDivider(height: 1),
                   PopupMenuItem<String>(
                    value: 'delete',
                    height: 40,
                    child: Row(
                      children: [
                         const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                         const SizedBox(width: 12),
                         Text(
                           'Delete', 
                           style: GoogleFonts.roboto(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.w500)
                         ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 40,
      child: Obx(() {
        if (controller.categories.isEmpty && controller.isLoading.value) {
          return const SizedBox();
        }

        final allCategories = [
          Category(id: 'all', name: 'All', slug: 'all'),
          ...controller.categories
        ];

        return ListView.builder(
          key: ValueKey(controller.selectedCategory.value?.id ?? 'all'),
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          physics: const BouncingScrollPhysics(),
          itemCount: allCategories.length,
          itemBuilder: (context, index) {
            final cat = allCategories[index];
            
            bool isSelected;
            if (cat.id == 'all') {
              isSelected = controller.selectedCategory.value == null;
            } else {
              isSelected = controller.selectedCategory.value?.id == cat.id;
            }

            return GestureDetector(
              onTap: () {
                if (cat.id == 'all') {
                  controller.onCategorySelected(null);
                } else {
                  controller.onCategorySelected(cat);
                }
              },
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? theme.primaryColor : theme.cardColor,
                  borderRadius: BorderRadius.circular(30),
                  border: isSelected ? null : Border.all(color: theme.dividerColor.withOpacity(0.05)),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                              color: theme.primaryColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4))
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  cat.name,
                  style: GoogleFonts.outfit(
                    color: isSelected ? Colors.white : theme.textTheme.bodyLarge?.color,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
