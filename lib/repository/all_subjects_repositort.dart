import 'package:attendance_app/model/all_subjects_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AllSubjectsRepository {
  FirebaseAuth firebaseAuth;
  FirebaseFirestore firebaseFirestore;

  AllSubjectsRepository(
      {FirebaseAuth? firebaseAuth, FirebaseFirestore? firebaseFirestore})
      : firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<List<AllSubjects>> getAllSubjects() async {
    var _subjects = <AllSubjects>[];

    var data = await firebaseFirestore.collection('subjects').get();

    data.docs.forEach((doc) {
      _subjects.add(AllSubjects.fromFirestore(doc: doc));
    });

    return _subjects;
  }
}
