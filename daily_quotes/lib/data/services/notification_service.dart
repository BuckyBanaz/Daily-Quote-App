import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class NotificationService extends GetxService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<NotificationService> init() async {
    tz_data.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        debugPrint('Notification tapped: ${details.payload}');
      },
    );

    return this;
  }

  Future<void> requestPermissions() async {
    if (GetPlatform.isAndroid) {
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    } else if (GetPlatform.isIOS) {
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  /// Check if exact alarms can be scheduled (Android 12+)
  Future<bool> canScheduleExactAlarms() async {
    if (GetPlatform.isAndroid) {
      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      
      if (androidPlugin != null) {
        try {
          return await androidPlugin.canScheduleExactNotifications() ?? false;
        } catch (e) {
          debugPrint('Error checking exact alarm permission: $e');
          return false;
        }
      }
    }
    return true; // iOS doesn't have this restriction
  }

  /// Request exact alarm permission (Android 12+)
  Future<bool> requestExactAlarmPermission() async {
    if (GetPlatform.isAndroid) {
      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      
      if (androidPlugin != null) {
        try {
          final canSchedule = await androidPlugin.canScheduleExactNotifications() ?? false;
          
          if (!canSchedule) {
            // Request the permission by opening system settings
            await androidPlugin.requestExactAlarmsPermission();
            
            // Check again after user returns from settings
            return await androidPlugin.canScheduleExactNotifications() ?? false;
          }
          
          return canSchedule;
        } catch (e) {
          debugPrint('Error requesting exact alarm permission: $e');
          return false;
        }
      }
    }
    return true;
  }

  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
    required List<int> weekdays, // 1 = Monday, 7 = Sunday
  }) async {
    await cancelNotification(id);

    for (int day in weekdays) {
      await scheduleWeekly(id + day, title, body, time, day);
    }
  }
  
  Future<void> scheduleWeekly(int id, String title, String body, TimeOfDay time, int weekday) async {
     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
     
     // Calculate the next occurrence of this weekday at 'time'
     tz.TZDateTime scheduledDate = tz.TZDateTime(
       tz.local,
       now.year,
       now.month,
       now.day,
       time.hour,
       time.minute,
     );

     // Adjust to the specific weekday
     while (scheduledDate.weekday != weekday) {
       scheduledDate = scheduledDate.add(const Duration(days: 1));
     }

     // If the scheduled time is in the past, move to next week
     if (scheduledDate.isBefore(now)) {
       scheduledDate = scheduledDate.add(const Duration(days: 7));
     }

     // Check if we can schedule exact alarms
     final canScheduleExact = await canScheduleExactAlarms();
     
     // Use appropriate scheduling mode based on permission
     final scheduleMode = canScheduleExact 
         ? AndroidScheduleMode.exactAllowWhileIdle 
         : AndroidScheduleMode.inexactAllowWhileIdle;

     try {
       await _notificationsPlugin.zonedSchedule(
         id,
         title,
         body,
         scheduledDate,
         const NotificationDetails(
           android: AndroidNotificationDetails(
             'daily_quotes_channel',
             'Daily Quotes',
             channelDescription: 'Daily alerts for your favorite quotes',
             importance: Importance.max,
             priority: Priority.high,
           ),
           iOS: DarwinNotificationDetails(),
         ),
         androidScheduleMode: scheduleMode,
       );
       
       if (!canScheduleExact) {
         debugPrint('⚠️ Scheduled notification with inexact timing (exact alarms not permitted)');
       }
     } catch (e) {
       debugPrint('❌ Error scheduling notification: $e');
       rethrow;
     }
   }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }
  
  // Helper to cancel a group of weekday notifications (e.g. ID range)
  Future<void> cancelWeekdayNotifications(int baseId) async {
    for (int i = 1; i <= 7; i++) {
      await _notificationsPlugin.cancel(baseId + i);
    }
  }
}
