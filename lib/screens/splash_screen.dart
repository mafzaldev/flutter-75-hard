// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as state_provider;
import 'package:seventy_five_hard/providers/progress_provider.dart';
import 'package:seventy_five_hard/screens/home_screen.dart';
import 'package:seventy_five_hard/screens/login_screen.dart';
import 'package:seventy_five_hard/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int currentDay = prefs.getInt('currentDay') ?? 1;
    final double diet = prefs.getDouble('diet') ?? 0.0;
    final double workout = prefs.getDouble('workout') ?? 0.0;
    final double picture = prefs.getDouble('picture') ?? 0.0;
    final double water = prefs.getDouble('water') ?? 0.0;
    final double reading = prefs.getDouble('reading') ?? 0.0;

    log('currentDay: $currentDay, diet: $diet, workout: $workout, picture: $picture, water: $water, reading: $reading');

    state_provider.Provider.of<ProgressProvider>(context, listen: false)
        .setProgress(
      currentDay,
      diet,
      reading,
      picture,
      workout,
      water,
    );
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
