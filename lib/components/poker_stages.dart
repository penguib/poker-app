import 'package:flutter/material.dart';
import 'package:poker_app/models/stage.dart';

class PokerStageWidget extends StatefulWidget {
  bool selected = false;
  PokerStage stage;
  PokerStageWidget({super.key, required this.selected, required this.stage});

  @override
  State<PokerStageWidget> createState() => _PokerStageWidget();
}

class _PokerStageWidget extends State<PokerStageWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: (widget.selected)
              ? Theme.of(context).colorScheme.tertiary
              : Theme.of(context).colorScheme.secondary),
      width: 80,
      height: 40,
      child: Center(
          child: Text(
        widget.stage.text,
        style: TextStyle(color: (widget.selected) ? Colors.white : Colors.black),
      )),
    );
  }
}
