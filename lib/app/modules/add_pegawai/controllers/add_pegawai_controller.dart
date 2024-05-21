import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_rx/get_rx.dart';

class AddPegawaiController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingAddPegawai = false.obs;
  TextEditingController nipC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController jobC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passAdminC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> prosesAddPegawai() async {
    if (passAdminC.text.isNotEmpty) {
      isLoadingAddPegawai.value = true;
      try {
        String emailAdmin = auth.currentUser!.email!;

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAdmin,
          password: passAdminC.text,
        );

        UserCredential pegawaiCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailC.text,
          password: 'admin1234',
        );

        if (pegawaiCredential.user != null) {
          String uid = pegawaiCredential.user!.uid;

          await firestore.collection('pegawai').doc(uid).set({
            'nip': nipC.text,
            'name': nameC.text,
            'email': emailC.text,
            'job': jobC.text,
            'role': 'pegawai',
            'uid': uid,
            'createdAt': DateTime.now().toIso8601String(),
          });

          await pegawaiCredential.user!.sendEmailVerification();

          await auth.signOut();

          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailAdmin,
            password: passAdminC.text,
          );

          Get.back(); //tutup dialog
          Get.back(); //kembali ke home

          Get.snackbar('Berhasil', 'Sukses menambahkan data pegawai');
        }
      } on FirebaseAuthException catch (e) {
        isLoadingAddPegawai.value = false;
        if (e.code == 'weak-password') {
          Get.snackbar('Terjadi Kesalahan', 'Password terlalu pendek');
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar('Terjadi Kesalahan', 'Email sudah terdaptar');
        } else if (e.code == 'wrong-password') {
          Get.snackbar('Terjadi Kesalahan', 'Password salah');
        } else {
          Get.snackbar('Terjadi Kesalahan', e.code);
        }
      } catch (e) {
        isLoadingAddPegawai.value = false;
        Get.snackbar('Terjadi Kesalahan', 'Gagal menambahkan pegawai');
      }
    } else {
      Get.snackbar('Terjadi Kesalahan', 'Password tidak boleh kosong!');
    }
  }

  Future<void> addPegawai() async {
    if (nipC.text.isNotEmpty &&
        jobC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      isLoading.value = true;
      Get.defaultDialog(
        title: 'Validasi Admin',
        content: Column(
          children: [
            const Text('Masukan password untuk validasi admin!'),
            TextField(
              controller: passAdminC,
              autocorrect: false,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Password',
              ),
            )
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              isLoading.value = false;
              Get.back();
            },
            child: const Text('Cancel'),
          ),
          Obx(
            () => ElevatedButton(
              onPressed: () async {
                if (isLoadingAddPegawai.isFalse) {
                  await prosesAddPegawai();
                  isLoading.value = false;
                  isLoadingAddPegawai.value = false;
                }
              },
              child: Text(
                  isLoadingAddPegawai.isFalse ? 'Add Pegawai' : 'Loading...'),
            ),
          ),
        ],
      );
    } else {
      Get.snackbar('Terjadi Kesalahan', 'Data tidak boleh kosong');
    }
  }
}
