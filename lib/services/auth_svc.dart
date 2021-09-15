import 'package:distraction_destruction/templates/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as dev;

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Create local user object with firebase info
  AppUser? _localUser(User? user) {
    return user != null ? AppUser(uid: user.uid) : null;
  }

  //Change user from Firebase type to local type
  Stream<AppUser?> get user {
    return _auth.authStateChanges().map(_localUser); //(User? user) => _localUser(user)
  }

  //Sign in Anonymously
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _localUser(user);
    } catch (e) {
      dev.log(e.toString(), name:"services.auth.signInAnon", error: e);
      return null;
    }
  }

  //Sign in w/ email/pw

  //Register w/ email/pw

  //Sign out
}