import 'package:flutter/material.dart';
import 'package:seventy_five_hard/Utils/utils.dart';
import 'package:seventy_five_hard/screens/signup_screen.dart';
import 'package:seventy_five_hard/services/supabase_services.dart';
import 'package:seventy_five_hard/widgets/input_field.dart';
import 'package:seventy_five_hard/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
              onPressed: () => supabaseServices.login(
                  email: emailController.text,
                  password: passwordController.text),
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
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen())),
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
}
