import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daily_quotes/data/services/storage_service.dart';
import 'package:daily_quotes/data/services/notification_service.dart';
import 'package:daily_quotes/data/models/category_model.dart';
import 'package:daily_quotes/modules/categories/categories_controller.dart';
import 'package:daily_quotes/data/repo/quote_repository.dart';

class NotificationSettingsController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  final NotificationService _notificationService = Get.find<NotificationService>();
  
  // State
  final RxBool dailyReminderEnabled = true.obs;
  final Rx<TimeOfDay> selectedTime = const TimeOfDay(hour: 8, minute: 0).obs;
  final RxList<int> selectedWeekdays = <int>[1, 2, 3, 4, 5, 6, 7].obs; // 1=Mon, 7=Sun
  final Rx<Category?> selectedCategory = Rx<Category?>(null);
  
  final RxBool milestoneAlerts = false.obs;
  final RxBool weeklyRecap = true.obs;

  final RxList<Category> categories = <Category>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
    _loadCategories();
  }

  void _loadSettings() {
    dailyReminderEnabled.value = _storageService.read('notification_enabled') ?? true;
    
    final int hour = _storageService.read('notification_hour') ?? 8;
    final int minute = _storageService.read('notification_minute') ?? 0;
    selectedTime.value = TimeOfDay(hour: hour, minute: minute);
    
    final List<dynamic>? savedDays = _storageService.read('notification_weekdays');
    if (savedDays != null) {
      selectedWeekdays.assignAll(savedDays.cast<int>());
    }

    milestoneAlerts.value = _storageService.read('milestone_alerts') ?? false;
    weeklyRecap.value = _storageService.read('weekly_recap') ?? true;
    
    // Category load needs to match ID
    final String? catId = _storageService.read('notification_category_id');
    if (catId != null && categories.isNotEmpty) {
      selectedCategory.value = categories.firstWhereOrNull((c) => c.id == catId);
    }
  }

  Future<void> _loadCategories() async {
    CategoriesController catController;
    if (Get.isRegistered<CategoriesController>()) {
      catController = Get.find<CategoriesController>();
    } else {
      catController = Get.put(CategoriesController());
    }
    
    // Always try to load if empty
    if (catController.categories.isEmpty) {
      await catController.loadCategories();
    }
    
    // Sync data
    categories.assignAll(catController.categories);
    
    // Listen for future updates
    ever(catController.categories, (List<Category> cats) {
      categories.assignAll(cats);
    });
    
    // Re-check selected category match
    final String? catId = _storageService.read('notification_category_id');
    if (catId != null) {
      selectedCategory.value = categories.firstWhereOrNull((c) => c.id == catId);
    }
  }

  Future<void> toggleDailyReminder(bool val) async {
    dailyReminderEnabled.value = val;
    if (val) {
      await _notificationService.requestPermissions();
    }
  }

  void updateTime(TimeOfDay time) {
    selectedTime.value = time;
  }

  void toggleWeekday(int day) {
    if (selectedWeekdays.contains(day)) {
      if (selectedWeekdays.length > 1) {
        selectedWeekdays.remove(day);
      }
    } else {
      selectedWeekdays.add(day);
    }
  }

  void setCategory(Category? category) {
    selectedCategory.value = category;
  }

  Future<void> saveSettings() async {
    // Save to valid storage
    await _storageService.write('notification_enabled', dailyReminderEnabled.value);
    await _storageService.write('notification_hour', selectedTime.value.hour);
    await _storageService.write('notification_minute', selectedTime.value.minute);
    await _storageService.write('notification_weekdays', selectedWeekdays.toList());
    await _storageService.write('milestone_alerts', milestoneAlerts.value);
    await _storageService.write('weekly_recap', weeklyRecap.value);
    
    if (selectedCategory.value != null) {
      await _storageService.write('notification_category_id', selectedCategory.value!.id);
    } else {
      await _storageService.write('notification_category_id', '');
    }

    // Schedule or Cancel
    if (dailyReminderEnabled.value) {
      Get.snackbar("Updating...", "Scheduling notifications, please wait...", 
        snackPosition: SnackPosition.BOTTOM, showProgressIndicator: true, duration: const Duration(seconds: 2));
      
      await _notificationService.requestPermissions();
      
      // Check for exact alarm permission
      final canScheduleExact = await _notificationService.canScheduleExactAlarms();
      
      if (!canScheduleExact) {
        // Show dialog explaining the need for exact alarm permission
        final shouldRequest = await Get.dialog<bool>(
          AlertDialog(
            title: const Text('Exact Alarm Permission Required'),
            content: const Text(
              'To deliver your daily quotes at the exact time you choose, this app needs permission to schedule exact alarms.\n\n'
              'You will be taken to system settings to grant this permission.',
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('Skip'),
              ),
              ElevatedButton(
                onPressed: () => Get.back(result: true),
                child: const Text('Grant Permission'),
              ),
            ],
          ),
        );
        
        if (shouldRequest == true) {
          final granted = await _notificationService.requestExactAlarmPermission();
          
          if (!granted) {
            Get.snackbar(
              "Limited Precision", 
              "Notifications will be delivered with approximate timing",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.orange.withOpacity(0.1),
              colorText: Colors.orange,
              duration: const Duration(seconds: 4),
            );
          }
        }
      }
      
      // Cancel previous
      await _notificationService.cancelWeekdayNotifications(100);

      // Fetch quotes
      // Use category ID if selected
      final QuoteRepository quoteRepo = QuoteRepository();
      List<dynamic> quotes = [];
      try {
         quotes = await quoteRepo.getQuotes(categoryId: selectedCategory.value?.id);
         if (quotes.isNotEmpty) {
           quotes.shuffle();
         }
      } catch (e) {
        print("Error fetching quotes for notification: $e");
      }
      
      int quoteIndex = 0;
      for (int day in selectedWeekdays) {
        String body = "Your daily dose of inspiration is ready!";
        String title = "Daily Inspiration";
        
        if (quotes.isNotEmpty) {
           body = "\"${quotes[quoteIndex % quotes.length].text}\"";
           title = "- ${quotes[quoteIndex % quotes.length].author}";
           quoteIndex++;
        } else if (selectedCategory.value != null) {
           body = "Your daily ${selectedCategory.value!.name} quote is ready!";
        }

        // Schedule for this specific day
        // ID: 100 + day
        await _notificationService.scheduleWeekly(
          100 + day, 
          title,
          body,
          selectedTime.value,
          day, 
        );
      }
      
      Get.snackbar("Success", "Notifications scheduled!", 
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    } else {
      await _notificationService.cancelWeekdayNotifications(100);
      Get.snackbar("Updated", "Notifications disabled", snackPosition: SnackPosition.BOTTOM);
    }
  }
}
