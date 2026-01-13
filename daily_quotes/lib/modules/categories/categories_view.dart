import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constant/app_colors.dart';
import '../../data/models/category_model.dart';
import 'categories_controller.dart';

import 'category_quotes_view.dart';

class CategoriesView extends GetView<CategoriesController> {
  const CategoriesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<CategoriesController>()) {
      Get.put(CategoriesController());
    }

    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Categories",
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator(color: theme.primaryColor));
                }

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final cat = controller.categories[index];
                    return _buildCategoryCard(context, cat);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, Category cat) {
    final theme = Theme.of(context);
    final catColor = Color(int.parse((cat.color ?? '#26A69A').replaceAll('#', '0xFF')));

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Get.to(() => CategoryQuotesView(category: cat));
          },
          borderRadius: BorderRadius.circular(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: catColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  cat.icon ?? '✨',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                cat.name,
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
