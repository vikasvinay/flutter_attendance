import 'package:attendance_app/model/subject_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SubJectRepository {
  late FirebaseAuth firebaseAuth;
  late FirebaseFirestore firebaseFirestore;

  SubJectRepository(
      {FirebaseAuth? firebase, FirebaseFirestore? firebaseFirestore})
      : firebaseAuth = firebase ?? FirebaseAuth.instance,
        firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;
  SubjectModel _subjectModel = SubjectModel();

  Stream<List<SubjectModel>> getAllSubjects() {
    Stream<QuerySnapshot<Map<String, dynamic>>> data = firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('subjects')
        .snapshots();
    return data.asyncMap((subjects) => subjects.docs
        .map((subject) => SubjectModel.fromFirestore(doc: subject))
        .toList());
  }

  Future<void> addSubject({required String subjectName}) async {
    DocumentReference<Map<String, dynamic>> docId = firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('subjects')
        .doc();
    _subjectModel.absent = 0;
    _subjectModel.present = 0;
    _subjectModel.subjectName = subjectName;
    _subjectModel.timestamp = Timestamp.fromDate(DateTime.now());
    _subjectModel.subjectId = docId.id;

    await docId.set(_subjectModel.toFirestore(), SetOptions(merge: true));
  }

  Future<void> editSubject(
      {required String subjectId, required SubjectModel subjectModel}) async {
    await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .set(subjectModel.toFirestore(), SetOptions(merge: true));
  }

  Future<void> addAttendance(
      {required bool isPresent, required String subjectId}) async {
    String type = isPresent ? 'present' : 'absent';
    await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('subjects')
        .doc(subjectId)
        .update({type: FieldValue.increment(1)});
  }
}
