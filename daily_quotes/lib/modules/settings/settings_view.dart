import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constant/app_colors.dart';
import 'settings_controller.dart';
import 'settings_detail_view.dart';
import 'notification_settings/notification_settings_view.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<SettingsController>()) {
      Get.put(SettingsController());
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Profile",
          style: theme.appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Profile Photo with Edit Icon
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: theme.dividerColor.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      size: 80,
                      color: theme.hintColor.withOpacity(0.2),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // User Info
            Obx(() => Text(
              controller.userData['name'] ?? "User",
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            )),
            Obx(() => Text(
              controller.userData['email'] ?? "email@example.com",
              style: GoogleFonts.roboto(
                fontSize: 13,
                color: isDark ? theme.hintColor.withOpacity(0.5) : theme.hintColor.withOpacity(0.8),
              ),
            )),

            const SizedBox(height: 25),

            // Stats Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(() => _buildStatCard(
                      context,
                      icon: Icons.favorite_rounded,
                      value: controller.userFavoritesCount.value.toString(),
                      label: "My Favorites",
                    )),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      context,
                      icon: Icons.share_rounded,
                   value: controller.userStreak.value.toString(),
                      label: "Quotes Shared",
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Settings Group
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
                ),
                child: Column(
                  children: [
                    _buildSettingsTile(
                      context,
                      icon: Icons.settings_rounded,
                      title: "Settings",
                      isFirst: true,
                    ),
                    _buildSettingsTile(
                      context,
                      icon: Icons.notifications_rounded,
                      title: "Notifications",
                      hasSwitch: false,
                    ),
                    _buildSettingsTile(
                      context,
                      icon: Icons.security_rounded,
                      title: "Privacy & Security",
                      isLast: true,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 48),

            // Logout Link
            TextButton.icon(
              onPressed: () => controller.logout(),
              icon: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
              label: Text(
                "Logout",
                style: GoogleFonts.outfit(
                  color: Colors.redAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 24),
            
            Text(
              "QUOTEVAULT V2.4.0",
              style: GoogleFonts.outfit(
                fontSize: 10,
                color: isDark ? theme.hintColor.withOpacity(0.3) : theme.hintColor.withOpacity(0.6),
                letterSpacing: 2,
              ),
            ),

            const SizedBox(height: 100), // Bottom nav space
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, {required IconData icon, required String value, required String label}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(32),
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
        children: [
          Icon(icon, color: theme.primaryColor, size: 32),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).brightness == Brightness.dark 
                  ? theme.hintColor.withOpacity(0.5) 
                  : theme.hintColor.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    bool hasSwitch = false,
    bool isFirst = false,
    bool isLast = false,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Column(
      children: [
        if (!isFirst) 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Divider(height: 1, color: theme.dividerColor.withOpacity(0.05)),
          ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: theme.primaryColor, size: 20),
          ),
          title: Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
          trailing: hasSwitch 
            ? Obx(() => SizedBox(
                height: 24,
                width: 44,
                child: Switch(
                  value: controller.notificationsEnabled.value,
                  onChanged: (val) => controller.toggleNotifications(val),
                  activeColor: theme.primaryColor,
                ),
              ))
            : Icon(Icons.chevron_right_rounded, color: isDark ? theme.hintColor.withOpacity(0.3) : theme.hintColor.withOpacity(0.6)),
          onTap: () {
            if (title == "Settings") {
              Get.to(() => const SettingsDetailView());
            } else if (title == "Notifications") {
              Get.to(() => const NotificationSettingsView());
            }
          },
        ),
      ],
    );
  }
}
