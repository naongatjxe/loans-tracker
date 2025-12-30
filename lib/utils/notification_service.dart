import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;
import '../models/person.dart' as model;

const String _kNotificationsEnabledKey = 'notifications_enabled';
const String _kNotificationHourKey = 'notification_hour';
const String _kNotificationMinuteKey = 'notification_minute';
const String _kNotificationOneDayKey = 'notification_one_day_before';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  bool _enabled = true;

  int _hour = 9;
  int _minute = 0;
  bool _oneDayBefore = true;

  Future<void> init() async {
    if (kIsWeb) return; // no-op on web

    // Load preference
    try {
      final prefs = await SharedPreferences.getInstance();
      _enabled = prefs.getBool(_kNotificationsEnabledKey) ?? true;
      _hour = prefs.getInt(_kNotificationHourKey) ?? 9;
      _minute = prefs.getInt(_kNotificationMinuteKey) ?? 0;
      _oneDayBefore = prefs.getBool(_kNotificationOneDayKey) ?? true;
    } catch (_) {
      _enabled = true;
      _hour = 9;
      _minute = 0;
      _oneDayBefore = true;
    }

    // Initialize timezone database (we'll schedule using UTC-based zonedSchedule to avoid needing flutter_native_timezone)
    tzdata.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final settings = InitializationSettings(android: android, iOS: ios);

    await _plugin.initialize(settings,
        onDidReceiveNotificationResponse: (response) {
      // Optionally handle notification tapped action here
    });

    // Request platform permissions where required (Android 13+, iOS)
    try {
      // Android 13+ permission is handled by the system/plugin if supported.
      // Some plugin versions expose requestPermission on Android; to keep compatibility
      // across versions we avoid calling an Android request API directly here.

      final iosImpl = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      await iosImpl?.requestPermissions(alert: true, badge: true, sound: true);
    } catch (_) {}

  }

  int _idFromString(String s, {int offset = 0}) {
    final v = s.hashCode & 0x7fffffff;
    return v ^ offset;
  }

  Future<void> scheduleLoanNotifications(model.Person loan) async {
    if (kIsWeb) return;

    // Respect user preference
    if (!_enabled) return;

    // cancel any previous notifications for this loan
    await cancelLoanNotifications(loan.id);

    if (loan.isPaid) return; // no notifications for paid loans

    // Use UTC-based TZ scheduling: convert local target times to UTC instants
    final localNow = DateTime.now();

    // Use configured notification time (hour/minute) when scheduling
    final dueLocal = DateTime(loan.dueDate.year, loan.dueDate.month, loan.dueDate.day, _hour, _minute);
    final beforeLocal = dueLocal.subtract(const Duration(days: 1));

    final dueUtc = tz.TZDateTime.from(dueLocal.toUtc(), tz.UTC);
    final beforeUtc = tz.TZDateTime.from(beforeLocal.toUtc(), tz.UTC);

    final formatter = DateFormat('yyyy-MM-dd');
    final currency = NumberFormat.currency(symbol: 'K ');

    // Build messages
    final dueAmount = loan.calculateAmountDue(loan.dueDate);

    final titleBefore = 'Loan due tomorrow';
    final bodyBefore = '${loan.name} — ${currency.format(dueAmount)} due on ${formatter.format(loan.dueDate)}.';

    final titleDue = 'Loan due today';
    final bodyDue = '${loan.name} — ${currency.format(dueAmount)} due today (${formatter.format(loan.dueDate)}).';

    final androidDetails = AndroidNotificationDetails(
      'loan_due_channel',
      'Loan Due Alerts',
      channelDescription: 'Notifications for upcoming loans and due dates',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      icon: '@drawable/ic_notification',
    );

    final iosDetails = DarwinNotificationDetails();

    final details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    // Schedule "one day before" notification if in the future
    if (_oneDayBefore) {
      if (beforeLocal.isAfter(localNow)) {
        await _plugin.zonedSchedule(
          _idFromString(loan.id, offset: 1),
          titleBefore,
          bodyBefore,
          beforeUtc,
          details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      } else if (dueLocal.isAfter(localNow) && beforeLocal.isBefore(localNow)) {
        // If "one day before" has already passed but due is still in future, show immediate brief reminder
        await _plugin.show(
          _idFromString(loan.id, offset: 1),
          titleBefore,
          bodyBefore,
          details,
        );
      }
    }
    // Schedule "due date" notification if in the future
    if (dueLocal.isAfter(localNow)) {
      await _plugin.zonedSchedule(
        _idFromString(loan.id),
        titleDue,
        bodyDue,
        dueUtc,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } else if (dueLocal.isBefore(localNow) && !loan.isPaid) {
      // If due date is today/past and unpaid, show an immediate notification
      await _plugin.show(
        _idFromString(loan.id),
        titleDue,
        bodyDue,
        details,
      );
    }
  }

  Future<void> cancelLoanNotifications(String loanId) async {
    if (kIsWeb) return;
    try {
      await _plugin.cancel(_idFromString(loanId));
      await _plugin.cancel(_idFromString(loanId, offset: 1));
    } catch (_) {}
  }

  /// Returns whether notifications are enabled.
  bool get enabled => _enabled;

  /// Set and persist notification enabled state.
  Future<void> setEnabled(bool enabled) async {
    _enabled = enabled;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kNotificationsEnabledKey, enabled);
    } catch (_) {}
  }

  int get hour => _hour;
  int get minute => _minute;
  bool get oneDayBefore => _oneDayBefore;

  Future<void> setNotificationTime(int hour, int minute) async {
    _hour = hour;
    _minute = minute;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_kNotificationHourKey, hour);
      await prefs.setInt(_kNotificationMinuteKey, minute);
    } catch (_) {}
  }

  Future<void> setOneDayBefore(bool enabled) async {
    _oneDayBefore = enabled;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kNotificationOneDayKey, enabled);
    } catch (_) {}
  }

  /// Shows a test notification immediately (useful for debugging and permission checks)
  Future<void> showTestNotification({String? title, String? body}) async {
    if (kIsWeb) return;

    final androidDetails = AndroidNotificationDetails(
      'loan_due_channel',
      'Loan Due Alerts',
      channelDescription: 'Notifications for upcoming loans and due dates',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      icon: '@drawable/ic_notification',
    );

    final iosDetails = DarwinNotificationDetails();

    final details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _plugin.show(
      0,
      title ?? 'Test Notification',
      body ?? 'This is a test notification from Loan Tracker',
      details,
    );
  }
}


