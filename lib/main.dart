import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poker_app/views/game.dart';
import 'package:poker_app/views/home.dart';
import 'package:poker_app/views/winnings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
            primary: Color(0xFF292929),
            secondary: Color(0xFFA9A9A9),
            tertiary: Color(0xFF00B830)),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).colorScheme.primary,
        child: PageView(
          children: const [
            WinningsPage(),
            HomePage(),
            GamePage(),
          ],
        ));
  }
}
