import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/colors.dart';

class TypingQuotesWidget extends StatelessWidget {
  const TypingQuotesWidget({super.key});

  static const List<String> _quotes = [
    "The way to get started is to quit talking and begin doing. - Walt Disney",
    "The pessimist sees difficulty in every opportunity. The optimist sees opportunity in every difficulty. - Winston Churchill",
    "Don't let yesterday take up too much of today. - Will Rogers",
    "You learn more from failure than from success. Don't let it stop you. Failure builds character. - Unknown",
    "It's not whether you get knocked down, it's whether you get up. - Vince Lombardi",
    "If you are working on something that you really care about, you don't have to be pushed. The vision pulls you. - Steve Jobs",
    "People who are crazy enough to think they can change the world, are the ones who do. - Rob Siltanen",
    "Failure will never overtake me if my determination to succeed is strong enough. - Og Mandino",
    "Entrepreneurs are great at dealing with uncertainty and also very good at minimizing risk. That's the classic entrepreneur. - Mohnish Pabrai",
    "We don't have to be smarter than the rest. We have to be more disciplined than the rest. - Warren Buffett",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.black,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 32),
      child: Column(
        children: [
          Icon(Icons.format_quote, color: primary.withOpacity(0.8), size: 32),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            child: DefaultTextStyle(
              // Option 1: Playfair Display - Elegant & Sophisticated
              style: GoogleFonts.caesarDressing(
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: const Color(0xFFF0F0F0),
                height: 1.65,
                letterSpacing: 0.3,
                fontStyle: FontStyle.italic,
              ),

              textAlign: TextAlign.center,
              child: _buildAnimatedText(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedText() {
    return AnimatedTextKit(
      animatedTexts:
          _quotes
              .map(
                (quote) => TypewriterAnimatedText(
                  quote,
                  speed: const Duration(milliseconds: 50),
                  cursor: '|',
                ),
              )
              .toList(),
      repeatForever: true,
      pause: const Duration(seconds: 4),
      displayFullTextOnTap: true,
      stopPauseOnTap: false,
    );
  }
}
