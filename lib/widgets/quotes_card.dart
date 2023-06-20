import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:seventy_five_hard/services/api_services.dart';
import 'package:seventy_five_hard/utils/utils.dart';

class QuotesCard extends StatefulWidget {
  const QuotesCard({super.key});

  @override
  State<QuotesCard> createState() => _QuotesCardState();
}

class _QuotesCardState extends State<QuotesCard> {
  bool quotesLoading = true;
  List<String> quotes = [];
  @override
  void initState() {
    super.initState();
    _getQuotes();
  }

  _getQuotes() async {
    APIServices apiServices = APIServices.instance;
    quotes = await apiServices.fetchQuotes();
    setState(() {
      quotesLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        width: double.infinity,
        height: 170,
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
        ));
  }

  FadeAnimatedText getQuoteText(String quote) {
    return FadeAnimatedText(
      quote,
      textAlign: TextAlign.center,
      textStyle: const TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
    );
  }
}
