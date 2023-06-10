import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:seventy_five_hard/providers/user_provider.dart';
import 'package:seventy_five_hard/screens/history_screen.dart';
import 'package:seventy_five_hard/screens/preferences_screen.dart';
import 'package:seventy_five_hard/screens/progress_screen.dart';
import 'package:seventy_five_hard/services/api_services.dart';
import 'package:seventy_five_hard/utils/utils.dart';
import 'package:seventy_five_hard/widgets/greetings.dart';
import 'package:seventy_five_hard/widgets/rule_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool quotesLoading = true;
  List<String> quotes = [];

  @override
  void initState() {
    getQuote();
    super.initState();
  }

  getQuote() async {
    APIServices apiServices = APIServices.instance;
    quotes = await apiServices.fetchQuotes();
    setState(() {
      quotesLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Greetings(
                username: userProvider.user!.username,
                imageUrl: userProvider.user!.imageUrl),
            const SizedBox(height: 10),
            Container(
                margin: const EdgeInsets.only(top: 16),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              action: const SizedBox(),
              onTap: () {
                Utils.navigateTo(
                    context,
                    const ProgressScreen(
                      appBarTitle: "Diet",
                      icon: Icons.restaurant_outlined,
                      tip: 'Follow a diet plan',
                      unit: 1.0,
                      progress: 0.0,
                      progressColor: Colors.green,
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
              action: const SizedBox(),
              onTap: () {
                Utils.navigateTo(
                    context,
                    const ProgressScreen(
                      appBarTitle: "Workout",
                      icon: Icons.directions_run_outlined,
                      tip: '45-minute workout',
                      unit: 0.02,
                      progress: 0.0,
                      progressColor: Colors.red,
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
              action: const SizedBox(),
              onTap: () {
                Utils.navigateTo(
                    context,
                    const ProgressScreen(
                      appBarTitle: "Picture",
                      icon: Icons.image_outlined,
                      tip: 'Take a progress picture',
                      unit: 1.0,
                      progress: 0.0,
                      progressColor: Colors.amber,
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
              action: const SizedBox(),
              onTap: () {
                Utils.navigateTo(
                    context,
                    const ProgressScreen(
                      appBarTitle: "Water",
                      icon: Icons.water_drop_outlined,
                      tip: 'Drink 1 gallon of water',
                      unit: 0.0625,
                      progress: 0.0,
                      progressColor: Colors.blue,
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
              action: const SizedBox(),
              onTap: () {
                Utils.navigateTo(
                    context,
                    const ProgressScreen(
                      appBarTitle: "Reading",
                      icon: Icons.book_outlined,
                      tip: 'Read 10 pages of a book',
                      unit: 0.1,
                      progress: 0.0,
                      progressColor: Colors.orange,
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }

  FadeAnimatedText getQuoteText(quote) {
    return FadeAnimatedText(
      quote,
      textAlign: TextAlign.center,
      textStyle: const TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
    );
  }
}
