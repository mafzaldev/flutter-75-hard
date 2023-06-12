import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seventy_five_hard/services/sqflite_services.dart';
import 'package:seventy_five_hard/utils/utils.dart';

class Greetings extends StatelessWidget {
  final String day;
  final String imageUrl;
  final String username;

  const Greetings({
    super.key,
    required this.imageUrl,
    required this.username,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          // onTap: () => Utils.navigateTo(context, const PreferencesScreen()),
          onTap: () async {
            SqfliteServices sqfliteServices = SqfliteServices();
            var data = await sqfliteServices.getAllData();
            log(data.toString());
          },
          onDoubleTap: () async {
            SqfliteServices sqfliteServices = SqfliteServices();
            var data = await sqfliteServices.deleteAllData();
            log(data.toString());
          },
          child: Badge(
            smallSize: 12,
            backgroundColor: AppColors.primaryColor,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SvgPicture.network(height: 60, imageUrl)),
          ),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Hello", style: TextStyle(fontSize: 18)),
            Text(username,
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          ],
        ),
        const Spacer(),
        Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(10)),
            child: Text(
              'Day: $day',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ))
      ],
    );
  }
}
