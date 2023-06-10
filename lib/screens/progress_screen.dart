import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:seventy_five_hard/utils/utils.dart';
import 'package:seventy_five_hard/widgets/action_button.dart';

class ProgressScreen extends StatefulWidget {
  final String tip;
  final String appBarTitle;
  final dynamic progress;
  final dynamic unit;
  final dynamic goal;
  final Color progressColor;
  final IconData icon;
  final Function(double value) onPressed;

  const ProgressScreen(
      {super.key,
      required this.appBarTitle,
      required this.progress,
      required this.tip,
      required this.unit,
      required this.progressColor,
      required this.icon,
      required this.goal,
      required this.onPressed});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  dynamic _progress;

  @override
  void initState() {
    setState(() {
      _progress = widget.progress;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '${widget.appBarTitle} Progress',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularPercentIndicator(
                  radius: 100.0,
                  lineWidth: 20.0,
                  animation: true,
                  percent: _progress,
                  center: Text(
                    '${(_progress * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 28.0),
                  ),
                  footer: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      "Today's ${Utils.tasks[widget.appBarTitle]}${(_progress * widget.goal).round()}/${widget.goal}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24.0),
                    ),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: widget.progressColor,
                  backgroundColor: Colors.white),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.unit != 1.0
                      ? ActionButton(
                          icon: widget.icon,
                          color: widget.progressColor,
                          action: " -1",
                          onPressed: () async {
                            if (_progress - widget.unit < 0) return;
                            setState(() {
                              _progress = _progress - widget.unit;
                            });
                            widget.onPressed(_progress);
                          },
                        )
                      : const SizedBox(),
                  const SizedBox(width: 10),
                  widget.unit != 1.0
                      ? ActionButton(
                          icon: widget.icon,
                          color: widget.progressColor,
                          action: " +1",
                          onPressed: () {
                            if (_progress + widget.unit > 1) return;
                            setState(() {
                              _progress = _progress + widget.unit;
                            });
                            widget.onPressed(_progress);
                          },
                        )
                      : const SizedBox(),
                  const SizedBox(width: 10),
                  ActionButton(
                    color: widget.progressColor,
                    title: _progress != 1.0 ? 'I did it!' : 'Reset',
                    onPressed: () {
                      _progress != 1.0 ? _progress = 1.0 : _progress = 0.0;
                      setState(() {});
                      widget.onPressed(_progress);
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 150,
              ),
              Text(
                "Note: ${widget.tip}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
