import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppColors {
  static const primaryColor = Color(0xFFdb0606);
  static const white = Color(0xFFFFFFFF);
}

class Utils {
  static const String supabaseUrl = 'https://vakxwprknaxjfqiservq.supabase.co';
  static const String publicAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZha3h3cHJrbmF4amZxaXNlcnZxIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODU5NzQxMTEsImV4cCI6MjAwMTU1MDExMX0.MBYwPdun3ORCQaOlMHoZC6tseCPe80FlZBJ5v_nzpeM';

  static showToast(String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFF818181),
      textColor: AppColors.white,
    );
  }

  static navigateTo(BuildContext context, Widget page, {bool replace = false}) {
    if (replace) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => page));
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  static int generateRandomNumber(int min, int max) {
    Random random = Random();
    return min + random.nextInt(max - min + 1);
  }

  static List<String> quoteCategories = [
    'failure',
    'god',
    'faith',
    'hope',
    'health',
    'life',
    'experience',
    'freedom',
    'success',
    'inspirational'
  ];

  static Map<String, dynamic> time = {
    'hour': 18,
    'minute': 25,
  };

  static void clearPreferences(int nextDay) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt('currentDay', nextDay);
    await prefs.remove("diet");
    await prefs.remove("workout");
    await prefs.remove("picture");
    await prefs.remove("water");
    await prefs.remove("reading");
  }

  static Future<Map<String, dynamic>> getPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    final int currentDay = prefs.getInt('currentDay') ?? 1;
    final double diet = prefs.getDouble('diet') ?? 0.0;
    final double workout = prefs.getDouble('workout') ?? 0.0;
    final double picture = prefs.getDouble('picture') ?? 0.0;
    final double water = prefs.getDouble('water') ?? 0.0;
    final double reading = prefs.getDouble('reading') ?? 0.0;
    final bool defaultPenalty = prefs.getBool('defaultPenalty') ?? true;

    return {
      'currentDay': currentDay,
      'diet': diet,
      'workout': workout,
      'picture': picture,
      'water': water,
      'reading': reading,
      'defaultPenalty': defaultPenalty
    };
  }
}
