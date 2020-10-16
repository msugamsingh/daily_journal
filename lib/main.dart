import 'package:dailyjournal/models/note.dart';
import 'package:dailyjournal/models/task.dart';
import 'package:dailyjournal/pages/about.dart';
import 'package:dailyjournal/pages/add_note.dart';
import 'package:dailyjournal/pages/add_task.dart';
import 'package:dailyjournal/pages/edit_note.dart';
import 'package:dailyjournal/pages/home.dart';
import 'package:dailyjournal/pages/settings.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xFF292D3D),
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  final appDoc = await getApplicationDocumentsDirectory();
  Hive.init(appDoc.path);
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(TaskAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: Brightness.dark,
      data: (brightness) {
        bool b = brightness == Brightness.light;
        if (!b) {
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarColor: Color(0xFF292D3D),
            systemNavigationBarColor: Color(0xFF292D3D),
            systemNavigationBarIconBrightness: Brightness.light,
          ));
        } else {
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark,
          ));
        }
        TextStyle tClr = TextStyle(
            color: b ? Colors.blueGrey[700] : Colors.grey[50],
            fontWeight: FontWeight.w300);
        return ThemeData(
          brightness: brightness,
          scaffoldBackgroundColor: b ? Colors.white : Color(0xFF292D3D),
          accentColor: Color(0xffff758c),
          textTheme: TextTheme(
              bodyText2: tClr,
              bodyText1: tClr,
              headline6: tClr,
              headline1: tClr,
              headline3: tClr,
              headline4: tClr,
              headline5: tClr,
              subtitle2: tClr,
              subtitle1: tClr,
              headline2: tClr,
              caption: tClr),
          appBarTheme: AppBarTheme(
              brightness: b ? Brightness.light : Brightness.dark,
              color: b ? Colors.white : Color(0xFF292D3D),
              elevation: 0,
              textTheme: TextTheme(
                headline6: TextStyle(
                  color: Color(0xffff758c),
                  fontFamily: 'lob',
                  fontSize: 24,
                ),
              )
//              actionsIconTheme: IconThemeData(color: Colors.blueAccent)
              ),
          primaryColor: b ? Colors.white : Color(0xFF292D3D),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        );
      },
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          title: 'Daily Journal',
          theme: theme,
          debugShowCheckedModeBanner: false,
          initialRoute: Home.id,
          routes: {
            Home.id: (context) => Home(),
            About.id: (context) => About(),
            Settings.id: (context) => Settings(),
            AddNote.id: (context) => AddNote(),
            AddTask.id: (context) => AddTask(),
            EditNote.id: (context) => EditNote(),
          },
        );
      },
    );
  }
}
