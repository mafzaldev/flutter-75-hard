// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart' as state_provider;
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:seventy_five_hard/services/sqflite_services.dart';
import 'package:seventy_five_hard/utils/utils.dart';
import 'package:seventy_five_hard/screens/splash_screen.dart';
import 'package:seventy_five_hard/providers/progress_provider.dart';
import 'package:seventy_five_hard/providers/user_provider.dart';

void saveProgress() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  SqfliteServices sqfliteServices = SqfliteServices();

  final int currentDay = prefs.getInt('currentDay') ?? 1;
  final double diet = prefs.getDouble('diet') ?? 0.0;
  final double workout = prefs.getDouble('workout') ?? 0.0;
  final double picture = prefs.getDouble('picture') ?? 0.0;
  final double water = prefs.getDouble('water') ?? 0.0;
  final double reading = prefs.getDouble('reading') ?? 0.0;
  final bool defaultPenalty = prefs.getBool('defaultPenalty') ?? true;

  final currentTime = DateTime.now();
  if (currentTime.hour == 10 && currentTime.minute == 30) {
    if (defaultPenalty) {
      if (diet == 0.0 ||
          workout == 0.0 ||
          picture == 0.0 ||
          water == 0.0 ||
          reading == 0.0) {
        await sqfliteServices.deleteAllData();
        Utils.clearPreferences(1);
        log('deleteAllData');
      } else {
        await sqfliteServices.insertData(
            currentDay, diet, workout, picture, water, reading);
        Utils.clearPreferences(currentDay + 1);
        log('insertData');
      }
    }
  } else {
    log('Not 10:30 AM');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: Utils.supabaseUrl,
    anonKey: Utils.publicAnonKey,
  );

  //NotificationService.scheduleNotification();
  await AndroidAlarmManager.initialize();

  await AndroidAlarmManager.periodic(
    const Duration(days: 1),
    1100,
    saveProgress,
    startAt: DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 10, 30),
    exact: true,
    wakeup: true,
  );

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return state_provider.MultiProvider(
        providers: [
          state_provider.ChangeNotifierProvider(create: (_) => UserProvider()),
          state_provider.ChangeNotifierProvider(
              create: (_) => ProgressProvider()),
        ],
        child: MaterialApp(
          title: '75Hard',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark(
            useMaterial3: true,
          ),
          home: const SplashScreen(),
        ));
  }
}
