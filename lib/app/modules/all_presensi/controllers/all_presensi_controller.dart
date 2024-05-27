import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AllPresensiController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  DateTime? start;
  DateTime end = DateTime.now();

  Future<QuerySnapshot<Map<String, dynamic>>> getAllAbsen() async {
    String uid = auth.currentUser!.uid;

    if (start == null) {
      return await firestore
          .collection('pegawai')
          .doc(uid)
          .collection('absen')
          .where('date', isLessThan: end.toIso8601String())
          .orderBy('date', descending: true)
          .get();
    } else {
      return await firestore
          .collection('pegawai')
          .doc(uid)
          .collection('absen')
          .where('date', isGreaterThan: start!.toIso8601String())
          .where('date',
              isLessThan: end.add(Duration(days: 1)).toIso8601String())
          .orderBy('date', descending: true)
          .get();
    }
  }

  void datePicker(DateTime pickStart, DateTime pickEnd) {
    start = pickStart;
    end = pickEnd;
    update();
  }
}
