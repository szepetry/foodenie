import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodenie/auth/Auth.dart';
import 'package:foodenie/auth/SignInPage.dart';
import 'package:foodenie/reccommender.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../initPage.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String uid = snapshot.data.uid;
            Auth auth = Auth(uid);
            fbUid = uid;
            return InitPage(auth);
            /* if (Auth.googleAuthObj.currentUser != null) {
              return InitPage(auth, Auth.googleAuthObj.currentUser);
              /* return StreamBuilder<GoogleSignInAuthentication>(
                stream:
                    Auth.googleAuthObj.currentUser.authentication.asStream(),
                builder: (context, snapshot1) {
                  if (snapshot1.data != null) {
                    return InitPage(auth, snapshot1.data);
                  } else {
                    return SignInPage();
                  }
                }); */
            } else {
              return SignInPage();
            } */
            /* if (Auth.googleAuthObj.currentUser == null) {
              print('current user is null');
              return FutureBuilder<GoogleSignInAccount>(
                  future: Auth.gSignIn,
                  builder: (context, snapshot1) {
                    if (snapshot1.data == null) {
                      print('g sign in initiaite');
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      print('g-signin done');
                      return FutureBuilder<GoogleSignInAuthentication>(
                          future: snapshot1.data.authentication,
                          builder: (context, snapshot2) {
                            if (snapshot2.data != null) {
                              print('got-token');
                              token = snapshot2.data.idToken;
                              return InitPage(auth);
                            }
                            print('getting token');
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          });
                    }
                  });
            } else {
              print('current user not null');

              return StreamBuilder<GoogleSignInAuthentication>(
                  stream:
                      Auth.googleAuthObj.currentUser.authentication.asStream(),
                  builder: (context, snapshot3) {
                    if (snapshot3.data != null) {
                      if (snapshot3.hasError) {
                        print(snapshot.error);
                      }
                      token = snapshot3.data.idToken;
                      return InitPage(auth);
                    }
                    return Container(
                      color: Colors.lime[100],
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  });
            }
 
            return StreamBuilder<GoogleSignInAuthentication>(
                stream: Auth.googleAuthStream,
                builder: (context, snapshot2) {
                  if (snapshot2.data.idToken == null) {
                    return FutureBuilder<GoogleSignInAccount>(
                        future: Auth.gSignIn,
                        builder: (context, snapshot3) {
                          if (snapshot3.data == null) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }else{
                            return FutureBuilder<GoogleSignInAuthentication>(
                              future: snapshot3.data.authentication,
                              builder: (context, snapshot4) {
                                if (snapshot4.data.idToken != null) {
                                  token = snapshot4.data.idToken;
                                  return InitPage(auth);
                                }
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              });
                          }
                          
                        });
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }); */
          }
          return SignInPage();
        });
  }
}
