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

  Future<YearSubjects> getYearSubjects(
      {required String year, required String branch}) async {
    var data =
        await firebaseFirestore.collection('all_subjects').doc(branch).get();
    Map<String, dynamic> subjects = await data[year];
    
    return  YearSubjects.fromFirestore(map: subjects);
  }

  Future<List<String>> getonlyBranchs() async {
    List<String> branch = [];
    var data = await firebaseFirestore.collection('all_subjects').get();
    data.docs.forEach((doc) {
      branch.add(doc.id);
    });
    return branch;
  }
}
