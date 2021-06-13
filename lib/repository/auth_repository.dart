import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  AuthRepository(
      {FirebaseAuth? firebaseAuth, FirebaseFirestore? firebaseFirestore})
      : firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<bool> loginWithEmail(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
      return false;
    }
  }

  Future<bool> register(
      {required String type,
      required String name,
      required String email,
      required String password}) async {
    try {
      await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        await firebaseFirestore
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          'uid': FirebaseAuth.instance.currentUser!.uid,
          'name': name,
          'email': email,
          'type': type
        }, SetOptions(merge: true));
      });
      return true;
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
      return false;
    }
  }

  Future<void> logOut() async {
    await firebaseAuth.signOut();
  }
}
