// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as state_provider;
import 'package:seventy_five_hard/providers/progress_provider.dart';
import 'package:seventy_five_hard/screens/home_screen.dart';
import 'package:seventy_five_hard/screens/login_screen.dart';
import 'package:seventy_five_hard/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _redirectCalled = false;
  final supabase = Supabase.instance.client;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);
    if (_redirectCalled || !mounted) {
      return;
    }

    _redirectCalled = true;
    final session = supabase.auth.currentSession;
    if (session != null) {
      _setProgress();
      Utils.navigateTo(context, const HomeScreen(), replace: true);
    } else {
      Utils.navigateTo(context, const LoginScreen(), replace: true);
    }
  }

  _setProgress() async {
    Map<String, dynamic> preferences = await Utils.getPreferences();
    state_provider.Provider.of<ProgressProvider>(context, listen: false)
        .setProgress(
            day: preferences['currentDay'],
            diet: preferences['diet'],
            reading: preferences['reading'],
            picture: preferences['picture'],
            workout: preferences['workout'],
            water: preferences['water']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/Square.png', height: 300),
          const SizedBox(
            height: 100,
          ),
          const CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.white,
          ),
        ],
      ),
    ));
  }
}
