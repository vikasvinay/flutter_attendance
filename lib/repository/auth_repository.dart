import 'dart:developer';
import 'dart:io';

import 'package:attendance_app/model/student_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  AuthRepository(
      {FirebaseAuth? firebaseAuth, FirebaseFirestore? firebaseFirestore})
      : firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  StudentModel _studentModel = StudentModel();

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
      required String studentYear,
      required String branch,
      required String password}) async {
    try {
      await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        _studentModel.branch = branch;
        _studentModel.email = email;
        _studentModel.enrolledSubjects = [];
        _studentModel.name = name;
        _studentModel.photoUrl =
            'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png';
        _studentModel.studentYear = studentYear;
        _studentModel.totalAbsent = FieldValue.increment(0) as int;
        _studentModel.totalPresent = FieldValue.increment(0) as int;
        _studentModel.type = 'STUDENT';
        _studentModel.uid = FirebaseAuth.instance.currentUser!.uid;

        await firebaseFirestore
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set(
                _studentModel.toFireStore()
                // {
                // 'uid': ,
                //   'total_present':
                //   'total_absent': FieldValue.increment(0),
                //   'name': name,
                //   'email': email,
                //   'type': type,
                //   'student_year': studentYear,

                //   'photo_url':
                //   'enrolled_subjects': []
                // }
                ,
                SetOptions(merge: true));
      });
      return true;
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
      return false;
    }
  }

  Future<bool> cerateMentor(
      {required String email,
      required String password,
      required String mentorName,
      required List<String> subjects}) async {
    FirebaseApp app = await Firebase.initializeApp(
        name: 'secondary', options: Firebase.app().options);
    try {
      UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email, password: password);
      userCredential.user!.uid;

      await firebaseFirestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'uid': userCredential.user!.uid,
        'name': mentorName,
        'email': email,
        'type': 'MENTOR',
        'photo_url':
            'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png',
        'enrolled_subjects': subjects
      }, SetOptions(merge: true));

      await app.delete();
      return true;
    } on FirebaseAuthException catch (e) {
      print(e);
      return false;
    }
  }

  Future sendImageToFirestore(
      {required String uid, required File imageFile}) async {
    Reference ref = FirebaseStorage.instance
        .ref('users/profile_pic/${FirebaseAuth.instance.currentUser!.uid}');
    await ref.putFile(imageFile).then((l) async {
      await firebaseFirestore.collection('users').doc(uid).set(
          {'photo_url': await ref.getDownloadURL()}, SetOptions(merge: true));
    });
  }

  Future<void> logOut() async {
    await firebaseAuth.signOut();
  }
}
