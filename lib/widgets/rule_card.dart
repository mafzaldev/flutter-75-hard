import 'package:flutter/material.dart';

class RuleCard extends StatelessWidget {
  final String title;
  final Icon icon;
  final Widget action;
  const RuleCard({
    super.key,
    required this.title,
    required this.icon,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xB6626262),
      ),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 10),
          Text(title,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
          const Spacer(),
          action,
        ],
      ),
    );
  }
}
