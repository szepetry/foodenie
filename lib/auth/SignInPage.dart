import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodenie/auth/Auth.dart';
import 'package:foodenie/initFoods.dart';
import 'package:foodenie/reccommender.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class SignInPage extends StatefulWidget {
  SignInPage();
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool signInStart = false;
  var foodIds;
  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();

/*     FlutterDownloader.initialize().then((value) {
      FlutterDownloader.registerCallback(downloadCallback);
    });
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      if (status == DownloadTaskStatus.complete) {
        final directory = getApplicationDocumentsDirectory().then((value) {
          File f = File(value.path + '/foodeine_tflite_model.tflite');
        });
      } else {}
    }); */
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment
              .bottomRight, // 10% of the width, so there are ten blinds.
          colors: [Colors.lightBlue[500], Colors.blue[900]], // red to yellow
          tileMode: TileMode.repeated, // repeats the gradient over the canvas
        ),
      ),
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(),
            Container(
              child: Column(
                children: [
                  Text(
                    'Welcome to',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        textBaseline: TextBaseline.alphabetic),
                  ),
                  Text(
                    'Foodenie',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Column(
                children: [
                  !signInStart
                      ? Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: OutlinedButton(
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                side: MaterialStateProperty.all<BorderSide>(
                                    BorderSide(color: Colors.white))),
                            onPressed: () async {
                              //await getRequest('recommend?foodId=60');
                              setState(() {
                                signInStart = true;
                              });
                              Map<String, dynamic> cred;
                              try {
                                cred = await Auth.signInWithGoogle();
                                User user = cred['cred'].user;
                                String uid = user.uid;
                                if (uid.length > 0) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => InitFoods()));
                                  AppUser appUser = AppUser(user.displayName,
                                      user.phoneNumber, user.email);
                                  token = cred['token'];
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((timeStamp) {
                                    setState(() {
                                      signInStart = false;
                                    });
                                  });
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(uid)
                                      .set(
                                        appUser.userDetails,
                                        SetOptions(merge: true),
                                      );
                                }
                              } catch (e) {
                                print(e);
                                if (cred == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Authentication failed'),
                                    ),
                                  );
                                }

                                WidgetsBinding.instance
                                    .addPostFrameCallback((timeStamp) {
                                  setState(() {
                                    signInStart = false;
                                  });
                                });
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'assets/images/google.png',
                                  width: 20,
                                  height: 20,
                                ),
                                Text('Sign in with Google'),
                              ],
                            ),
                          ),
                        )
                      : Center(child: CircularProgressIndicator()),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
