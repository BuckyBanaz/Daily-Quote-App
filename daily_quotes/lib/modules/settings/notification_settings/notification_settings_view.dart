import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'notification_settings_controller.dart';
import '../../../data/models/category_model.dart';

class NotificationSettingsView extends GetView<NotificationSettingsController> {
  const NotificationSettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<NotificationSettingsController>()) {
      Get.put(NotificationSettingsController());
    }

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
          "Notification Settings",
          style: theme.appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "DAILY REMINDERS",
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? theme.hintColor.withOpacity(0.5) : theme.hintColor.withOpacity(0.8),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            
            // Daily Inspiration Toggle
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.notifications_active_rounded, color: Colors.blueAccent, size: 24),
                ),
                title: Text(
                  "Daily Inspiration",
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                subtitle: Text(
                  "Receive a new quote every morning",
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    color: isDark ? theme.hintColor.withOpacity(0.5) : theme.hintColor.withOpacity(0.8),
                  ),
                ),
                trailing: Obx(() => Switch(
                  value: controller.dailyReminderEnabled.value,
                  onChanged: controller.toggleDailyReminder,
                  activeColor: theme.primaryColor,
                )),
              ),
            ),
            
            const SizedBox(height: 32),
            
            Obx(() => AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: controller.dailyReminderEnabled.value ? 1.0 : 0.5,
              child: AbsorbPointer(
                absorbing: !controller.dailyReminderEnabled.value,
                child: Column(
                  children: [
                    // Time Picker
                    GestureDetector(
                      onTap: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: controller.selectedTime.value,
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                timePickerTheme: TimePickerThemeData(
                                  backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                                  hourMinuteTextColor: isDark ? Colors.white : Colors.black,
                                  hourMinuteColor: MaterialStateColor.resolveWith((states) =>
                                    states.contains(MaterialState.selected)
                                      ? theme.primaryColor.withOpacity(0.2)
                                      : isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade200,
                                  ),
                                  dayPeriodTextColor: MaterialStateColor.resolveWith((states) =>
                                    states.contains(MaterialState.selected)
                                      ? Colors.white
                                      : isDark ? Colors.white70 : Colors.black87,
                                  ),
                                  dayPeriodColor: MaterialStateColor.resolveWith((states) =>
                                    states.contains(MaterialState.selected)
                                      ? theme.primaryColor
                                      : isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade200,
                                  ),
                                  dialHandColor: theme.primaryColor,
                                  dialBackgroundColor: isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade200,
                                  dialTextColor: MaterialStateColor.resolveWith((states) =>
                                    states.contains(MaterialState.selected)
                                      ? Colors.white
                                      : isDark ? Colors.white70 : Colors.black87,
                                  ),
                                  entryModeIconColor: isDark ? Colors.white70 : Colors.black87,
                                  helpTextStyle: GoogleFonts.outfit(
                                    color: isDark ? Colors.white70 : Colors.black87,
                                  ),
                                ),
                                colorScheme: isDark 
                                  ? ColorScheme.dark(
                                      primary: theme.primaryColor,
                                      onPrimary: Colors.white,
                                      surface: const Color(0xFF1E1E1E),
                                      onSurface: Colors.white,
                                    )
                                  : ColorScheme.light(
                                      primary: theme.primaryColor,
                                      onPrimary: Colors.white,
                                      surface: Colors.white,
                                      onSurface: Colors.black,
                                    ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          controller.updateTime(picked);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
                          boxShadow: [
                            BoxShadow(
                              color: theme.shadowColor.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Preferred Delivery Time",
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isDark ? theme.hintColor.withOpacity(0.6) : theme.hintColor.withOpacity(0.8),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  DateFormat('h:mm').format(
                                    DateTime(2022, 1, 1, controller.selectedTime.value.hour, controller.selectedTime.value.minute)
                                  ),
                                  style: GoogleFonts.outfit(
                                    fontSize: 56,
                                    fontWeight: FontWeight.bold,
                                    color: theme.primaryColor,
                                    height: 1.0,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  DateFormat('a').format(
                                    DateTime(2022, 1, 1, controller.selectedTime.value.hour, controller.selectedTime.value.minute)
                                  ),
                                  style: GoogleFonts.outfit(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: theme.hintColor.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: theme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "Tap to change",
                                style: GoogleFonts.roboto(
                                  fontSize: 12,
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Weekdays
                    SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildDayChip(context, "M", 1),
                          _buildDayChip(context, "T", 2),
                          _buildDayChip(context, "W", 3),
                          _buildDayChip(context, "T", 4),
                          _buildDayChip(context, "F", 5),
                          _buildDayChip(context, "S", 6),
                          _buildDayChip(context, "S", 7),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Quote Category Selector
                    Container(
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
                      ),
                      child: ListTile(
                        onTap: () => _showCategoryBottomSheet(context),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.purpleAccent.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.category_rounded, color: Colors.purpleAccent, size: 24),
                        ),
                        title: Text(
                          "Quote Category",
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        subtitle: Obx(() => Text(
                          controller.selectedCategory.value?.name ?? "All Categories",
                          style: GoogleFonts.roboto(
                            fontSize: 13,
                            color: theme.primaryColor,
                            fontWeight: FontWeight.w500
                          ),
                        )),
                        trailing: Container(
                           padding: const EdgeInsets.all(8),
                           decoration: BoxDecoration(
                             color: theme.scaffoldBackgroundColor,
                             shape: BoxShape.circle,
                           ),
                           child: Icon(Icons.chevron_right_rounded, color: theme.hintColor.withOpacity(0.5), size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
            
            const SizedBox(height: 32),
            
            Text(
              "OTHER OPTIONS",
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? theme.hintColor.withOpacity(0.5) : theme.hintColor.withOpacity(0.8),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            
            // Milestone Alerts
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
              ),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.star_rounded, color: Colors.orangeAccent, size: 24),
                    ),
                    title: Text("Milestone Alerts", style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w500, color: theme.textTheme.bodyLarge?.color)),
                    trailing: Obx(() => Switch(
                      value: controller.milestoneAlerts.value,
                      onChanged: (val) => controller.milestoneAlerts.value = val,
                      activeColor: theme.primaryColor,
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(height: 1, color: isDark ? theme.dividerColor.withOpacity(0.05) : Colors.grey.shade200),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.history_edu_rounded, color: Colors.deepPurpleAccent, size: 24),
                    ),
                    title: Text("Weekly Recap", style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w500, color: theme.textTheme.bodyLarge?.color)),
                    trailing: Obx(() => Switch(
                      value: controller.weeklyRecap.value,
                      onChanged: (val) => controller.weeklyRecap.value = val,
                      activeColor: theme.primaryColor,
                    )),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 48),
            
            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.saveSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  elevation: 5,
                  shadowColor: theme.primaryColor.withOpacity(0.4),
                ),
                child: Text(
                  "Save Changes",
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDayChip(BuildContext context, String label, int day) {
    final theme = Theme.of(context);
    return Obx(() {
      final isSelected = controller.selectedWeekdays.contains(day);
      return GestureDetector(
        onTap: () => controller.toggleWeekday(day),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isSelected ? theme.primaryColor : theme.cardColor,
            shape: BoxShape.circle,
            border: isSelected ? null : Border.all(color: theme.dividerColor.withOpacity(0.1)),
             boxShadow: isSelected
              ? [BoxShadow(color: theme.primaryColor.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 2))]
              : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : theme.hintColor.withOpacity(0.6),
            ),
          ),
        ),
      );
    });
  }

  void _showCategoryBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.dividerColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Select Category",
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                   _buildCategoryOption(context, null, "All Categories", Icons.category_outlined),
                   ...controller.categories.map((cat) => 
                      _buildCategoryOption(context, cat, cat.name, Icons.bookmark_outline_rounded)
                   ).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildCategoryOption(BuildContext context, Category? category, String name, IconData icon) {
     final theme = Theme.of(context);
     return Obx(() {
       final isSelected = controller.selectedCategory.value?.id == category?.id;
       return ListTile(
         onTap: () {
            controller.setCategory(category);
            Get.back();
         },
         leading: Container(
           padding: const EdgeInsets.all(8),
           decoration: BoxDecoration(
             color: isSelected ? theme.primaryColor.withOpacity(0.1) : theme.dividerColor.withOpacity(0.05),
             shape: BoxShape.circle,
           ),
           child: Icon(
             icon, 
             color: isSelected ? theme.primaryColor : theme.hintColor.withOpacity(0.5),
             size: 20,
           ),
         ),
         title: Text(
           name,
           style: GoogleFonts.outfit(
             fontSize: 16,
             fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
             color: isSelected ? theme.primaryColor : theme.textTheme.bodyLarge?.color,
           ),
         ),
         trailing: isSelected 
            ? Icon(Icons.check_circle_rounded, color: theme.primaryColor, size: 24)
            : null,
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
       );
     });
  }
}
