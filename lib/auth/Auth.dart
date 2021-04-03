import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  String uid;
  Auth(this.uid);
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static GoogleSignInAccount googleUser;
  static Future<UserCredential> signInWithGoogle() async {
    googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return _auth.signInWithCredential(credential);
  }

  static void signOut() {
    try {
      GoogleSignIn().disconnect();
      FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e);
    }
  }
}

class AppUser {
  final String name;
  final String phoneNumber;
  final String email;
  AppUser(this.name, this.phoneNumber, this.email);
  Map<String, dynamic> get userDetails =>
      {"name": name, "phoneNumber": phoneNumber, "email": email};
}
