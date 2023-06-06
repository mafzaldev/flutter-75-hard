import 'package:flutter/material.dart';
import 'package:seventy_five_hard/Utils/utils.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final bool isLoading;
  final Function()? onPressed;
  const PrimaryButton(
      {super.key,
      required this.title,
      required this.onPressed,
      required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0))),
            child: isLoading
                ? const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.white,
                  )
                : Text(title,
                    style: const TextStyle(
                        fontSize: 20, color: AppColors.white))));
  }
}
