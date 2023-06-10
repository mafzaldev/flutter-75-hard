import 'package:flutter/material.dart';
import 'package:seventy_five_hard/utils/utils.dart';

class HistoryScreen extends StatelessWidget {
  final currentDay = 10;
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "History",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        body: GridView.builder(
            itemCount: 75,
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6),
            itemBuilder: (context, index) {
              final day = index + 1;
              return Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: day < currentDay
                      ? Colors.green
                      : day == currentDay
                          ? AppColors.primaryColor
                          : Colors.grey,
                ),
                child: Center(
                  child: Text(
                    "$day",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              );
            }));
  }
}
