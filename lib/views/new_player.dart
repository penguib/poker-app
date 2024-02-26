import 'package:flutter/material.dart';
import 'package:poker_app/models/player.dart';

class NewPlayerView extends StatelessWidget {
  const NewPlayerView({super.key});

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
            "New Player",
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 30,
                fontWeight: FontWeight.w600),
          ),
          Icon(
            Icons.phishing_rounded,
            color: Theme.of(context).colorScheme.secondary,
            size: 50,
          ),
          const SizedBox(
            height: 50,
          ),
          Container(
              width: 300,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.secondary),
              child: TextField(
                  onSubmitted: (name) {
                      print(name);
                      PokerPlayer p = PokerPlayer(name);
                  },
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
                decoration: InputDecoration(
                    hintText: "Fish",
                    hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                    border: InputBorder.none,
                    icon: const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(Icons.person_add_rounded),
                    ),
                    iconColor: Theme.of(context).colorScheme.primary),
              ))
        ]),
      )),
    );
  }
}
