import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProgressScreen extends StatefulWidget {
  final String appBarTitle;
  final String tip;
  final dynamic progress;
  final dynamic unit;
  final Color progressColor;
  final IconData icon;

  const ProgressScreen(
      {super.key,
      required this.appBarTitle,
      required this.progress,
      required this.tip,
      required this.unit,
      required this.progressColor,
      required this.icon});

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
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: widget.progressColor,
                backgroundColor: Colors.white),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ActionButton(
                  icon: widget.icon,
                  color: widget.progressColor,
                  onPressed: () {
                    if (_progress >= 1) return;
                    setState(() {
                      _progress = _progress + widget.unit;
                    });
                  },
                ),
                const SizedBox(width: 10),
                widget.unit != 1.0
                    ? ActionButton(
                        color: widget.progressColor,
                        title: 'I did it!',
                        onPressed: () {
                          setState(() {
                            _progress = 1.0;
                          });
                        },
                      )
                    : const SizedBox()
              ],
            ),
            const SizedBox(
              height: 150,
            ),
            Text(
              "Tip: ${widget.tip}",
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final Color color;
  final Function() onPressed;

  const ActionButton({
    super.key,
    this.title,
    this.icon,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 100,
        height: 50,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(25)),
        child: title != null
            ? Center(
                child: Text(title!,
                    style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w600)),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon!, color: Colors.white, size: 30),
                  const Text("+1",
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w600))
                ],
              ),
      ),
    );
  }
}
