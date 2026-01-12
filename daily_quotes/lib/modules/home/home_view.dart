import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/utils/shimmer_helper.dart';
import '../../modules/share/share_bottom_sheet.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../constant/app_colors.dart';
import '../../constant/app_strings.dart';
import 'home_controller.dart';
import '../../routes/app_routes.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              const Color(0xFFE0F2F1).withOpacity(0.5), // Very light teal/mint
              const Color(0xFFB2DFDB).withOpacity(0.3), // Slightly stronger at bottom
            ],
            stops: const [0.5, 0.8, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
          children: [
            const SizedBox(height: 16),
            _buildTopBar(context),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    Text(
                      "YOUR DAILY JOURNEY",
                      style: GoogleFonts.roboto(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade400,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(() => Text(
                      "${controller.streak.value} Day Streak",
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    )),
                    
                    const SizedBox(height: 24),
                    
                    // Main Quote Card
                    Expanded(
                      flex: 3,
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return ShimmerHelper.buildQuoteCardShimmer();
                        }
                        if (controller.currentQuote.value == null) {
                          return Center(
                            child: ElevatedButton(
                              onPressed: controller.fetchNewQuote, 
                              child: const Text('Reload'),
                            ),
                          );
                        }
                        return _buildQuoteCard(context);
                      }),
                    ),
                    

                  ],
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined, size: 24, color: AppColors.primary),
            onPressed: () => _showCalendarDialog(context),
          ),
          Column(
            children: [
              Text(
                DateFormat('EEEE').format(DateTime.now()).toUpperCase(),
                style: GoogleFonts.roboto(
                  fontSize: 10, 
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  letterSpacing: 1.0,
                ),
              ),
              Text(
                DateFormat('MMM d').format(DateTime.now()),
                style: GoogleFonts.roboto(
                  fontSize: 16, 
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, size: 28, color: AppColors.textPrimary),
            onPressed: controller.fetchNewQuote,
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteCard(BuildContext context) {
    final quote = controller.currentQuote.value!;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20), // Even tighter vertical padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Quote Icon
          Icon(
            Icons.format_quote_rounded, 
            size: 40, // Smaller icon
            color: AppColors.primary.withOpacity(0.2),
          ),
          const SizedBox(height: 12),
          
          // Quote Text
          Text(
            quote.text,
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 18, // Smaller font size
              height: 1.4,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              fontStyle: FontStyle.italic,
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Author
          Text(
            "- ${quote.author}",
            style: GoogleFonts.roboto(
              fontSize: 14, // Smaller author font
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 24), // Compact spacing
          
          // Action Buttons Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Share Button
                _buildActionButton(
                  icon: Icons.share_outlined,
                  color: Colors.grey.shade600,
                  bgColor: Colors.grey.shade100,
                  label: "Share",
                  labelColor: Colors.grey.shade600,
                  onTap: () => _showShareBottomSheet(context),
                ),
                
                const SizedBox(width: 32),

                 // Save Button
                Obx(() => _buildActionButton(
                  icon: controller.isFavorite.value ? Icons.bookmark : Icons.bookmark_outline,
                  color: controller.isFavorite.value ? AppColors.primary : Colors.grey.shade600,
                  bgColor: controller.isFavorite.value ? AppColors.primary.withOpacity(0.1) : Colors.grey.shade100,
                  label: controller.isFavorite.value ? "Saved" : "Save",
                  labelColor: controller.isFavorite.value ? AppColors.primary : Colors.grey.shade600,
                  onTap: controller.toggleFavorite,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required Color bgColor,
    required String label,
    required Color labelColor,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 11, 
            color: labelColor, 
            fontWeight: FontWeight.w500
          ),
        )
      ],
    );
  }





  // --- Reused Helper Methods (Share Sheet) ---
    void _showShareBottomSheet(BuildContext context) {
    if (controller.currentQuote.value != null) {
      Get.bottomSheet(
        ShareSheet(quote: controller.currentQuote.value!),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
      );
    }
  }

  void _showCalendarDialog(BuildContext context) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Your Journey",
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Obx(() {
                // Register listener
                controller.streakDates.length; 
                return TableCalendar(
                firstDay: DateTime.utc(2024, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: DateTime.now(),
                calendarFormat: CalendarFormat.month,
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                  titleTextStyle: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                selectedDayPredicate: (day) {
                  return controller.streakDates.any((d) => 
                    d.year == day.year && 
                    d.month == day.month && 
                    d.day == day.day
                  );
                },
              );
              }),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Get.back(),
                child: Text("Close", style: GoogleFonts.roboto(color: AppColors.primary, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }
}




