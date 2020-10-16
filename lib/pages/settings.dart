import 'package:dailyjournal/pages/add_note.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:hive/hive.dart';

class Settings extends StatefulWidget {
  static const String id = 'settings';

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  DateTime dateTime;
  FlutterLocalNotificationsPlugin notificationsPlugin;

  Future openBox() async {
    await Hive.openBox('time');
    dateTime = Hive.box('time')
        .get('dateTime', defaultValue: DateTime(0, 0, 0, 19, 0));
  }

  updateDateTime() async {
    Hive.box('time').put('dateTime', dateTime);
  }

  @override
  void initState() {
    super.initState();
    openBox();

    var androidInit = AndroidInitializationSettings('app_icon');
    var iosInit = IOSInitializationSettings();
    notificationsPlugin = FlutterLocalNotificationsPlugin();
    notificationsPlugin.initialize(InitializationSettings(androidInit, iosInit),
        onSelectNotification: notificationSelected);
    // showNotification();
  }

  Future notificationSelected(String payLoad) async {
    Navigator.pushNamed(context, AddNote.id); //TODO
  }

  Future showNotification() async {
    await notificationsPlugin.cancelAll();
    var androidDet = AndroidNotificationDetails(
        'tempNote', 'Daily Journal', 'How was the day');
    var generalDet = NotificationDetails(androidDet, IOSNotificationDetails());

    Time time = Time(dateTime.hour, dateTime.minute, 0);
    await notificationsPlugin.showDailyAtTime(
        1, 'Daily Journal', 'How was the day?', time, generalDet);
  }

  @override
  void dispose() {
    if (Hive.box('time')
            .get('dateTime', defaultValue: DateTime(0, 0, 0, 19, 0)) !=
        dateTime) {
      updateDateTime();
      showNotification();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = Theme.of(context).brightness;
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SwitchListTile(
            activeColor: Theme.of(context).accentColor,
            title: Text('Dark Mode'),
            value: brightness == Brightness.dark,
            onChanged: (bool val) {
              DynamicTheme.of(context).setBrightness(
                brightness == Brightness.light
                    ? Brightness.dark
                    : Brightness.light,
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              'Remind me daily at:',
              style: TextStyle(fontSize: 16),
            ),
          ),
          TimePickerSpinner(
            highlightedTextStyle:
                TextStyle(color: Theme.of(context).accentColor, fontSize: 40),
            isForce2Digits: true,
            time: Hive.box('time')
                .get('dateTime', defaultValue: DateTime(0, 0, 0, 19, 0)),
            onTimeChange: (time) {
              setState(() {
                dateTime = time;
              });
            },
          ),
        ],
      ),
    );
  }
}
