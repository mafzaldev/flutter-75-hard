// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seventy_five_hard/providers/progress_provider.dart';

import 'package:seventy_five_hard/screens/home_screen.dart';
import 'package:seventy_five_hard/utils/utils.dart';
import 'package:seventy_five_hard/models/user_model.dart';
import 'package:seventy_five_hard/screens/signup_screen.dart';
import 'package:seventy_five_hard/services/supabase_services.dart';
import 'package:seventy_five_hard/widgets/input_field.dart';
import 'package:seventy_five_hard/widgets/primary_button.dart';
import 'package:seventy_five_hard/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  SupabaseServices supabaseServices = SupabaseServices.instance;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/Landscape.png', width: 400, height: 200),
            InputField(
              controller: emailController,
              label: 'Email',
              isPasswordField: false,
            ),
            const SizedBox(height: 16),
            InputField(
              controller: passwordController,
              label: 'Password',
              isPasswordField: true,
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              isLoading: isLoading,
              onPressed: login,
              title: 'SignIn',
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                InkWell(
                  onTap: () => Utils.navigateTo(context, const SignUpScreen()),
                  child: const Text(
                    "SignUp",
                    style:
                        TextStyle(color: AppColors.primaryColor, fontSize: 16),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Utils.showToast('Please fill all the fields');
      return;
    }
    UserProvider userProvider = Provider.of(context, listen: false);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool defaultPenalty = prefs.getBool('defaultPenalty') ?? true;

    setState(() {
      isLoading = true;
    });
    final response = await supabaseServices.login(
        email: emailController.text, password: passwordController.text);
    if (response.containsKey("username")) {
      userProvider.setUser(
        User(
            username: response["username"],
            email: response["email"],
            imageUrl: response["imageUrl"]),
      );
      userProvider.setDefaultPenalty(defaultPenalty);
      _setProgress();
      Utils.navigateTo(context, const HomeScreen(), replace: true);
    }
    setState(() {
      isLoading = false;
      emailController.clear();
      passwordController.clear();
    });
  }

  _setProgress() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int currentDay = prefs.getInt('currentDay') ?? 1;
    final double diet = prefs.getDouble('diet') ?? 0.0;
    final double workout = prefs.getDouble('workout') ?? 0.0;
    final double picture = prefs.getDouble('picture') ?? 0.0;
    final double water = prefs.getDouble('water') ?? 0.0;
    final double reading = prefs.getDouble('reading') ?? 0.0;

    Provider.of<ProgressProvider>(context, listen: false).setProgress(
      currentDay,
      diet,
      reading,
      picture,
      workout,
      water,
    );
  }
}
