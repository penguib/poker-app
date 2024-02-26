import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poker_app/components/player_profile.dart';
import 'package:poker_app/util/app_state.dart';

class PlayerButton extends StatefulWidget {
  final String name;
  final String id;
  const PlayerButton({super.key, required this.name, required this.id});

  @override
  State<PlayerButton> createState() => _PlayerButton();
}

class _PlayerButton extends State<PlayerButton> {
  late bool isPlaying;

  @override
  void initState() {
    super.initState();
    isPlaying = AppState.instance.players.contains(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    isPlaying = AppState.instance.players.contains(widget.id);
    return GestureDetector(
      onDoubleTap: () {
        isPlaying = !isPlaying;
        AppState.instance.updatePlayers(widget.id, isPlaying);
        setState(() {});
      },
      onTap: () {
        HapticFeedback.mediumImpact();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PlayerProfile(id: widget.id)));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          color: (isPlaying)
              ? Theme.of(context).colorScheme.tertiary
              : Theme.of(context).colorScheme.secondary,
        ),
        width: 340,
        height: 50,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Text(
                  widget.name,
                  style: TextStyle(
                      color: (isPlaying) ? Colors.white : Colors.black,
                      fontSize: 20),
                ),
                const Spacer(),
                (isPlaying) ? const Icon(Icons.drag_handle_rounded, color: Colors.black) : Container(),
              ],
            )),
      ),
    );
  }
}
