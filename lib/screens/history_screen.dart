import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as state_provider;
import 'package:seventy_five_hard/utils/utils.dart';
import 'package:seventy_five_hard/providers/progress_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ProgressProvider progressProvider =
        state_provider.Provider.of<ProgressProvider>(context);
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
                  color: day < progressProvider.day!
                      ? Colors.green
                      : day == progressProvider.day!
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
