// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:seventy_five_hard/services/sqflite_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart' as state_provider;

import 'package:seventy_five_hard/utils/utils.dart';
import 'package:seventy_five_hard/screens/splash_screen.dart';
import 'package:seventy_five_hard/providers/progress_provider.dart';
import 'package:seventy_five_hard/providers/user_provider.dart';

Future<void> onStart(ServiceInstance service) async {
  Timer.periodic(const Duration(seconds: 5), (timer) async {
    final currentTime = DateTime.now();
    if (currentTime.hour == 0 && currentTime.minute == 40) {
      log('Executing background task at 12:35 AM every night!');
      service.stopSelf();
    } else {
      log('Not 12:35 AM');
    }
  });
}

void saveProgress() async {
  final currentTime = DateTime.now();
  if (currentTime.hour == 0 && currentTime.minute == 35) {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    SqfliteServices sqfliteServices = SqfliteServices();

    final int currentDay = prefs.getInt('currentDay') ?? 1;
    final double diet = prefs.getDouble('diet') ?? 0.0;
    final double workout = prefs.getDouble('workout') ?? 0.0;
    final double picture = prefs.getDouble('picture') ?? 0.0;
    final double water = prefs.getDouble('water') ?? 0.0;
    final double reading = prefs.getDouble('reading') ?? 0.0;
    final bool defaultPenalty = prefs.getBool('defaultPenalty') ?? true;

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
    log('Progress saved in local database at 11:30PPM!!!');
  } else {
    log('Not 11:30PPM');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: Utils.supabaseUrl,
    anonKey: Utils.publicAnonKey,
  );

  /*
  NotificationService.scheduleNotification();
  await AndroidAlarmManager.initialize();

  await AndroidAlarmManager.periodic(
    const Duration(days: 1),
    1100,
    saveProgress,
    startAt: DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 24, 13),
    exact: true,
    wakeup: true,
  );
  */

  // Start the background service
  final service = FlutterBackgroundService();

  // Start the service
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(),
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
