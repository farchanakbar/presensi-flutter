import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi/app/routes/app_pages.dart';

class NewPasswordController extends GetxController {
  TextEditingController newPasswordC = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  void newPassword() async {
    if (newPasswordC.text.isNotEmpty) {
      if (newPasswordC.text != 'admin1234') {
        try {
          await auth.currentUser!.updatePassword(newPasswordC.text);

          await auth.signOut();
          Get.offAllNamed(Routes.LOGIN);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            Get.snackbar(
              'Terjadi Kesalahan',
              'Password terlalu pendek, minimal 6 karakter',
            );
          }
        } catch (e) {
          Get.snackbar(
            'Terjadi Kesalahan',
            'Tidak dapat mengubah password baru, hubungi admin',
          );
        }
      } else {
        Get.snackbar(
          'Terjadi Kesalahan',
          'Jangan sama seperti password sebelumnya',
        );
      }
    } else {
      Get.snackbar('Terjadi Kesalahan', 'Password tidak boleh kosong');
    }
  }
}
