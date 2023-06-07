import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seventy_five_hard/providers/user_provider.dart';

class Greetings extends StatelessWidget {
  const Greetings({
    super.key,
    required this.userProvider,
  });

  final UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SvgPicture.network(height: 60, userProvider.user!.imageUrl)),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Hello", style: TextStyle(fontSize: 16)),
            Text(userProvider.user!.username,
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
  }
}
