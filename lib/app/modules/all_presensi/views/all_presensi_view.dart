import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presensi/app/routes/app_pages.dart';

import '../controllers/all_presensi_controller.dart';

class AllPresensiView extends GetView<AllPresensiController> {
  const AllPresensiView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Semua Presensi'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 8,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: controller.streamAllAbsen(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('belum ada data absen'),
                    );
                  }
                  return ListView.builder(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> data =
                          snapshot.data!.docs[index].data();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Material(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(
                            20,
                          ),
                          child: InkWell(
                            onTap: () => Get.toNamed(Routes.DETAIL_PRESENSI),
                            borderRadius: BorderRadius.circular(
                              20,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  20,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Masuk',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        DateFormat.yMMMEd().format(
                                            DateTime.parse(data['date'])),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                  Text(DateFormat.jms().format(
                                      DateTime.parse(data['masuk']['date']))),
                                  data['masuk']['status'] != 'Di Dalam Area'
                                      ? Text(
                                          'Absen ${data['masuk']['status']}',
                                          style: const TextStyle(
                                            color: Colors.red,
                                          ),
                                        )
                                      : Text(
                                          'Absen ${data['masuk']['status']}',
                                          style: const TextStyle(
                                            color: Colors.green,
                                          ),
                                        ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Keluar',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(data['keluar'] != null
                                      ? DateFormat.jms().format(DateTime.parse(
                                          data['keluar']['date']))
                                      : 'belum absen keluar'),
                                  data['keluar'] != null
                                      ? data['masuk']['status'] !=
                                              'Di Dalam Area'
                                          ? Text(
                                              'Absen ${data['masuk']['status']}',
                                              style: const TextStyle(
                                                color: Colors.red,
                                              ),
                                            )
                                          : Text(
                                              'Absen ${data['masuk']['status']}',
                                              style: const TextStyle(
                                                color: Colors.green,
                                              ),
                                            )
                                      : const SizedBox()
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
