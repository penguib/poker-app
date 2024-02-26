import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poker_app/models/cards.dart';
import 'package:poker_app/views/add_cards.dart';

// dubious global variable
final Map<CardValues, String> cardStrings = {
  CardValues.ace: "A",
  CardValues.two: "2",
  CardValues.three: "3",
  CardValues.four: "4",
  CardValues.five: "5",
  CardValues.six: "6",
  CardValues.seven: "7",
  CardValues.eight: "8",
  CardValues.nine: "9",
  CardValues.ten: "T",
  CardValues.jack: "J",
  CardValues.queen: "Q",
  CardValues.king: "K",
  CardValues.blank: "-",
};

class PokerCard extends StatelessWidget {
  final Suit suit;
  final CardValues value;
  final double scale;
  final int index;
  final String uuid;

  const PokerCard(
      {super.key,
      required this.suit,
      this.index = -1,
      this.uuid = "",
      required this.value,
      required this.scale});

  @override
  Widget build(BuildContext context) {
    if (suit == Suit.blank && value == CardValues.blank) {
      return GestureDetector(
          onTap: () {
            if (uuid.isNotEmpty) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddCards(
                            cardIndex: index,
                            uuid: uuid,
                          )));
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddCards(
                            cardIndex: index,
                          )));
            }
            HapticFeedback.mediumImpact();
          },
          child: Container(
            height: 240 * scale,
            width: 150 * scale,
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white)),
            child: const Center(
                child: Icon(
              Icons.add_rounded,
              size: 30,
            )),
          ));
    }

    return Container(
      height: 240 * scale,
      width: 150 * scale,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(children: [
        Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Text(
              cardStrings[value]!,
              style: TextStyle(
                  color: (suit == Suit.hearts || suit == Suit.diamonds)
                      ? Colors.red
                      : Colors.black,
                  fontSize: 60 * scale,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        // ♦️♥️♣️♠️ What's your favorite suit?
        Center(child: Builder(builder: (context) {
          if (suit == Suit.diamonds) {
            return Text("♦️",
                style: TextStyle(color: Colors.red, fontSize: 100 * scale));
          } else if (suit == Suit.hearts) {
            return Text("♥️",
                style: TextStyle(color: Colors.red, fontSize: 100 * scale));
          } else if (suit == Suit.clubs) {
            return Text("♣️",
                style: TextStyle(color: Colors.black, fontSize: 100 * scale));
          } else {
            return Text("♠️",
                style: TextStyle(color: Colors.black, fontSize: 100 * scale));
          }
        })),
      ]),
    );
  }
}
