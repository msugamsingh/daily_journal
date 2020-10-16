import 'dart:math';

import 'package:dailyjournal/models/note.dart';
import 'package:dailyjournal/models/task.dart';
import 'package:dailyjournal/pages/about.dart';
import 'package:dailyjournal/pages/add_note.dart';
import 'package:dailyjournal/pages/add_task.dart';
import 'package:dailyjournal/utils/constants.dart';
import 'package:dailyjournal/pages/home_screen.dart';
import 'package:dailyjournal/pages/settings.dart';
import 'package:dailyjournal/pages/task_screen.dart';
import 'package:dailyjournal/utils/gradient_colors.dart';
import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:koukicons/takeNote2.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  static const String id = 'home';

  @override
  _HomeState createState() => _HomeState();
}

// IndexedStack, AnimatedPositioned
class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int text = 1;
  int weekDay = 0;
  int ind = 0;
  FancyDrawerController _controller;
  int randomInt = 1;
  FlutterLocalNotificationsPlugin notificationsPlugin;

  @override
  void initState() {
    super.initState();
    final date = DateTime.now();
    weekDay = date.weekday;
    _controller = FancyDrawerController(
        vsync: this, duration: Duration(milliseconds: 200))
      ..addListener(() {
        setState(() {});
      });
    var androidInit = AndroidInitializationSettings('app_icon');
    var iosInit = IOSInitializationSettings();
    notificationsPlugin = FlutterLocalNotificationsPlugin();
    notificationsPlugin.initialize(InitializationSettings(androidInit, iosInit),
        onSelectNotification: notificationSelected);
    randomInt = Random().nextInt(9);
    showNotification();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future notificationSelected(String payLoad) async {
    Navigator.pushNamed(context, AddNote.id);
  }

  Future showNotification() async {
    await notificationsPlugin.cancelAll();
    Box box = await Hive.openBox('time');
    var androidDet = AndroidNotificationDetails(
        'mainNote', 'Daily Journal', 'How was the day');
    var generalDet = NotificationDetails(androidDet, IOSNotificationDetails());
    DateTime dateTime = box.get(
        'dateTime', defaultValue: DateTime(0, 0, 0, 19, 0));
    Time time = Time(dateTime.hour, dateTime.minute, 0);
    await notificationsPlugin.showDailyAtTime(
        0, 'Daily Journal', 'How was the day?', time, generalDet);
  }

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      child: AlertDialog(
        backgroundColor: Theme
            .of(context)
            .scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: Text(
          'Do you want to exit?',
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text(
              'No',
            ),
          ),
          FlatButton(
            onPressed: () {
              SystemNavigator.pop(animated: true);
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  launchUrl(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'could not open';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Material(
        child: GestureDetector(
          onPanUpdate: (details) {
            if (details.delta.dx > 0) {
              if (ind != 0)
                setState(() {
                  ind = 0;
                });
            } else if (details.delta.dx < 0) {
              if (ind != 1)
                setState(() {
                  ind = 1;
                });
            }
          },
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors:
                      GradientTemplate.gradientTemplate[randomInt].colors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                ),
              ),
              // Positioned(top: 200, left: 50, child: KoukiconsTakeNote2()),
              FancyDrawerWrapper(
                hideOnContentTap: true,
                backgroundColor: Colors.transparent,
                cornerRadius: 24,
                drawerItems: <Widget>[
                  KoukiconsTakeNote2(),
                  DrawerOption(
                    title: 'Settings',
                    onTap: () {
                      Navigator.pushNamed(context, Settings.id);
                      _controller.close();
                    },
                  ),
                  DrawerOption(
                    title: 'About',
                    onTap: () {
                      Navigator.pushNamed(context, About.id);

                      _controller.close();
                    },
                  ),
                  DrawerOption(
                    title: 'More Apps',
                    onTap: () {
                      launchUrl(
                          'https://play.google.com/store/search?q=pub%3AForol&c=apps&hl=en');
                      _controller.close();
                    },
                  ),
                ],
                controller: _controller,
                child: Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                      icon: Icon(CustomIcons.menu),
                      onPressed: () {
                        if (_controller.state == DrawerState.closed) {
                          _controller.open();
                        } else
                          _controller.close();
                      },
                    ),
                    title: Row(
                      textBaseline: TextBaseline.alphabetic,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            setState(() => ind = 0);
                          },
                          child: Opacity(
                              opacity: ind == 0 ? 1 : 0.5,
                              child: Text(
                                'Notes',
                                style: TextStyle(
                                  fontSize: ind == 0 ? 24 : 18,
                                ),
                              )),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() => ind = 1);
                          },
                          child: Opacity(
                              opacity: ind == 1 ? 1 : 0.5,
                              child: Text(
                                'Tasks',
                                style: TextStyle(
                                  fontSize: ind == 1 ? 24 : 18,
                                ),
                              )),
                        ),
                      ],
                    ),
                    centerTitle: true,
                  ),
                  floatingActionButton: RotationTransition(
                    turns: AlwaysStoppedAnimation(45 / 360),
                    child: FloatingActionButton(
                      child: Icon(Icons.clear),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      onPressed: () {
                        if (ind == 0)
                          Navigator.pushNamed(context, AddNote.id);
                        else
                          Navigator.pushNamed(context, AddTask.id);
                      },
                    ),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IndexedStack(
                      index: ind,
                      children: <Widget>[
                        FutureBuilder(
                            future: Hive.openBox<Note>('notes'),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasError)
                                  return Text(snapshot.error.toString());
                                else
                                  return HomeScreen();
                              } else
                                return Container();
                            }),
                        FutureBuilder(
                            future: Hive.openBox<Task>('tasks'),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasError)
                                  return Text(snapshot.error.toString());
                                else
                                  return TaskScreen();
                              } else
                                return Container();
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerOption extends StatelessWidget {
  final String title;
  final Function onTap;

  const DrawerOption({Key key, this.title, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'pac',
          fontSize: 16,
          shadows: [
            Shadow(color: Colors.grey, blurRadius: 4),
          ],
          color: Colors.white,
          fontWeight: FontWeight.w100,
        ),
      ),
      onTap: onTap,
    );
  }
}
