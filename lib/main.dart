// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart' as state_provider;
import 'package:seventy_five_hard/Utils/utils.dart';
import 'package:seventy_five_hard/screens/splash_screen.dart';
import 'package:seventy_five_hard/providers/progress_provider.dart';
import 'package:seventy_five_hard/providers/user_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: Utils.supabaseUrl,
    anonKey: Utils.publicAnonKey,
  );
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final supabase = Supabase.instance.client;
  bool isLoggedin = false;

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
