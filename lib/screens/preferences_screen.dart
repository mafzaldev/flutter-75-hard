import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seventy_five_hard/providers/user_provider.dart';
import 'package:seventy_five_hard/screens/login_screen.dart';
import 'package:seventy_five_hard/utils/utils.dart';
import 'package:seventy_five_hard/widgets/primary_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  bool? defaultPenalty = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getPreferences();
  }

  getPreferences() {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    setState(() {
      isLoading = false;
      defaultPenalty = userProvider.defaultPenalty;
    });
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.white,
            ))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  SwitchListTile(
                      activeColor: AppColors.primaryColor,
                      title: const Text(
                        "Impose the default penalty",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      value: defaultPenalty!,
                      onChanged: (value) async {
                        setState(() {
                          defaultPenalty = value;
                        });
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setBool("defaultPenalty", value);
                        userProvider.setDefaultPenalty(value);
                      }),
                  const Spacer(),
                  PrimaryButton(
                      title: "Logout",
                      onPressed: () async {
                        Utils.navigateTo(context, const LoginScreen(),
                            replace: true);
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
