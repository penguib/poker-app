import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poker_app/util/app_state.dart';
import 'package:poker_app/views/home.dart';

class PokerChip extends StatefulWidget {
  final Color color;
  final double value;
  const PokerChip({super.key, required this.value, required this.color});

  @override
  State<PokerChip> createState() => _PokerChip();
}

class _PokerChip extends State<PokerChip> {
  int amount = 0;
  late int denominationIndex = -1;

  void incrementRaise() {
    int tmp = AppState.instance.raiseAmount.value;
    double vTmp = widget.value * 100;
    int res = (tmp + vTmp).truncate();
    AppState.instance.raiseAmount.value = res;

    if (denominationIndex == -1) {
        return;
    }
    AppState.instance.raiseChips[denominationIndex]++;
    print(AppState.instance.raiseChips);
  }

  void decrementRaise() {
    int tmp = AppState.instance.raiseAmount.value;
    double vTmp = widget.value * 100;
    int res = (tmp - vTmp).truncate();
    AppState.instance.raiseAmount.value = res;

    if (denominationIndex == -1) {
        return;
    }
    AppState.instance.raiseChips[denominationIndex]--;
    print(AppState.instance.raiseChips);
  }

  @override
  void initState() {
    super.initState();

    int val = (widget.value * 100).truncate();
    denominationIndex = AppState.instance.chipDenominations.indexOf(val);

    AppState.instance.raiseAmount.addListener(() {
      if (!mounted) {
        return;
      }

      if (AppState.instance.raiseAmount.value == 0.0) {
        amount = 0;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100), color: widget.color),
          child: Center(
              child: (amount == 0)
                  ? const Text("")
                  : Text(
                      amount.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    )),
        ),
        Row(
          children: [
            GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  if (amount == 0) {
                    setState(() {});
                    return;
                  }
                  amount -= 1;
                  decrementRaise();
                  setState(() {});
                },
                child: const Icon(Icons.remove_rounded)),
            GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  amount += 1;
                  incrementRaise();
                  setState(() {});
                },
                child: const Icon(Icons.add_rounded)),
          ],
        )
      ],
    );
  }
}
