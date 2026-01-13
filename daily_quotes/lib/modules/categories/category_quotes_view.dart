import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constant/app_colors.dart';
import '../../data/models/quote_model.dart';
import '../../data/models/category_model.dart';
import '../../modules/share/share_bottom_sheet.dart';
import 'category_quotes_controller.dart';

class CategoryQuotesView extends StatelessWidget {
  final Category category;
  
  const CategoryQuotesView({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Put controller with unique ID for each category
    final controller = Get.put(
      CategoryQuotesController(category: category),
      tag: category.id,
    );

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: theme.iconTheme.color, size: 28),
          onPressed: () => Get.back(),
        ),
        title: Text(
          category.name,
          style: theme.appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: theme.primaryColor));
        }

        if (controller.quotes.isEmpty) {
          return Center(
            child: Text(
              "No quotes in this category yet.",
              style: GoogleFonts.roboto(color: isDark ? theme.hintColor.withOpacity(0.5) : theme.hintColor.withOpacity(0.8)),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          itemCount: controller.quotes.length,
          itemBuilder: (context, index) {
            final quote = controller.quotes[index];
            return _buildQuoteCard(context, controller, quote);
          },
        );
      }),
    );
  }

  Widget _buildQuoteCard(BuildContext context, CategoryQuotesController controller, Quote quote) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "\"${quote.text}\"",
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1.5,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "— ${quote.author}",
                style: GoogleFonts.roboto(
                  fontSize: 13,
                  color: theme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => Get.bottomSheet(
                      ShareSheet(quote: quote),
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                    ),
                    icon: Icon(Icons.share_outlined, color: isDark ? theme.hintColor.withOpacity(0.3) : theme.hintColor.withOpacity(0.6), size: 20),
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  IconButton(
                    onPressed: () => controller.toggleFavorite(quote),
                    icon: Icon(
                      quote.isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: quote.isFavorited ? Colors.redAccent : (isDark ? theme.hintColor.withOpacity(0.3) : theme.hintColor.withOpacity(0.6)),
                      size: 22,
                    ),
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(4),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
