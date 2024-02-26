import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:poker_app/components/player_button.dart';
import 'package:poker_app/models/player.dart';
import 'package:poker_app/util/app_state.dart';
import 'package:poker_app/views/new_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final TextEditingController controller = TextEditingController();
  final List<PokerPlayer> activePlayers = [];
  late List<PokerPlayer> inactivePlayers = [];

  @override
  void initState() {
    super.initState();
    inactivePlayers = [...AppState.instance.allPlayers];
    AppState.instance.activePlayers.addListener(() {
      if (!mounted) {
        return;
      }

      for (int i = 0; i < AppState.instance.players.length; ++i) {
        String player = AppState.instance.players[i];
        var contain =
            activePlayers.where((element) => element.id == player).toList();

        if (contain.isNotEmpty) {
          continue;
        }

        PokerPlayer? pokerPlayer = AppState.instance.allPlayers
            .firstWhereOrNull((element) => element.id == player);
        if (pokerPlayer == null) {
          continue;
        }

        activePlayers.add(pokerPlayer);
        inactivePlayers.removeWhere((element) => element.id == player);
      }
      for (int i = 0; i < activePlayers.length; ++i) {
        if (!AppState.instance.players.contains(activePlayers[i].id)) {
          inactivePlayers.insert(0, activePlayers[i]);
          activePlayers.removeAt(i);
        }
      }
      setState(() {});
    });

    activePlayers.clear();
    for (int i = 0; i < AppState.instance.players.length; ++i) {
      String player = AppState.instance.players[i];
      PokerPlayer? pokerPlayer = AppState.instance.allPlayers
          .firstWhereOrNull((element) => element.id == player);
      if (pokerPlayer == null) {
        continue;
      }
      activePlayers.add(pokerPlayer);
      inactivePlayers.removeWhere((element) => element.id == player);
    }
  }

  @override
  void dispose() {
    super.dispose();
    AppState.instance.activePlayers.removeListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        width: double.infinity,
        color: Theme.of(context).colorScheme.primary,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  "♥️", //♣♠️♦♥️
                  style: TextStyle(color: Colors.red, fontSize: 100),
                ),
                Text(
                  "Player Profiles",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 30,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
            Column(
              children: [
                SizedBox(
                    height: 300,
                    child: Theme(
                        data: Theme.of(context).copyWith(
                          canvasColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        child: ReorderableListView(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          children: <Widget>[
                            for (int index = 0;
                                index < activePlayers.length;
                                index += 1)
                              Padding(
                                  key: Key("$index"),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: PlayerButton(
                                    name: activePlayers[index].name,
                                    id: activePlayers[index].id,
                                  ))
                          ],
                          onReorder: (int oldIndex, int newIndex) {
                            setState(() {
                              if (oldIndex < newIndex) {
                                newIndex -= 1;
                              }
                              final PokerPlayer item =
                                  activePlayers.removeAt(oldIndex);
                              final String item0 =
                                  AppState.instance.players.removeAt(oldIndex);
                              activePlayers.insert(newIndex, item);
                              AppState.instance.players.insert(newIndex, item0);
                            });
                          },
                        ))),
                Container(
                    width: 300,
                    height: 2,
                    color: Theme.of(context).colorScheme.secondary),
                SizedBox(
                    height: 200,
                    child: ListView.builder(
                        itemCount: inactivePlayers.length,
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        itemBuilder: (context, index) {
                          PokerPlayer player = inactivePlayers[index];
                          return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: PlayerButton(
                                  name: player.name, id: player.id));
                        })),
              ],
            ),
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const NewPlayerView()));
        },
        tooltip: 'Increment',
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
