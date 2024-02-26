import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final String text;
  final void Function() onTap;
  Color? color;
  Color? textColor;
  double? width;
  MainButton(
      {super.key,
      required this.text,
      required this.onTap,
      this.color,
      this.width,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: (color != null)
                ? color
                : Theme.of(context).colorScheme.secondary,
            borderRadius: const BorderRadius.all(Radius.circular(12))),
        width: width ?? 300,
        height: 50,
        child: Center(
            child: Text(
          text,
          style: TextStyle(
              fontSize: 18, color: (textColor != null) ? textColor : Colors.black, fontWeight: FontWeight.w600),
        )),
      ),
    );
  }
}
