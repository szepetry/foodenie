import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodenie/HomePage.dart';
import 'package:foodenie/auth/Auth.dart';
import 'package:foodenie/auth/SignInPage.dart';
import 'package:foodenie/initFoods.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String uid = snapshot.data.uid;
            Auth auth = Auth(uid);
            return HomePage(auth);
          }
          return SignInPage();
        });
  }
}
