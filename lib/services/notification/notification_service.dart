import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:assets_audio_player/assets_audio_player.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings settings = InitializationSettings(android: androidInit);

    await _plugin.initialize(settings);
  }

  static Future<void> scheduleOutfitReminder(DateTime date, String title) async {
    final scheduleTime = DateTime(date.year, date.month, date.day, 9); // 9:00 AM

    if (scheduleTime.isAfter(DateTime.now())) {
      const androidDetails = AndroidNotificationDetails(
        'outfit_channel',
        'Outfit Reminders',
        channelDescription: 'Reminders to wear your scheduled outfit',
        importance: Importance.max,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound('notification_sound'),
      );

      await _plugin.zonedSchedule(
        date.day,
        'OOTD Reminder',
        'Outfit for ${date.toLocal().toIso8601String().split("T")[0]}: $title',
        tz.TZDateTime.from(scheduleTime, tz.local),
        NotificationDetails(android: androidDetails),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      _playSound();
    }
  }

  static void _playSound() {
    final player = AssetsAudioPlayer();
    player.open(
      Audio('assets/sounds/reminder.mp3'),
      autoStart: true,
      showNotification: false,
    );
  }
}
