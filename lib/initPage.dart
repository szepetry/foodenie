import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodenie/HomePage.dart';
import 'package:foodenie/initFoods.dart';
import 'package:foodenie/pages/firstpage.dart';
import 'package:foodenie/pages/loading.dart';
import 'package:foodenie/pages/meal_timings.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  bool isPageLoaded = false;
  set setPageLoaded(bool value) {
    setState(() {
      isPageLoaded = true;
    });
  }

  PageController ipController = PageController(initialPage: 0);
  Size get getScreenSize => MediaQuery.of(context).size;

  Future<bool> initializeFoodItems() async {
    try {
      DocumentSnapshot val = await user.doc(widget.auth.uid).get();
      userObj = val.data();
      var fdDocs = await foodItems.orderBy('rank', descending: true).get();
      allFoodsList = fdDocs.docs.map((e) => e.data()).toList();
      Widget w0 = HomePage(widget.auth);
      print(userObj);
      if (userObj['isSetupDone'] != true) {
        Widget w1 = LoadingPage(scrollNext);
        Widget w2 = MealTimings(scrollNext);
        Widget w3 = InitFoods(scrollNext);
        pages.addAll([w1, w2, w3, w0]);
      } else {
        pages.add(w0);
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
    /* await user.doc(widget.auth.uid).get().then((value) async {
      setState(() {
        userObj = value.data();
      });

      //
      await foodItems.orderBy('rank', descending: true).get().then((fdDocs) {
        setState(() {
          allFoodsList = fdDocs.docs.map((e) => e.data()).toList();
        });
      }).then((value) {
        Widget w0 = HomePage(widget.auth);
        if (userObj['isSetupDone'] != true) {
          Widget w1 = LoadingPage(scrollNext);
          Widget w2 = MealTimings(scrollNext);
          Widget w3 = InitFoods(scrollNext);
          pages.addAll([w1, w2, w3, w0]);
        } else {
          pages.add(w0);
        }
      });

      /* List<String> temp = [];
      allFoodsList.forEach((element) {
        if (!temp.contains(element['course'])) {
          temp.add(element['course']);
        }
      });
      temp.forEach((element) {
        print(element);
      }); */
    }); */
  }

  Widget reloadPage() {
    return Container(
      width: getScreenSize.width,
      height: getScreenSize.height,
      margin: EdgeInsets.only(
          bottom: getScreenSize.height * 0.07,
          right: getScreenSize.width * 0.0),
      child: GestureDetector(
        onTap: () async {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.refresh_rounded,
                color: Colors.green, size: getScreenSize.width * 0.5),
            Text(
              'Tap to refresh',
              style: TextStyle(fontSize: 20, color: Colors.green[900]),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> initialise() async {
    bool value = await Auth.googleAuthObj.isSignedIn();
    GoogleSignInAccount currentUser = Auth.googleAuthObj.currentUser;
    try {
      if (value) {
        GoogleSignInAuthentication data;
        if (currentUser != null) {
          data = await Auth.googleAuthObj.currentUser.authentication;
          token = data.idToken;
        } else {
          GoogleSignInAccount acc = await Auth.googleAuthObj.signInSilently();
          data = await acc.authentication;
          token = data.idToken;
        }
      } else {
        GoogleSignInAccount acc = await Auth.googleAuthObj.signInSilently();
        GoogleSignInAuthentication data =
            await Auth.googleAuthObj.currentUser.authentication;
        token = data.idToken;
      }
      bool res = await initializeFoodItems();
      if (res == false) throw new Error();
      return true;
    } catch (e) {
      print(e);
      return false;
    }

    /* await widget.data.authentication.then((value) async {
      token = value.idToken;
      await initializeFoodItems().then((value) {
        setState(() {
          isLoading = false;
        });
      }).catchError((onError) {
        setState(() {
          isLoading = false;
        });
        setPageLoaded = false;
      });
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      setPageLoaded = false;
    }); */
  }

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
    initialise().then((value) {
      if (value) {
        setPageLoaded = true;
      } else {
        setPageLoaded = false;
      }
      setState(() {
        isLoading = false;
      });
    });
    /* widget.data.authentication.then((value) async {
      token = value.idToken;
      await initializeFoodItems().then((value) {
        setState(() {
          isLoading = false;
        });
      });
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      setPageLoaded = false;
    }); */

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
    //Auth.signOut();
    return Container(
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : isPageLoaded
              ? PageView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: ipController,
                  physics: NeverScrollableScrollPhysics(),
                  onPageChanged: (idx) {
                    setState(() {
                      currentPage = idx;
                    });
                  },
                  itemCount: pages.length,
                  itemBuilder: (BuildContext context, int idx) {
                    return pages[idx];
                  })
              : reloadPage(),
    );
  }
}
