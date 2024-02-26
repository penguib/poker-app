import 'package:flutter/material.dart';

class PlayerIcon extends StatefulWidget {
  bool dealer;
  Color color;
  bool folded;
  bool selected;
  PlayerIcon(
      {super.key,
      required this.dealer,
      required this.selected,
      required this.color,
      required this.folded});

  @override
  State<PlayerIcon> createState() => _PlayerIcon();
}

class _PlayerIcon extends State<PlayerIcon> {
  @override
  Widget build(BuildContext context) {
    if (widget.dealer) {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: widget.color.withOpacity(0.2)),
        child: Center(
            child: Icon(
          Icons.person_rounded,
          color: (widget.folded) ? widget.color.withOpacity(0.3) : widget.color,
          size: 48,
        )),
      );
    }
    return Column(
      children: [
        Icon(
          Icons.person_rounded,
          color: (widget.folded) ? widget.color.withOpacity(0.3) : widget.color,
          size: 48,
        ),
        Builder(builder: (context) {
          if (widget.selected) {
            return Container(
              height: 5,
              width: 5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: widget.color),
            );
          }
          return Container();
        }),
      ],
    );
  }
}
