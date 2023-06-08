import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Greetings extends StatelessWidget {
  final String imageUrl;
  final String username;

  const Greetings({
    super.key,
    required this.imageUrl,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SvgPicture.network(height: 60, imageUrl)),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Hello", style: TextStyle(fontSize: 16)),
            Text(username,
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
  }
}
