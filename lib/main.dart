import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodenie/auth/LandingPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Alata'),
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
