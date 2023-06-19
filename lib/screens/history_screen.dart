import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as state_provider;
import 'package:seventy_five_hard/screens/history_progress_screen.dart';
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
              return InkWell(
                onTap: () {
                  day < progressProvider.day!
                      ? Utils.navigateTo(
                          context, HistoryProgressScreen(day: day))
                      : day == progressProvider.day!
                          ? Navigator.pop(context)
                          : Utils.showToast(
                              "You can't see the future, you can only see the past");
                },
                child: Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
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
                ),
              );
            }));
  }
}
