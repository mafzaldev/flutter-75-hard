import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seventy_five_hard/providers/user_provider.dart';
import 'package:seventy_five_hard/screens/login_screen.dart';
import 'package:seventy_five_hard/widgets/greetings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
              userProvider.logOut();
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [Greetings(userProvider: userProvider)],
        ),
      ),
    );
  }
}
