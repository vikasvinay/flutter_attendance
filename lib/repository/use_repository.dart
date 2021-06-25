import 'package:attendance_app/model/student_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  FirebaseAuth firebaseAuth;
  FirebaseFirestore firebaseFirestore;
  UserRepository(
      {FirebaseAuth? firebaseAuth, FirebaseFirestore? firebaseFirestore})
      : firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Stream<StudentModel> getStudentDetails({required String uid}) {
    return firebaseFirestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .asyncMap((doc) => StudentModel.fromFireStore(doc: doc));
  }
}
