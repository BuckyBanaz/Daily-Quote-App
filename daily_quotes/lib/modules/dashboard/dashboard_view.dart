import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constant/app_colors.dart';
import '../home/home_view.dart';
import '../favorites/favorites_view.dart';
import 'dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Content
          Obx(() => IndexedStack(
            index: controller.tabindex.value,
            children: const [
              HomeView(),
              FavoritesView(),
            ],
          )),
          
          // Floating Bottom Nav (Custom Pill)
          Positioned(
            bottom: 30, // Floating off bottom
            left: 0, 
            right: 0,
            child: Center(
              child: Container(
                // Smaller width for just 2 items
                width: 180, 
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                      spreadRadius: 2,
                    )
                  ]
                ),
                child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _NavIcon(
                      icon: Icons.home_rounded, 
                      isActive: controller.tabindex.value == 0, 
                      onTap: () => controller.changeTab(0),
                    ),
                    _NavIcon(
                      icon: Icons.favorite_rounded, 
                      isActive: controller.tabindex.value == 1, 
                      onTap: () => controller.changeTab(1),
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

  Widget _NavIcon({required IconData icon, required bool isActive, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: isActive ? const BoxDecoration(
          color: AppColors.primary, // Teal
          shape: BoxShape.circle,
        ) : const BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon, 
          color: isActive ? Colors.white : Colors.grey.shade400,
          size: 24,
        ),
      ),
    );
  }
}
