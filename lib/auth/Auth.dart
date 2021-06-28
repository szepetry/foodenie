import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  String uid;
  static String acToken;
  Auth(this.uid);
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static GoogleSignInAccount googleUser;
  static GoogleSignIn googleAuthObj = GoogleSignIn();
  static Stream<GoogleSignInAuthentication> get googleAuthStream =>
      googleAuthObj.currentUser.authentication.asStream();
  static Future<String> get getIdToken async =>
      (await googleAuthObj.currentUser.authentication).idToken;

  static Future<GoogleSignInAccount> get gSignIn => googleAuthObj.signIn();
  static Future<Map<String, dynamic>> signInWithGoogle() async {
    googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    acToken = credential.idToken;
    UserCredential u = await _auth.signInWithCredential(credential);
    return {"cred": u, "token": acToken};
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
  Map<String, dynamic> get userDetails => {
        "name": name,
        "phoneNumber": phoneNumber,
        "email": email,
        "isSetupDone": false,
        "liked": [],
        "disliked": []
      };
}
