import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seventy_five_hard/widgets/providers/user_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<UserProvider>(
          builder: (context, value, child) {
            return Image.network(value.user!.imageUrl);
          },
        ),
      ),
    );
  }
}
