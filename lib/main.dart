import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import 'models/project.dart';
import 'models/user.dart';
import 'screens/auth_screen.dart';
import 'services/database.dart';

Map<int, Color> color = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() {
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid =
      new AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = IOSInitializationSettings();
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Color(0XFF1E1E41), //top bar color
      statusBarIconBrightness: Brightness.dark, //top bar icons
    ),
  );
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Database db = Database();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FlutterLocalNotificationsPlugin>.value(
            value: flutterLocalNotificationsPlugin),
        StreamProvider<List<Project>>.value(
          value: db.getProjectsStream(),
        ),
        StreamProvider<User>.value(
          value: db.getUser(),
        ),
      ],
      child: MaterialApp(
        title: 'Task Manager',
        theme: ThemeData(
//          primarySwatch: MaterialColor(0xFF135058, color),
          primarySwatch: Colors.blueGrey,
          canvasColor: Colors.transparent,
          scaffoldBackgroundColor: Colors.transparent,
          appBarTheme: AppBarTheme(
            color: Colors.transparent,
            textTheme: TextTheme(
              title: TextStyle(color: Colors.black, fontSize: 16),
            ),
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
          ),
          fontFamily: 'Titillium',
          textTheme: TextTheme(
            title: TextStyle(
              fontSize: 32.0,
            ),
            subtitle: TextStyle(
              fontSize: 24.0,
            ),
            body1: TextStyle(
              fontSize: 18.0,
            ),
            body2: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
        home: AuthScreen(),
      ),
    );
  }
}
