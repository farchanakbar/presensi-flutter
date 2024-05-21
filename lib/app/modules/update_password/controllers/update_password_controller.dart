import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController currC = TextEditingController();
  TextEditingController newC = TextEditingController();
  TextEditingController conNewC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> gantiPassword() async {
    if (currC.text.isNotEmpty &&
        newC.text.isNotEmpty &&
        conNewC.text.isNotEmpty) {
      if (newC.text == conNewC.text) {
        isLoading.value = true;
        try {
          String emailUser = auth.currentUser!.email!;

          await auth.signInWithEmailAndPassword(
              email: emailUser, password: currC.text);

          await auth.currentUser!.updatePassword(newC.text);

          Get.back();
          Get.snackbar('Berhasil', 'Berhasil mengubah password');
        } on FirebaseAuthException catch (e) {
          if (e.code == "wrong-password") {
            Get.snackbar('Terjadi Kesalahan', 'password salah');
          } else {
            Get.snackbar('Terjadi Kesalahan', e.code.toLowerCase());
          }
        } catch (e) {
          Get.snackbar('Terjadi Kesalahan', 'gagal mengubah password');
        } finally {
          isLoading.value = false;
        }
      } else {
        Get.snackbar('Terjadi Kesalahan', 'password tidak cocok');
      }
    } else {
      Get.snackbar('Terjadi Kesalahan', 'data tidak boleh kosong');
    }
  }
}
