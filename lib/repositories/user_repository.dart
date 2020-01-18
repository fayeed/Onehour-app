import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onehour/models/user.dart';

class UserRepository {
  final Firestore _firestore;
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FacebookLogin _facebookLogin;

  UserRepository({
    FirebaseAuth firebaseAuth,
    GoogleSignIn googleSignIn,
    FacebookLogin facebookLogin,
    Firestore firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _facebookLogin = facebookLogin ?? FacebookLogin(),
        _firestore = firestore ?? Firestore.instance;

  Future<Map<String, dynamic>> _getUser({
    Map<String, dynamic> result,
    bool isGuest,
  }) async {
    final user = result["user"];

    final snapshot =
        await _firestore.collection("user").document(user.uid).get();

    if (!snapshot.exists) {
      final newUser = User.initial(
        displayName: user.displayName,
        email: user.email,
        isGuest: false,
        isNew: true,
        uid: user.uid,
      );

      await _firestore
          .collection("user")
          .document(user.uid)
          .setData(newUser.toJson());

      result["data"] = newUser;
    } else {
      final existingUser = User.fromJson(snapshot.data);

      if (existingUser.isNew) {
        existingUser.isNew = false;

        await _firestore
            .collection("user")
            .document(user.uid)
            .updateData(existingUser.toJson());
      }

      result["data"] = existingUser;
    }

    return result;
  }

  Future<Map<String, dynamic>> signInAsGuest() async {
    Map<String, dynamic> result = Map<String, dynamic>();
    result["user"] = null;
    result["data"] = null;
    result["error"] = null;

    try {
      final authResult = await _firebaseAuth.signInAnonymously();

      final user = authResult.user;

      final data = User.initial(uid: user.uid);

      result["user"] = user;

      result["data"] = data;
    } catch (e) {
      result["error"] = e.toString();
    }

    return result;
  }

  Future<Map<String, dynamic>> signInWithGoogle() async {
    Map<String, dynamic> result = Map<String, dynamic>();
    result["user"] = null;
    result["data"] = null;
    result["error"] = null;

    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      final authResult = await _firebaseAuth.signInWithCredential(credential);

      final user = authResult.user;

      result["user"] = user;

      result = await _getUser(result: result, isGuest: false);
    } catch (e) {
      result["error"] = e.toString();
    }

    return result;
  }

  Future<Map<String, dynamic>> signInWithFacebook() async {
    Map<String, dynamic> result = Map<String, dynamic>();
    result["user"] = null;
    result["data"] = null;
    result["error"] = null;

    try {
      final FacebookLoginResult facebookUser =
          await _facebookLogin.logInWithReadPermissions(["email"]);

      final AuthCredential credential = FacebookAuthProvider.getCredential(
        accessToken: facebookUser.accessToken.token,
      );

      final authResult = await _firebaseAuth.signInWithCredential(credential);

      final user = authResult.user;

      result["user"] = user;

      result = await _getUser(result: result, isGuest: false);
    } catch (e) {
      result["error"] = e.toString();
    }

    return result;
  }

  Future<Map<String, dynamic>> signInWithEmail(
      {@required String email, password}) async {
    Map<String, dynamic> result = Map<String, dynamic>();
    result["user"] = null;
    result["data"] = null;
    result["error"] = null;

    try {
      final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = authResult.user;

      result["user"] = user;

      result = await _getUser(result: result, isGuest: false);
    } catch (e) {
      try {
        final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final user = authResult.user;

        result["user"] = user;

        result = await _getUser(result: result, isGuest: false);
      } catch (e) {
        print(e);
        result["error"] = e.toString();
      }
    }

    return result;
  }

  Future<void> updateTrackingList(Map<String, dynamic> json) async {
    try {
      final user = await _firebaseAuth.currentUser();

      await _firestore
          .collection("user")
          .document(user.uid)
          .updateData({"trackingList": json["trackingList"]});
    } catch (e) {
      print(e);
    }
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _facebookLogin.logOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    return user != null;
  }

  Future<Map<String, dynamic>> getUser() async {
    Map<String, dynamic> result = Map<String, dynamic>();
    result["user"] = null;
    result["data"] = null;
    result["error"] = null;

    try {
      final user = await _firebaseAuth.currentUser();

      result["user"] = user;

      result = await _getUser(result: result, isGuest: false);
    } catch (e) {
      result["error"] = e.toString();
    }

    return result;
  }
}
