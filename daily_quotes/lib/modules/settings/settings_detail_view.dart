import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constant/app_colors.dart';
import 'settings_controller.dart';
import 'notification_settings/notification_settings_view.dart';

class SettingsDetailView extends GetView<SettingsController> {
  const SettingsDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          "Settings",
          style: theme.appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildSectionHeader(context, "APPEARANCE"),
            
            // Appearance Card
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                   ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.dark_mode_outlined, color: theme.primaryColor, size: 20),
                    ),
                    title: Text("Dark Mode", style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w500, color: theme.textTheme.bodyLarge?.color)),
                    trailing: Obx(() => Switch(
                      value: controller.isDarkMode.value,
                      onChanged: (val) => controller.toggleDarkMode(val),
                      activeColor: theme.primaryColor,
                    )),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(height: 1, color: theme.dividerColor.withOpacity(0.05)),
                  ),

                  // Theme Color Tile
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.palette_outlined, color: theme.primaryColor, size: 20),
                    ),
                    title: Text("Theme Color", style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w500, color: theme.textTheme.bodyLarge?.color)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildColorDot(0xFF26A69A), // Teal
                        const SizedBox(width: 12),
                        _buildColorDot(0xFFFF9800), // Orange
                        const SizedBox(width: 12),
                        _buildColorDot(0xFF9C27B0), // Purple
                        const SizedBox(width: 12),
                        Icon(Icons.chevron_right, color: theme.hintColor.withOpacity(0.3), size: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            _buildSectionHeader(context, "TYPOGRAPHY"),

            // Typography Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8EAF6).withOpacity(theme.brightness == Brightness.dark ? 0.1 : 1.0),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.text_fields_rounded, color: theme.brightness == Brightness.dark ? Colors.white70 : const Color(0xFF3F51B5), size: 20),
                      ),
                      const SizedBox(width: 16),
                      Text("Font Size", style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w500, color: theme.textTheme.bodyLarge?.color)),
                      const Spacer(),
                      Obx(() => Text(
                        _getFontSizeLabel(controller.fontSizeScale.value),
                        style: GoogleFonts.roboto(
                          color: isDark ? theme.hintColor.withOpacity(0.5) : theme.hintColor.withOpacity(0.8), 
                          fontSize: 13
                        ),
                      )),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Text("A", style: GoogleFonts.roboto(fontSize: 12, color: theme.hintColor.withOpacity(0.5))),
                      Expanded(
                        child: Obx(() => Slider(
                          value: controller.fontSizeScale.value,
                          min: 0.8,
                          max: 1.4,
                          divisions: 2,
                          onChanged: (val) => controller.updateFontSize(val),
                          activeColor: theme.primaryColor,
                          inactiveColor: isDark ? theme.dividerColor.withOpacity(0.1) : Colors.grey.shade300,
                        )),
                      ),
                      Text("A", style: GoogleFonts.roboto(fontSize: 20, color: theme.hintColor.withOpacity(0.5))),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            _buildSectionHeader(context, "NOTIFICATIONS"),

            // Notifications Card
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.notifications_outlined, color: Colors.blueAccent, size: 20),
                ),
                title: Text("Push Notifications", style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w500, color: theme.textTheme.bodyLarge?.color)),
                subtitle: Text("Manage daily reminders", style: GoogleFonts.roboto(fontSize: 12, color: isDark ? theme.hintColor.withOpacity(0.5) : theme.hintColor.withOpacity(0.8))),
                trailing: Icon(Icons.chevron_right, color: theme.hintColor.withOpacity(0.3), size: 20),
                onTap: () => Get.to(() => const NotificationSettingsView()),
              ),
            ),

            const SizedBox(height: 32),
            _buildSectionHeader(context, "ACCOUNT"),

            // Account Card
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.dividerColor.withOpacity(0.02),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.person_outline_rounded, color: theme.hintColor.withOpacity(0.5), size: 20),
                    ),
                    title: Obx(() => Text(
                      controller.userData['name'] ?? "User",
                      style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w500, color: theme.textTheme.bodyLarge?.color),
                    )),
                    subtitle: Obx(() => Text(
                      controller.userData['email'] ?? "email@example.com",
                      style: GoogleFonts.roboto(
                        fontSize: 12, 
                        color: isDark ? theme.hintColor.withOpacity(0.5) : theme.hintColor.withOpacity(0.8)
                      ),
                    )),
                    trailing: Icon(Icons.chevron_right, color: theme.hintColor.withOpacity(0.3), size: 20),
                    onTap: () {},
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(height: 1, color: theme.dividerColor.withOpacity(0.05)),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEEBEE).withOpacity(theme.brightness == Brightness.dark ? 0.1 : 1.0),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.logout_rounded, color: Color(0xFFEF5350), size: 20),
                    ),
                    title: Text("Sign Out", style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w500, color: const Color(0xFFEF5350))),
                    onTap: () => controller.logout(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),
            Center(
              child: Text(
                "VERSION 2.4.0",
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  color: theme.hintColor.withOpacity(0.3),
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: theme.brightness == Brightness.dark 
              ? theme.hintColor.withOpacity(0.5) 
              : theme.hintColor.withOpacity(0.8),
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildColorDot(int colorHex) {
    return GestureDetector(
      onTap: () => controller.updateThemeColor(colorHex),
      child: Obx(() {
        final isSelected = controller.themeColorValue.value == colorHex;
        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Color(colorHex),
            shape: BoxShape.circle,
            border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: Color(colorHex).withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: isSelected 
            ? const Icon(Icons.check, color: Colors.white, size: 14)
            : null,
        );
      }),
    );
  }

  String _getFontSizeLabel(double scale) {
    if (scale <= 0.9) return "Small";
    if (scale >= 1.2) return "Large";
    return "Medium";
  }
}
