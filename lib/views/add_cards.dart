import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poker_app/components/main_button.dart';
import 'package:poker_app/models/cards.dart';
import 'package:poker_app/util/app_state.dart';

class _SelectedCard with ChangeNotifier {
  PlayingCard playingCard = PlayingCard(CardValues.blank, Suit.blank);

  void changeSuit(Suit suit) {
    playingCard.suit = suit;
    notifyListeners();
  }

  void changeValue(CardValues card) {
    playingCard.card = card;
    notifyListeners();
  }
}

_SelectedCard _selectedCard = _SelectedCard();

class AddCards extends StatefulWidget {
  final int cardIndex;
  final String uuid;
  const AddCards({super.key, required this.cardIndex, this.uuid = ""});

  @override
  State<AddCards> createState() => _AddCards();
}

class CardOption extends StatefulWidget {
  final String text;
  final Suit suit;
  final CardValues card;
  const CardOption(
      {super.key,
      required this.text,
      this.suit = Suit.blank,
      this.card = CardValues.blank});

  @override
  State<CardOption> createState() => _CardOption();
}

class _CardOption extends State<CardOption> {
  bool selected = false;

  @override
  void initState() {
    super.initState();

    _selectedCard.addListener(() {
      if (!mounted) {
        return;
      }

      if (widget.suit != Suit.blank) {
        if (widget.suit != _selectedCard.playingCard.suit) {
          selected = false;
        }
      } else if (widget.card != CardValues.blank) {
        if (widget.card != _selectedCard.playingCard.card) {
          selected = false;
        }
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _selectedCard.removeListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          selected = !selected;
          if (widget.suit != Suit.blank) {
            _selectedCard.changeSuit(widget.suit);
          } else {
            _selectedCard.changeValue(widget.card);
          }
          setState(() {});
        },
        child: Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
              color: (selected) ? Colors.green : Colors.transparent,
              border: (selected)
                  ? Border.all(color: Colors.green)
                  : Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: Text(
            widget.text,
            style: const TextStyle(fontSize: 40),
          )),
        ));
  }
}

class _AddCards extends State<AddCards> {
  @override
  void initState() {
    super.initState();
    _selectedCard.playingCard = PlayingCard(CardValues.blank, Suit.blank);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).colorScheme.primary,
        child: Column(children: [
          const SizedBox(
            height: 50,
          ),
          Text(
            "Add Cards",
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 30,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 20,
          ),
          const Wrap(
            spacing: 15,
            children: [
              CardOption(
                text: "♦️",
                suit: Suit.diamonds,
              ),
              CardOption(
                text: "♥️",
                suit: Suit.hearts,
              ),
              CardOption(
                text: "♣️",
                suit: Suit.clubs,
              ),
              CardOption(
                text: "♠️",
                suit: Suit.spades,
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Wrap(
            spacing: 15,
            runSpacing: 15,
            alignment: WrapAlignment.center,
            children: [
              CardOption(
                text: "2",
                card: CardValues.two,
              ),
              CardOption(
                text: "3",
                card: CardValues.three,
              ),
              CardOption(
                text: "4",
                card: CardValues.four,
              ),
              CardOption(
                text: "5",
                card: CardValues.five,
              ),
              CardOption(
                text: "6",
                card: CardValues.six,
              ),
              CardOption(
                text: "7",
                card: CardValues.seven,
              ),
              CardOption(
                text: "8",
                card: CardValues.eight,
              ),
              CardOption(
                text: "9",
                card: CardValues.nine,
              ),
              CardOption(
                text: "T",
                card: CardValues.ten,
              ),
              CardOption(
                text: "J",
                card: CardValues.jack,
              ),
              CardOption(
                text: "Q",
                card: CardValues.queen,
              ),
              CardOption(
                text: "K",
                card: CardValues.king,
              ),
              CardOption(
                text: "A",
                card: CardValues.ace,
              ),
            ],
          ),
          const Spacer(),
          MainButton(
              text: "Discard",
              color: Colors.red,
              textColor: Colors.white,
              onTap: () {
                Navigator.pop(context);
                HapticFeedback.mediumImpact();
              }),
          const SizedBox(
            height: 10,
          ),
          MainButton(
              text: "Add",
              color: Colors.green,
              textColor: Colors.white,
              onTap: () {
                if (widget.uuid.isNotEmpty) {
                  AppState.instance.currentRound
                          .playerCards[widget.uuid]![widget.cardIndex] =
                      _selectedCard.playingCard;
                } else {
                  if (widget.cardIndex >= 0 && widget.cardIndex <= 2) {
                    AppState.instance.currentRound.flop[widget.cardIndex] =
                        _selectedCard.playingCard;
                  } else if (widget.cardIndex == 3) {
                    AppState.instance.currentRound.turn =
                        _selectedCard.playingCard;
                  } else {
                    AppState.instance.currentRound.river =
                        _selectedCard.playingCard;
                  }
                }
                Navigator.pop(context);
                HapticFeedback.mediumImpact();
                AppState.instance.redrawRoundView.value =
                    !AppState.instance.redrawRoundView.value;
              }),
          const SizedBox(
            height: 50,
          ),
        ]),
      ),
    ));
  }
}
