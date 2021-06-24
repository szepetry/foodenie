import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodenie/auth/LandingPage.dart';

void main() {
  // Status bar color
//   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//   statusBarColor: Colors.lime
// ));
  runApp(MyApp());
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
