import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seventy_five_hard/providers/user_provider.dart';
import 'package:seventy_five_hard/screens/login_screen.dart';
import 'package:seventy_five_hard/utils/utils.dart';
import 'package:seventy_five_hard/widgets/primary_button.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  bool imposePenalty = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Preferences",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            SwitchListTile(
                activeColor: AppColors.primaryColor,
                title: const Text(
                  "Impose the default penalty",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                value: imposePenalty,
                onChanged: (value) {
                  setState(() {
                    imposePenalty = value;
                  });
                }),
            const Spacer(),
            PrimaryButton(
                title: "Logout",
                onPressed: () async {
                  Utils.navigateTo(context, const LoginScreen(), replace: true);
                  await Future.delayed(const Duration(seconds: 2));
                  userProvider.logOut();
                },
                isLoading: false),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
