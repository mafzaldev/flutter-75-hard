import 'package:flutter/material.dart';
import 'package:seventy_five_hard/utils/utils.dart';
import 'package:seventy_five_hard/screens/login_screen.dart';
import 'package:seventy_five_hard/services/supabase_services.dart';
import 'package:seventy_five_hard/widgets/input_field.dart';
import 'package:seventy_five_hard/widgets/primary_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  SupabaseServices supabaseServices = SupabaseServices.instance;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 90),
              Image.asset('assets/images/Landscape.png',
                  width: 400, height: 200),
              const SizedBox(height: 16),
              InputField(
                controller: usernameController,
                label: 'Username',
                isPasswordField: false,
              ),
              const SizedBox(height: 16),
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
                onPressed: signUp,
                title: 'SignUp',
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  InkWell(
                    onTap: () => Utils.navigateTo(context, const LoginScreen()),
                    child: const Text(
                      "SignIn",
                      style: TextStyle(
                          color: AppColors.primaryColor, fontSize: 16),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void signUp() async {
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Utils.showToast('Please fill all the fields');
      return;
    }

    if (usernameController.text.length < 5) {
      Utils.showToast('Username must be at least 5 characters');
      return;
    }
    setState(() {
      isLoading = true;
    });
    final response = await supabaseServices.signup(
        email: emailController.text,
        password: passwordController.text,
        username: usernameController.text);
    if (response == 'success') {
      Utils.showToast('SignUp successfully, please Login!');
    } else {
      Utils.showToast(response);
    }
    setState(() {
      isLoading = false;
      usernameController.clear();
      emailController.clear();
      passwordController.clear();
    });
  }
}
