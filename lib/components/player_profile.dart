import 'package:flutter/material.dart';
import 'package:poker_app/models/profile.dart';

class PlayerProfile extends StatelessWidget {
  final String id;
  const PlayerProfile({super.key, required this.id});

  @override
  Widget build(BuildContext context) {

      return Container(
          color: Theme.of(context).colorScheme.secondary,
          child: Column(children: [

          ]),
      );
  }
}
