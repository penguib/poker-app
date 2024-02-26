import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poker_app/components/main_button.dart';
import 'package:poker_app/components/poker_card.dart';
import 'package:poker_app/models/cards.dart';
import 'package:poker_app/models/round.dart';
import 'package:poker_app/views/round.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePage();
}

class _GamePage extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Theme.of(context).colorScheme.primary,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
              ),
              const PokerCard(suit: Suit.diamonds, value: CardValues.ace, scale: 0.4,),
              const PokerCard(suit: Suit.clubs, value: CardValues.ace, scale: 0.5,),
              const Spacer(),
              MainButton(
                text: "New Round",
                onTap: () {
                  HapticFeedback.mediumImpact();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PokerRoundView()));
                },
              ),
              const SizedBox(height: 50),
            ],
          )),
    );
  }
}
