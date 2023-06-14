// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as state_provider;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:seventy_five_hard/providers/progress_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:seventy_five_hard/models/user_model.dart' as user_model;
import 'package:seventy_five_hard/providers/user_provider.dart';
import 'package:seventy_five_hard/screens/history_screen.dart';
import 'package:seventy_five_hard/screens/preferences_screen.dart';
import 'package:seventy_five_hard/screens/progress_screen.dart';
import 'package:seventy_five_hard/services/api_services.dart';
import 'package:seventy_five_hard/widgets/greetings.dart';
import 'package:seventy_five_hard/widgets/rule_card.dart';
import 'package:seventy_five_hard/services/supabase_services.dart';
import 'package:seventy_five_hard/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool quotesLoading = true;
  bool profileLoading = true;
  List<String> quotes = [];
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _getQuotes();
    _getProfile();
    Timer.periodic(const Duration(seconds: 30), (timer) {
      final currentTime = DateTime.now();
      if (currentTime.hour == Utils.time['hour'] &&
          currentTime.minute == Utils.time['minute']) {
        log('Retrieving data from SharedPreferences....');
        _getProgress();
        timer.cancel();
      } else {
        log('Not ${Utils.time['hour']} ${Utils.time['minute']} PM',
            name: 'Home Screen');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = state_provider.Provider.of<UserProvider>(context);
    final progressProvider =
        state_provider.Provider.of<ProgressProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Image.asset('assets/images/Landscape.png', height: 45),
        actions: [
          IconButton(
            onPressed: () => Utils.navigateTo(context, const HistoryScreen()),
            icon: const Icon(
              Icons.history,
              size: 25,
            ),
          ),
          IconButton(
            onPressed: () =>
                Utils.navigateTo(context, const PreferencesScreen()),
            icon: const Icon(
              Icons.settings,
              size: 25,
            ),
          )
        ],
      ),
      body: profileLoading
          ? const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.white,
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  profileLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                      : Greetings(
                          username: userProvider.user!.username,
                          imageUrl: userProvider.user!.imageUrl,
                          day: progressProvider.day.toString()),
                  const SizedBox(height: 10),
                  Container(
                      margin: const EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xB6626262),
                          image: const DecorationImage(
                            opacity: 0.4,
                            fit: BoxFit.cover,
                            image: AssetImage(
                              'assets/images/sunrise.jpg',
                            ),
                          )),
                      child: Center(
                        child: quotesLoading
                            ? const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.white,
                              )
                            : AnimatedTextKit(
                                repeatForever: true,
                                animatedTexts: [
                                  getQuoteText(quotes[0]),
                                  getQuoteText(quotes[1]),
                                  getQuoteText(quotes[2]),
                                  getQuoteText(quotes[3]),
                                  getQuoteText(quotes[4]),
                                ],
                              ),
                      )),
                  RuleCard(
                    icon: const Icon(
                      Icons.restaurant_outlined,
                      size: 45,
                      color: Colors.green,
                    ),
                    title: "Follow a diet plan",
                    status: progressProvider.diet,
                    onTap: () {
                      Utils.navigateTo(
                          context,
                          ProgressScreen(
                            appBarTitle: "Diet",
                            icon: Icons.restaurant_outlined,
                            tip: 'Create a healthy diet plan and follow it.',
                            unit: 1.0,
                            progress: progressProvider.diet,
                            goal: 1,
                            progressColor: Colors.green,
                            onPressed: (double value) => {
                              progressProvider.setDiet(value),
                              _updateProgress('diet', value)
                            },
                          ));
                    },
                  ),
                  RuleCard(
                    icon: const Icon(
                      Icons.directions_run_outlined,
                      size: 45,
                      color: Colors.red,
                    ),
                    title: "45-minute workout",
                    status: progressProvider.workout,
                    onTap: () {
                      Utils.navigateTo(
                          context,
                          ProgressScreen(
                            appBarTitle: "Workout",
                            icon: Icons.directions_run_outlined,
                            tip:
                                'Do a 45-minute workout, it can be anything. Just move your body in a way that makes you sweat.',
                            unit: 0.0222222222222222,
                            progress: progressProvider.workout,
                            goal: 45,
                            progressColor: Colors.red,
                            onPressed: (double value) => {
                              progressProvider.setWorkout(value),
                              _updateProgress('workout', value)
                            },
                          ));
                    },
                  ),
                  RuleCard(
                    icon: const Icon(
                      Icons.image_outlined,
                      size: 45,
                      color: Colors.amber,
                    ),
                    title: "Take a progress picture",
                    status: progressProvider.picture,
                    onTap: () {
                      Utils.navigateTo(
                          context,
                          ProgressScreen(
                            appBarTitle: "Picture",
                            icon: Icons.image_outlined,
                            tip:
                                'Click a picture of yourself and save it. So that you can see your progress in the future.',
                            unit: 1.0,
                            progress: progressProvider.picture,
                            goal: 1,
                            progressColor: Colors.amber,
                            onPressed: (double value) => {
                              progressProvider.setPicture(value),
                              _updateProgress('picture', value)
                            },
                          ));
                    },
                  ),
                  RuleCard(
                    icon: const Icon(
                      Icons.water_drop_outlined,
                      size: 45,
                      color: Colors.blue,
                    ),
                    title: "Drink 1 gallon of water",
                    status: progressProvider.water,
                    onTap: () {
                      Utils.navigateTo(
                          context,
                          ProgressScreen(
                            appBarTitle: "Water",
                            icon: Icons.water_drop_outlined,
                            tip:
                                '1 gallon consists of 16 glasses of water. So, the goal is to drink 16 glasses of water.',
                            unit: 0.0625,
                            progress: progressProvider.water,
                            goal: 16,
                            progressColor: Colors.blue,
                            onPressed: (double value) => {
                              progressProvider.setWater(value),
                              _updateProgress('water', value)
                            },
                          ));
                    },
                  ),
                  RuleCard(
                    icon: const Icon(
                      Icons.book_outlined,
                      size: 45,
                      color: Colors.orange,
                    ),
                    title: "Read 10 pages of a book",
                    status: progressProvider.reading,
                    onTap: () {
                      Utils.navigateTo(
                          context,
                          ProgressScreen(
                            appBarTitle: "Reading",
                            icon: Icons.book_outlined,
                            tip:
                                'Pick a book and read 10 pages of it. That\'s it. The book could be of any genre.',
                            unit: 0.1,
                            progress: progressProvider.reading,
                            goal: 10,
                            progressColor: Colors.orange,
                            onPressed: (double value) => {
                              progressProvider.setReading(value),
                              _updateProgress('reading', value)
                            },
                          ));
                    },
                  ),
                ],
              ),
            ),
    );
  }

  _getQuotes() async {
    APIServices apiServices = APIServices.instance;
    quotes = await apiServices.fetchQuotes();
    setState(() {
      quotesLoading = false;
    });
  }

  _getProgress() async {
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

  _getProfile() async {
    SupabaseServices supabaseServices = SupabaseServices.instance;
    supabase.auth.onAuthStateChange.listen((data) async {
      final AuthChangeEvent event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        final User? user = supabase.auth.currentUser;
        final imageUrl = await supabaseServices.getUserAvatar(user!.email!);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        bool defaultPenalty = prefs.getBool('defaultPenalty') ?? true;

        state_provider.Provider.of<UserProvider>(context, listen: false)
            .setUser(
          user_model.User(
            email: user.email!,
            username: user.userMetadata!['username'],
            imageUrl: imageUrl,
          ),
        );
        state_provider.Provider.of<UserProvider>(context, listen: false)
            .setDefaultPenalty(defaultPenalty);
      }
      setState(() {
        profileLoading = false;
      });
    });
  }

  FadeAnimatedText getQuoteText(quote) {
    return FadeAnimatedText(
      quote,
      textAlign: TextAlign.center,
      textStyle: const TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
    );
  }

  void _updateProgress(String key, double value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }
}
