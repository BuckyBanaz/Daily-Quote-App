import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constant/app_colors.dart';
import '../../core/utils/animations.dart';
import '../../constant/app_strings.dart';
import '../../data/models/quote_model.dart';
import '../../modules/share/share_bottom_sheet.dart';
import '../../modules/dashboard/dashboard_controller.dart';
import '../../routes/app_routes.dart';
import 'favorites_controller.dart';

class FavoritesView extends GetView<FavoritesController> {
  const FavoritesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, 
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {}, // functionality not requested yet, purely visual match
      //   backgroundColor: const Color(0xFF26A69A), // Teal
      //   child: const Icon(Icons.add, color: Colors.white),
      // ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              const Color(0xFFE0F2F1).withOpacity(0.5),
              const Color(0xFFB2DFDB).withOpacity(0.3),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    // IconButton(
                    //   icon: const Icon(Icons.chevron_left, color: Colors.grey, size: 28),
                    //   onPressed: () => Get.back(),
                    // ),
                    Expanded(
                      child: Text(
                        "Favorites",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    // IconButton(
                    //   icon: const Icon(Icons.search, color: Colors.grey, size: 24),
                    //   onPressed: () {}, 
                    // ),
                  ],
                ),
              ),

              // Search Bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]
                ),
                child: TextField(
                  onChanged: (val) => controller.searchText.value = val,
                  decoration: InputDecoration(
                    hintText: "Search saved quotes",
                    hintStyle: GoogleFonts.roboto(color: Colors.grey.shade300, fontSize: 14),
                    icon: Icon(Icons.search, color: Colors.grey.shade300, size: 20),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  style: GoogleFonts.roboto(color: AppColors.textPrimary, fontSize: 14),
                  cursorColor: AppColors.primary,
                ),
              ),

              const SizedBox(height: 10),

              // Favorites List
              Expanded(
                child: Obx(() {
                  // Use filteredFavorites instead of all favorites
                  final displayList = controller.filteredFavorites;

                  if (controller.favorites.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite_border, size: 48, color: Colors.grey.shade300),
                          const SizedBox(height: 16),
                          Text(
                            "No favorites yet",
                            style: GoogleFonts.roboto(color: Colors.grey.shade400),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  // Show "No matches" if search yields nothing but favorites exist
                  if (displayList.isEmpty) {
                     // Professional Empty State
                     return Center(
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           // Heart Circle
                           Container(
                             width: 120,
                             height: 120,
                             decoration: BoxDecoration(
                               color: const Color(0xFFE0F2F1), // Light Teal
                               shape: BoxShape.circle,
                             ),
                             child: Center(
                               child: Icon(
                                 Icons.favorite,
                                 size: 50,
                                 color: AppColors.primary.withOpacity(0.5),
                               ),
                             ),
                           ),
                           const SizedBox(height: 24),
                           
                           // Title
                           Text(
                             "No favorites yet",
                             style: GoogleFonts.roboto(
                               fontSize: 20,
                               fontWeight: FontWeight.bold,
                               color: AppColors.textPrimary,
                             ),
                           ),
                           
                           const SizedBox(height: 12),
                           
                           // Subtitle
                           Padding(
                             padding: const EdgeInsets.symmetric(horizontal: 40),
                             child: Text(
                               "Tap the heart icon to save your favorite quotes and find them here later.",
                               textAlign: TextAlign.center,
                               style: GoogleFonts.roboto(
                                 fontSize: 14,
                                 color: Colors.grey.shade500,
                                 height: 1.5,
                               ),
                             ),
                           ),

                           const SizedBox(height: 32),

                           // Explore Button
                           ElevatedButton(
                             onPressed: () {
                               // Find DashboardController and switch tab
                               if (Get.isRegistered<DashboardController>()) {
                                 Get.find<DashboardController>().changeTab(0);
                               } else {
                                  Get.toNamed(AppRoutes.HOME); // Fallback
                               }
                             },
                             style: ElevatedButton.styleFrom(
                               backgroundColor: const Color(0xFF26A69A),
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
                           const SizedBox(height: 80), // Bottom spacing for nav bar
                         ],
                       ),
                     );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      controller.loadFavorites();
                    },
                    color: AppColors.primary,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
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

  Widget _buildFavoriteCard(BuildContext context, Quote quote) {
    return GestureDetector(
      onTap: () => Get.bottomSheet(
         ShareSheet(quote: quote),
         isScrollControlled: true,
         backgroundColor: Colors.transparent,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24), // Highly rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          ],
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
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    quote.author.toUpperCase(),
                    style: GoogleFonts.roboto(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade400,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Theme(
              data: Theme.of(context).copyWith(
                useMaterial3: true,
                popupMenuTheme: PopupMenuThemeData(
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                ),
              ),
              child: PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.grey.shade400, size: 24),
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
                         Icon(Icons.share_outlined, size: 18, color: AppColors.textSecondary),
                         const SizedBox(width: 12),
                         Text(
                           'Share', 
                           style: GoogleFonts.roboto(fontSize: 14, color: AppColors.textPrimary)
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
}
