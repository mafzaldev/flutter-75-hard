import 'package:flutter/material.dart';

class RuleCard extends StatelessWidget {
  final String title;
  final Icon icon;
  final double status;
  final Color bgColor;
  final Function()? onTap;

  const RuleCard({
    super.key,
    required this.title,
    required this.icon,
    required this.status,
    required this.onTap,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        height: MediaQuery.of(context).size.height * 0.09,
        // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xB6626262),
        ),
        child: Row(
          children: [
            Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: bgColor.withOpacity(0.3),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: icon),
            const SizedBox(width: 10),
            Text(title,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('${(status * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}
