import 'dart:isolate';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodenie/auth/Auth.dart';
import 'package:foodenie/reccommender.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatefulWidget {
  SignInPage();
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool signInStart = false;
  var foodIds;
  bool isLoading = true;
  ReceivePort _port = ReceivePort();
  SharedPreferences prefs;

  @override
  void initState() {
    if (!isLoading)
      setState(() {
        isLoading = true;
      });

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

  Future<bool> initUser(String uid, User fbUser) async {
    try {
      String fcmToken = await getFcmToken;
      print(fcmToken);
      AppUser appUser = AppUser(fbUser.displayName, fbUser.phoneNumber,
          fbUser.email, fcmToken.trim());
      await user.doc(uid).set(
            appUser.userDetails,
            SetOptions(merge: true),
          );
      print('a');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('fbUid', uid);
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error has occurred'),
        ),
      );
      Auth.signOut();
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          // gradient: LinearGradient(colors: [Colors.lime, Colors.lime[300]]),
          color: Colors.lime[100]),
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(),
            Image.asset("assets/logo/foodenieLogoWithoutCarpet.png"),
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
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.purple[900]),
                                side: MaterialStateProperty.all<BorderSide>(
                                    BorderSide(color: Colors.black))),
                            onPressed: () async {
                              //await getRequest('recommend?foodId=60');
                              setState(() {
                                signInStart = true;
                              });
                              Map<String, dynamic> cred;
                              try {
                                cred = await Auth.signInWithGoogle();
                                User fbUser = cred['cred'].user;
                                String uid = fbUser.uid;
                                print(uid);
                                if (uid.length > 0) {
                                  var userDoc =
                                      await user.doc(fbUser.uid).get();

                                  if (!userDoc.exists) {
                                    print(await initUser(uid, fbUser));
                                  }
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
                                setState(() {
                                  signInStart = false;
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
                                Text(
                                  'Sign in with Google',
                                  style: TextStyle(color: Colors.white),
                                ),
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
