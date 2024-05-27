import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../routes/app_pages.dart';

class CardAbsen extends StatelessWidget {
  const CardAbsen({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(
          20,
        ),
        child: InkWell(
          onTap: () => Get.toNamed(Routes.DETAIL_PRESENSI, arguments: data),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Masuk',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DateFormat.yMMMEd().format(DateTime.parse(data['date'])),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                Text(DateFormat.jms()
                    .format(DateTime.parse(data['masuk']['date']))),
                data['masuk']['status'] != 'di dalam area'
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
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(data['keluar'] != null
                    ? DateFormat.jms()
                        .format(DateTime.parse(data['keluar']['date']))
                    : 'belum absen keluar'),
                data['keluar'] != null
                    ? data['keluar']['status'] != 'di dalam area'
                        ? Text(
                            'Absen ${data['keluar']['status']}',
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                          )
                        : Text(
                            'Absen ${data['keluar']['status']}',
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
  }
}
