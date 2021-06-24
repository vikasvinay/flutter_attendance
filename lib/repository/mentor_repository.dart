import 'package:attendance_app/model/mentor_model.dart';
import 'package:attendance_app/model/student_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MentorRepository {
  FirebaseAuth firebaseAuth;
  FirebaseFirestore firebaseFirestore;

  MentorRepository(
      {FirebaseAuth? firebaseAuth, FirebaseFirestore? firebaseFirestore})
      : firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Stream<MentorModel> getMentorData() {
    return firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .snapshots()
        .asyncMap((event) => MentorModel.fromFireStore(doc: event));
  }

  Future<List<StudentModel>> getStudents(
      {required String mentorSubjects, required String studentYear}) async {
    List<StudentModel> _students = <StudentModel>[];
    QuerySnapshot data = await firebaseFirestore
        .collection('users')
        .where('enrolled_subjects', arrayContainsAny: [mentorSubjects]).where('student_year',isEqualTo: studentYear)
        .orderBy('name', descending: true).where('type',isEqualTo: 'STUDENT')
        .get();
    data.docs.forEach((element) {
      if (firebaseAuth.currentUser!.uid != element.get('uid')) {
        _students.add(StudentModel.fromFireStore(doc: element));
      }
    });
    return _students;
  }
}
