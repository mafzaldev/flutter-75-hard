import 'package:flutter/material.dart';
import 'package:seventy_five_hard/services/sqflite_services.dart';
import 'package:seventy_five_hard/utils/utils.dart';
import 'package:seventy_five_hard/widgets/custom_progress_indicator.dart';

class HistoryProgressScreen extends StatefulWidget {
  final int day;
  const HistoryProgressScreen({super.key, required this.day});

  @override
  State<HistoryProgressScreen> createState() => _HistoryProgressScreenState();
}

class _HistoryProgressScreenState extends State<HistoryProgressScreen> {
  List<Map<String, dynamic>> progress = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getProgress();
  }

  _getProgress() async {
    SqfliteServices sqfliteServices = SqfliteServices();
    List<Map<String, dynamic>> singleDayProgress = [];
    try {
      singleDayProgress = await sqfliteServices.getDataByDay(widget.day);
      setState(() {
        progress = singleDayProgress;
        isLoading = false;
      });
    } catch (e) {
      Utils.showToast(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Day ${widget.day}",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.white,
              ),
            )
          : ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                CustomPercentIndicator(
                  progress: progress[0]["diet"],
                  color: Colors.green,
                  title: "Diet",
                  goal: 1,
                ),
                CustomPercentIndicator(
                  progress: progress[0]["workout"],
                  color: Colors.red,
                  title: "Workout",
                  goal: 45,
                ),
                CustomPercentIndicator(
                  progress: progress[0]["picture"],
                  color: Colors.amber,
                  title: "Picture",
                  goal: 1,
                ),
                CustomPercentIndicator(
                  progress: progress[0]["water"],
                  color: Colors.blue,
                  title: "Water",
                  goal: 16,
                ),
                CustomPercentIndicator(
                  progress: progress[0]["reading"],
                  color: Colors.orange,
                  title: "Reading",
                  goal: 10,
                ),
              ],
            ),
    );
  }
}
