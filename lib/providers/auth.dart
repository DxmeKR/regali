import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool get isAuth {
    if (FirebaseAuth.instance.currentUser != null) {
      return true;
    }
    return false;
  }

  Stream<User?> get onAuthStateChanged {
    return _auth.authStateChanges();
  }

  String? get uid {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  Future<User?> loginEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      return result.user;
    } on FirebaseAuthException catch (e) {
      throw e.code;
    }
  }

  //logout
  Future logout() async {
    try {
      //await _googleSignIn.signOut();
      return await _auth.signOut();
    } catch (e) {
      // print(e.toString());
      return null;
    }
  }
}
