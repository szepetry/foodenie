import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodenie/HomePage.dart';
import 'package:foodenie/initFoods.dart';
import 'package:foodenie/pages/firstpage.dart';
import 'auth/Auth.dart';
import 'reccommender.dart';

class InitPage extends StatefulWidget {
  Auth auth;
  InitPage(this.auth);

  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  List<Widget> pages = <Widget>[];
  bool isLoading = true;
  @override
  void initState() {
    if (!isLoading)
      setState(() {
        isLoading = true;
      });
    FirebaseFirestore.instance
        .collection('users')
        .doc(fbUid)
        .get()
        .then((value) {
      var user = value.data();
      Widget w0 = HomePage(widget.auth);
      if (user['isSetupDone']) {
        pages.add(w0);
      } else {
        Widget w1 = FirstPage();

        Widget w3 = InitFoods();
      }
    });
    setState(() {
      isLoading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PageView.builder(
          itemCount: pages.length,
          itemBuilder: (BuildContext context, int idx) {
            return pages[idx];
          }),
    );
  }
}
