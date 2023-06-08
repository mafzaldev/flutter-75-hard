import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:seventy_five_hard/providers/user_provider.dart';
import 'package:seventy_five_hard/screens/login_screen.dart';
import 'package:seventy_five_hard/services/api_services.dart';
import 'package:seventy_five_hard/utils/utils.dart';
import 'package:seventy_five_hard/widgets/greetings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isQuoteLoading = true;
  String quote = "";

  @override
  void initState() {
    getQuote();
    super.initState();
  }

  getQuote() async {
    APIServices apiServices = APIServices.instance;
    quote = await apiServices.fetchQuote();
    setState(() {
      isQuoteLoading = false;
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
            onPressed: () {},
            icon: const Icon(
              Icons.history,
              size: 25,
            ),
          ),
          IconButton(
            onPressed: () async {
              Utils.navigateTo(context, const LoginScreen(), replace: true);
              await Future.delayed(const Duration(seconds: 2));
              userProvider.logOut();
            },
            icon: const Icon(
              Icons.logout,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xB6626262),
                ),
                child: Center(
                    child: isQuoteLoading
                        ? const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          )
                        : Text(
                            quote,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          )
                            .animate()
                            .fadeIn()
                            .move(delay: 300.ms, duration: 600.ms))),
          ],
        ),
      ),
    );
  }
}
