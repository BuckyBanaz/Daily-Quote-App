import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../constant/app_colors.dart';
import '../../data/models/category_model.dart';
import '../../data/models/quote_model.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: controller.loadInitialData,
          color: theme.primaryColor,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Header & Streak
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: 24),
                      _buildStreak(context),
                    ],
                  ),
                ),
              ),

              // Categories
              SliverToBoxAdapter(
                child: _buildCategories(context),
              ),

              // Quote of the Day
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: _buildQuoteOfTheDay(context),
                ),
              ),

              // For You Title
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'For You',
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                      Text(
                        'FRESH DAILY',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // For You List
              Obx(() {
                if (controller.isMainLoading.value && controller.forYouQuotes.isEmpty) {
                  return SliverToBoxAdapter(child: _buildForYouShimmer());
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final quote = controller.forYouQuotes[index];
                      return _buildForYouItem(context, quote);
                    },
                    childCount: controller.forYouQuotes.length,
                  ),
                );
              }),

              // Bottom Padding for Nav Bar
              const SliverPadding(padding: EdgeInsets.only(bottom: 120)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final dayName = DateFormat('EEEE').format(now).toUpperCase();
    final date = DateFormat('MMM d').format(now);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Calendar Icon
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.cardColor,
            border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.calendar_today_outlined, size: 20, color: theme.primaryColor),
        ),

        // Date Info
        Column(
          children: [
            Text(
              dayName,
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),

        // Notification Icon
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.cardColor,
            border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              Icon(Icons.notifications_none_rounded, size: 22, color: theme.iconTheme.color),
              const Positioned(
                top: 0,
                right: 2,
                child: CircleAvatar(
                  radius: 3,
                  backgroundColor: Colors.redAccent,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStreak(BuildContext context) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_fire_department_rounded, color: Colors.orange, size: 20),
            const SizedBox(width: 6),
            Text(
              '${controller.streak.value} DAY STREAK',
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyMedium?.color,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ));
  }

  Widget _buildCategories(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 40,
      child: Obx(() {
        if (controller.categories.isEmpty && controller.isMainLoading.value) {
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

  Widget _buildQuoteOfTheDay(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(() {
      final quote = controller.quoteOfTheDay.value;
      if (quote == null) {
        if (controller.isMainLoading.value) {
          return Shimmer.fromColors(
            baseColor: theme.cardColor.withOpacity(0.5),
            highlightColor: theme.cardColor,
            child: Container(
                height: 400,
                decoration: BoxDecoration(
                    color: theme.cardColor, borderRadius: BorderRadius.circular(24))),
          );
        }
        return const SizedBox();
      }

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'QUOTE OF THE DAY',
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                  letterSpacing: 1.0,
                ),
              ),
            ),

            const SizedBox(height: 32),

            Stack(
              alignment: Alignment.center,
              children: [
                // Background Quote Icon
                Transform.translate(
                  offset: const Offset(0, -10),
                  child: Icon(
                    Icons.format_quote_rounded,
                    size: 100,
                    color: theme.primaryColor.withOpacity(0.05),
                  ),
                ),

                // Content
                Column(
                  children: [
                    Text(
                      '"${quote.text}"',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '— ${quote.author}',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: theme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionButton(
                  context,
                  icon: Icons.favorite,
                  label: quote.likesCount > 0
                      ? '${quote.likesCount}'
                      : 'Like',
                  color: quote.isLiked ? Colors.redAccent : theme.hintColor.withOpacity(0.3),
                  onTap: () => controller.saveQuote(quote),
                ),
                const SizedBox(width: 32),
                _buildActionButton(
                  context,
                  icon: Icons.share_rounded,
                  label: 'Share',
                  color: theme.hintColor.withOpacity(0.3),
                  onTap: () => controller.shareQuote(quote),
                ),
                const SizedBox(width: 32),
                GetBuilder<HomeController>(
                  builder: (ctrl) {
                    final isBookmarked = ctrl.isQuoteBookmarked(quote);
                    return _buildActionButton(
                      context,
                      icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border_rounded,
                      label: 'Save',
                      color: isBookmarked ? theme.primaryColor : theme.hintColor.withOpacity(0.3),
                      onTap: () => controller.bookmarkQuote(quote),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildActionButton(
      BuildContext context,
      {required IconData icon,
      required String label,
      required Color color,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: Theme.of(context).brightness == Brightness.dark
                  ? (Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5) ?? Colors.grey)
                  : (Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.8) ?? Colors.grey.shade700),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForYouItem(BuildContext context, Quote quote) {
    final theme = Theme.of(context);
    return Obx(() {
      final currentQuote = controller.forYouQuotes.firstWhere(
        (q) => q.id == quote.id,
        orElse: () => quote,
      );

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
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
              '"${currentQuote.text}"',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.textTheme.bodyLarge?.color,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '— ${currentQuote.author}',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: theme.primaryColor,
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => controller.saveQuote(currentQuote),
                      child: Icon(
                        currentQuote.isLiked ? Icons.favorite : Icons.favorite_border_rounded,
                        size: 20,
                        color: currentQuote.isLiked ? Colors.redAccent : theme.hintColor.withOpacity(0.3),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => controller.shareQuote(currentQuote),
                      child: Icon(Icons.share_rounded, size: 20, color: theme.hintColor.withOpacity(0.3)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildForYouShimmer() {
    return Column(
      children: List.generate(
          3,
          (index) => Shimmer.fromColors(
                baseColor: Colors.grey.shade200,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 120,
                  margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(16)),
                ),
              )),
    );
  }
}
