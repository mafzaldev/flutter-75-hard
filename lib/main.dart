// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:seventy_five_hard/services/notifications_service.dart';
import 'package:seventy_five_hard/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart' as state_provider;
import 'package:seventy_five_hard/screens/splash_screen.dart';
import 'package:seventy_five_hard/providers/progress_provider.dart';
import 'package:seventy_five_hard/providers/user_provider.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case "saveProgress":
        log(
          "This is a background task called from native!",
          name: "Background Fetch",
        );
        break;
    }
    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: Utils.supabaseUrl,
    anonKey: Utils.publicAnonKey,
  );
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );
  await Workmanager().registerPeriodicTask(
    "75",
    "saveProgress",
    frequency: const Duration(minutes: 15),
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );
  NotificationService().initNotification();
  NotificationService().scheduleNotification();
  /*await AndroidAlarmManager.initialize();
  await AndroidAlarmManager.periodic(
    const Duration(days: 1),
    1100,
    Utils.saveProgress,
    startAt: DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      Utils.time['hour'],
      Utils.time['minute'] - 2,
    ),
    exact: true,
    wakeup: true,
  );*/
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
