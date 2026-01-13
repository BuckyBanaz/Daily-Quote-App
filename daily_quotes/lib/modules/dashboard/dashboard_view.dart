import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constant/app_colors.dart';
import '../home/home_view.dart';
import '../favorites/favorites_view.dart';
import '../categories/categories_view.dart';
import '../settings/settings_view.dart';
import 'dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Content
          Obx(() => IndexedStack(
            index: controller.tabindex.value,
            children: const [
              HomeView(),
              CategoriesView(),
              FavoritesView(),
              SettingsView(),
            ],
          )),
          
          // Floating Bottom Nav (Custom Pill)
          Positioned(
            bottom: 30, // Floating off bottom
            left: 0, 
            right: 0,
            child: Center(
              child: Container(
                // Increased width for 4 items
                width: 300, 
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: theme.cardColor.withOpacity(theme.brightness == Brightness.dark ? 0.95 : 1.0),
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                      spreadRadius: -5,
                    )
                  ]
                ),
                child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _NavIcon(
                      context: context,
                      icon: Icons.home_rounded, 
                      isActive: controller.tabindex.value == 0, 
                      onTap: () => controller.changeTab(0),
                    ),
                    _NavIcon(
                      context: context,
                      icon: Icons.grid_view_rounded, 
                      isActive: controller.tabindex.value == 1, 
                      onTap: () => controller.changeTab(1),
                    ),
                    _NavIcon(
                      context: context,
                      icon: Icons.favorite_rounded, 
                      isActive: controller.tabindex.value == 2, 
                      onTap: () => controller.changeTab(2),
                    ),
                    _NavIcon(
                      context: context,
                      icon: Icons.settings_rounded, 
                      isActive: controller.tabindex.value == 3, 
                      onTap: () => controller.changeTab(3),
                    ),
                  ],
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _NavIcon({required BuildContext context, required IconData icon, required bool isActive, required VoidCallback onTap}) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: isActive ? BoxDecoration(
          color: theme.primaryColor,
          shape: BoxShape.circle,
        ) : const BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon, 
          color: isActive 
              ? Colors.white 
              : (Theme.of(context).brightness == Brightness.dark 
                  ? theme.hintColor.withOpacity(0.3) 
                  : theme.hintColor.withOpacity(0.6)),
          size: 24,
        ),
      ),
    );
  }
}
