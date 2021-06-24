import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodenie/auth/Auth.dart';

class SignInPage extends StatefulWidget {
  SignInPage();
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool signInStart = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.lime[100]
      ),
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
                                        backgroundColor: MaterialStateProperty.all<Color>(
                                        Colors.purple[900]),
                                side: MaterialStateProperty.all<BorderSide>(
                                    BorderSide(color: Colors.black))),
                            onPressed: () async {
                              setState(() {
                                signInStart = true;
                              });
                              UserCredential cred;
                              try {
                                cred = await Auth.signInWithGoogle();
                                User user = cred.user;
                                String uid = user.uid;
                                AppUser appUser = AppUser(user.displayName,
                                    user.phoneNumber, user.email);

                                setState(() {
                                  signInStart = false;
                                });
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(uid)
                                    .set(
                                      appUser.userDetails,
                                      SetOptions(merge: true),
                                    );
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
                                Text('Sign in with Google',style: TextStyle(color: Colors.white),),
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
