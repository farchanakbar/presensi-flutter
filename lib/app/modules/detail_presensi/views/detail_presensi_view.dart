import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/detail_presensi_controller.dart';

class DetailPresensiView extends GetView<DetailPresensiController> {
  const DetailPresensiView({super.key});
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = Get.arguments;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Presensi'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[200],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      DateFormat.yMMMMEEEEd().format(
                        DateTime.parse(data['date']),
                      ),
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Text(
                    'Masuk',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                      'Jam : ${DateFormat.jms().format(DateTime.parse(data['masuk']['date']))}'),
                  Text(
                    'Posisi : ${data['masuk']['lat']}, ${data['masuk']['long']}',
                  ),
                  Text(
                    'Distance : ${data['masuk']['distance'].toString().split('.').first} Meter',
                  ),
                  Text(
                    'Address : ${data['masuk']['address']}',
                  ),
                  Text('Status : ${data['masuk']['status']}'),
                  const Text(
                    'Keluar',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(data['keluar']?['date'] == null
                      ? 'belum absen keluar'
                      : 'Jam : ${DateFormat.jms().format(DateTime.parse(data['keluar']['date']))}'),
                  Text(data['keluar']?['lat'] != null
                      ? 'Posisi : ${data['masuk']['lat']}, ${data['masuk']['long']}'
                      : 'Posisi : -'),
                  Text(
                    data['keluar']?['distance'] != null
                        ? 'Distance : ${data['keluar']['distance'].toString().split('.').first} Meter'
                        : 'Distance : -',
                  ),
                  Text(
                    data['keluar']?['address'] != null
                        ? 'Address : ${data['masuk']['address']}'
                        : 'Address : -',
                  ),
                  Text(data['keluar']?['status'] != null
                      ? 'Status : ${data['keluar']?['status']}'
                      : 'Status : -'),
                ],
              ),
            )
          ],
        ));
  }
}
