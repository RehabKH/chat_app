import 'package:chat_app/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';


class AuthMethods {
  FirebaseAuth _auth = FirebaseAuth.instance;

  AuthMethods() {
    Firebase.initializeApp();
  }
  UserID _userFromFirebaseUser(User user) {
    print("user id ::::::::::::::::::::::::::::" + user.uid);
    return UserID(user.uid);
  }

  Future signInWithEmailAndPass(String email, String pass) async {
    try {
      UserCredential result =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch (e) {
      print("error sign in::::::::::::::::::" + e.toString());
    }
  }

  Future signUpWithEmailAndPass(String email, String pass) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch (e) {
      print("error sign up ::::::::::::::::::" + e.toString());
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
