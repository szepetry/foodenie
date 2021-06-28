import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodenie/auth/LandingPage.dart';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// void printHello() {
//   final DateTime now = DateTime.now();
//   final int isolateId = Isolate.current.hashCode;
//   print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
// }

void main() async {
  // Status bar color
//   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//   statusBarColor: Colors.lime
// ));
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  runApp(MyApp());
  // await AndroidAlarmManager.periodic(Duration(minutes: 1), 1, printHello,startAt: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,13,45));
  // await AndroidAlarmManager.periodic(Duration(seconds: 15), 2, printHello,startAt: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,13,45));
  // await AndroidAlarmManager.cancel(1);
  // await AndroidAlarmManager.cancel(2);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.purple,
          // primaryColor: Colors.purple[900],
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Alata',
          timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.lime[50],
              // hourMinuteTextColor: Colors.purple[900]
              dayPeriodTextColor: Colors.purple[900],
              dialHandColor: Colors.purple[900])),
      home: Scaffold(
        body: FutureBuilder<FirebaseApp>(
            future: Firebase.initializeApp(),
            builder: (context, snapshot) {
              if (snapshot.hasData) return LandingPage();
              return Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}
