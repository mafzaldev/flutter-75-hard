// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart' as state_provider;
import 'package:seventy_five_hard/services/sqflite_services.dart';
import 'package:seventy_five_hard/utils/utils.dart';
import 'package:seventy_five_hard/screens/splash_screen.dart';
import 'package:seventy_five_hard/providers/progress_provider.dart';
import 'package:seventy_five_hard/providers/user_provider.dart';

Future<void> saveProgress() async {
  SqfliteServices sqfliteServices = SqfliteServices();
  Map<String, dynamic> preferences = await Utils.getPreferences();

  final currentTime = DateTime.now();
  if (currentTime.hour == Utils.time['hour'] &&
      currentTime.minute == Utils.time['minute'] - 1) {
    if (preferences['defaultPenalty']) {
      if (preferences['diet'] == 0.0 ||
          preferences['workout'] == 0.0 ||
          preferences['picture'] == 0.0 ||
          preferences['water'] == 0.0 ||
          preferences['reading'] == 0.0) {
        await sqfliteServices.deleteAllData();
        Utils.clearPreferences(1);
        log('Deleting data in local storage and updating shared preferences....');
      } else {
        await sqfliteServices.insertData(
            preferences['currentDay'],
            preferences['diet'],
            preferences['workout'],
            preferences['picture'],
            preferences['water'],
            preferences['reading']);
        Utils.clearPreferences(preferences['currentDay'] + 1);
        log('Inserting data in local storage and updating shared preferences while default penalty is true....');
      }
    } else {
      await sqfliteServices.insertData(
          preferences['currentDay'],
          preferences['diet'],
          preferences['workout'],
          preferences['picture'],
          preferences['water'],
          preferences['reading']);
      Utils.clearPreferences(preferences['currentDay'] + 1);
      log('Inserting data in local storage and updating shared preferences....');
    }
  } else {
    log('Not ${Utils.time['hour']} ${Utils.time['minute']} PM', name: 'main');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: Utils.supabaseUrl,
    anonKey: Utils.publicAnonKey,
  );

  /*NotificationService.scheduleNotification();*/
  await AndroidAlarmManager.initialize();
  await AndroidAlarmManager.periodic(
    const Duration(days: 1),
    1100,
    saveProgress,
    startAt: DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      Utils.time['hour'],
      Utils.time['minute'] - 2,
    ),
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
