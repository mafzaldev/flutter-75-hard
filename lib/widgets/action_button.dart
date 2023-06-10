import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final String? action;
  final Color color;
  final Function() onPressed;

  const ActionButton({
    super.key,
    this.title,
    this.icon,
    this.action,
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
                  Text(action!,
                      style: const TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                          fontWeight: FontWeight.w600))
                ],
              ),
      ),
    );
  }
}
