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
        .doc(subjectName.trim());
    _subjectModel.absent = 0;
    _subjectModel.present = 0;
    _subjectModel.subjectName = subjectName.trim();
    _subjectModel.timestamp = Timestamp.fromDate(DateTime.now());
    _subjectModel.subjectId = subjectName.trim();

    await docId.set(_subjectModel.toFirestore(), SetOptions(merge: true));
    await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .set({
      'total_absent': FieldValue.increment(0),
      'total_present': FieldValue.increment(0),
      'enrolled_subjects': FieldValue.arrayUnion([subjectName.trim()])
    }, SetOptions(merge: true));
  }

  Future<void> addSubjectOnSignUp({required String subgectCode}) async {
    _subjectModel.absent = 0;
    _subjectModel.present = 0;
    _subjectModel.subjectName = subgectCode.trim();
    _subjectModel.timestamp = Timestamp.fromDate(DateTime.now());
    _subjectModel.subjectId = subgectCode.trim();
    
    DocumentReference<Map<String, dynamic>> docId = firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('subjects')
        .doc(subgectCode.trim());
    await docId.set(_subjectModel.toFirestore(), SetOptions(merge: true));

    await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .set({
      'total_absent': FieldValue.increment(0),
      'total_present': FieldValue.increment(0),
    }, SetOptions(merge: true));
  }

  Future<void> editSubject(
      {required String subjectId, required SubjectModel subjectModel}) async {
    await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .set(subjectModel.toFirestore(), SetOptions(merge: true));
  }

  Future<void> deleteSubject({required String subjectName}) async {
    firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('subjects')
        .doc(subjectName)
        .delete();

    await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .set({
      'enrolled_subjects': FieldValue.arrayRemove(
          [subjectName]) //([subjectName.toLowerCase().trim()])
    }, SetOptions(merge: true));
  }

  // Future<void> addAttendance(
  //     {required bool isPresent,
  //     required String subjectId,
  //     required String studentUid}) async {
  //   String type = isPresent ? 'present' : 'absent';
  //   String mainType = isPresent ? 'total_present' : 'total_absent';
  //   await firebaseFirestore
  //       .collection('users')
  //       .doc(studentUid)
  //       .collection('subjects')
  //       .doc(subjectId)
  //       .update({type: FieldValue.increment(1)});
  //   await firebaseFirestore.collection('users').doc(studentUid).update(
  //     {
  //       mainType: FieldValue.increment(1),
  //     },
  //   );
  // }
}
