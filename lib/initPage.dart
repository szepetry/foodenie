import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodenie/HomePage.dart';
import 'package:foodenie/initFoods.dart';
import 'package:foodenie/pages/firstpage.dart';
import 'package:foodenie/pages/loading.dart';
import 'package:foodenie/pages/meal_timings.dart';
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
  int currentPage = 0;
  bool isLoading = true;
  PageController ipController = PageController(initialPage: 0);
  @override
  void initState() {
    /* FirebaseFirestore.instance.collection('users').get().then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(element.id)
            .update({'prefs': []}).then((value) => null);
      });
    }); */
    if (!isLoading)
      setState(() {
        isLoading = true;
      });

    user.doc(widget.auth.uid).get().then((value) async {
      userObj = value.data();
      userObj['liked'].forEach((ref) async {
        DocumentReference r = ref;
        var item = await r.get();
        likedItems.add(item);
      });

      dislikedItems = userObj['disLiked'].map((o) => o).toList();
      var fdDocs = await foodItems.orderBy('rank', descending: true).get();
      allFoodsList = fdDocs.docs.map((e) => e.data()).toList();
      /* List<String> temp = [];
      allFoodsList.forEach((element) {
        if (!temp.contains(element['course'])) {
          temp.add(element['course']);
        }
      });
      temp.forEach((element) {
        print(element);
      }); */
      Widget w0 = HomePage(widget.auth);
      if (userObj['isSetupDone'] != true) {
        Widget w1 = LoadingPage(scrollNext);
        Widget w2 = MealTimings(scrollNext);
        Widget w3 = InitFoods(scrollNext);
        pages.addAll([w1, w2, w3, w0]);
      } else {
        pages.add(w0);
      }

      setState(() {
        isLoading = false;
      });
    });
    /* ipController.addListener(() {
      setState(() {
        currentPage = ipController.page;
      });
    }); */
    /*  Timer.periodic(Duration(seconds: 2), (Timer timer) {
      currentPage++;
      ipController.animateToPage(currentPage.toInt(),
          duration: Duration(seconds: 1), curve: Curves.easeIn);
    }); */
    super.initState();
  }

  @override
  void dispose() {
    ipController.dispose();
    super.dispose();
  }

  Future<void> scrollNext() async {
    currentPage += 1;
    await ipController.animateToPage(currentPage.toInt(),
        duration: Duration(seconds: 1), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : PageView.builder(
              scrollDirection: Axis.horizontal,
              controller: ipController,
              onPageChanged: (idx) {
                setState(() {
                  currentPage = idx;
                });
              },
              itemCount: pages.length,
              itemBuilder: (BuildContext context, int idx) {
                return pages[idx];
              }),
    );
  }
}
