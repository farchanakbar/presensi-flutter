import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_password_controller.dart';

class UpdatePasswordView extends GetView<UpdatePasswordController> {
  const UpdatePasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Password'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: controller.currC,
            autocorrect: false,
            obscureText: true,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: 'Current Password'),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: controller.newC,
            autocorrect: false,
            obscureText: true,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: 'New Password'),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: controller.conNewC,
            autocorrect: false,
            obscureText: true,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Confirm new password'),
          ),
          const SizedBox(
            height: 20,
          ),
          Obx(
            () => ElevatedButton(
              onPressed: () {
                if (controller.isLoading.isFalse) {
                  controller.gantiPassword();
                }
              },
              child: Text(
                controller.isLoading.isFalse ? 'Ganti password' : 'Loading...',
              ),
            ),
          )
        ],
      ),
    );
  }
}
