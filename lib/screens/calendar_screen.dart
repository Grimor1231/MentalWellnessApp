import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List> _events = {};
  int _notificationId = 0;  // used to give each notification a unique id
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: selectNotification);
  }

  Future selectNotification(String? payload) async {
    // Handle notification tap
    if (payload != null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Notification Payload'),
          content: Text('Payload: $payload'),
        ),
      );
    }
  }

  void _addEvent(String event, DateTime date) {
    if (_events[date] != null) {
      _events[date]!.add(event);
    } else {
      _events[date] = [event];
    }
  }

  void _setReminder(String event, DateTime date) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'calendar_reminder_notifs', 'Calendar Notifications', 'This channel is for calendar reminder notifications',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        _notificationId++,
        'Reminder',
        event,
        date,
        platformChannelSpecifics);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Calendar'),
        ),
        body: TableCalendar(
        firstDay: DateTime.utc(2010, 10, 16),
    lastDay: DateTime.utc(2030, 3, 14),
    focusedDay: _focusedDay,
    calendarFormat: _calendarFormat,
    selectedDayPredicate: (day) {
    return isSameDay(_selectedDay, day);
    },
    onDaySelected: (selectedDay, focusedDay) {
    setState(() {
    _selectedDay = selectedDay;

    _focusedDay = focusedDay; // update `_focusedDay` here as well
    });
    _showAddDialog();
    },
          eventLoader: (day) {
            return _events[day] ?? [];
          },
          calendarStyle: CalendarStyle(
            // Use `CalendarStyle` to customize the UI
            selectedDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
        ),
    );
  }

  _showAddDialog() async {
    TextEditingController _eventController = TextEditingController();
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: TextField(
            controller: _eventController,
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Save"),
              onPressed: () {
                if (_eventController.text.isEmpty) return;
                if (_selectedDay != null) {
                  setState(() {
                    _addEvent(_eventController.text, _selectedDay!);
                    _setReminder(_eventController.text, _selectedDay!.add(Duration(hours: 9))); // set a reminder for 9AM on the selected day
                  });
                }
                Navigator.pop(context);
              },
            )
          ],
        ));
  }
}
