import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poker_app/components/main_button.dart';
import 'package:poker_app/components/player_icon.dart';
import 'package:poker_app/components/poker_card.dart';
import 'package:poker_app/components/poker_chips.dart';
import 'package:poker_app/components/poker_stages.dart';
import 'package:poker_app/models/cards.dart';
import 'package:poker_app/models/player.dart';
import 'package:poker_app/models/round.dart';
import 'package:poker_app/models/stage.dart';
import 'package:poker_app/util/app_state.dart';
import 'package:poker_app/views/add_cards.dart';

class PokerRoundView extends StatefulWidget {
  const PokerRoundView({super.key});

  @override
  State<PokerRoundView> createState() => _PokerRound();
}

class _PokerRound extends State<PokerRoundView> {
  final List<MaterialColor> iconColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.lightBlue,
    Colors.pink,
    Colors.purple
  ];

  PokerStage stage = PokerStage.preflop;
  int dealerIndex = -1;
  int activePlayers = 0xFF; // hard coded to 8 players
  int lastRaiserIndex = -1;
  int currentPlayerIndex = 0;
  int lastBet = 0;
  int potSize = 0;

  /// Returns the next player to bet and skips over all players who have folded.
  /// If `currentPlayerIndex` is not set, it will return 2 positions over from
  /// the dealer. If `currentPlayerIndex` and `dealerIndex` is not set, this
  /// will return `0`.
  int nextPlayer() {
    int maxPlayers = AppState.instance.players.length;
    if (currentPlayerIndex == -1) {
      if (dealerIndex == -1) {
        return 0;
      }
      return (dealerIndex + 2) % maxPlayers;
    }
    int i = (currentPlayerIndex + 1) % maxPlayers;
    if (activePlayers & (1 << i) == 0) {
      currentPlayerIndex++;
      return nextPlayer();
    }
    return i;
  }

  /// Gets the player from `i` seats to the left of the dealer.
  PokerPlayer playerFromDealer(int i) {
    // WARN: Could be a problem if we are playing heads up
    int maxPlayers = AppState.instance.players.length;
    int p = (dealerIndex + i) % maxPlayers;
    PokerPlayer player = playerFromIndex(i: p);
    return player;
  }

  /// Resets the raise and raise chips that is globally kepy by `AppState`
  void resetRaise() {
    AppState.instance.raiseAmount.value = 0;
    AppState.instance.raiseChips = [0, 0, 0, 0];
  }

  /// Resets the pot chips that is globally kepy by `AppState`
  void resetPot() {
    AppState.instance.potChips = [0, 0, 0, 0];
  }

  /// Increases `potSize` by `val` and pot chips by the raise chips in `AppState`
  void increasePot(int val) {
    potSize += val;

    for (int i = 0; i < AppState.instance.potChips.length; ++i) {
      AppState.instance.potChips[i] += AppState.instance.raiseChips[i];
    }
  }

  /// Returns a `PokerPlayer` from `i`. If `i` is not set, this will return the
  /// player from `currentPlayerIndex`.
  PokerPlayer playerFromIndex({int i = -1}) {
    String uuid = "";
    if (i > -1) {
      uuid = AppState.instance.players[i];
    } else {
      uuid = AppState.instance.players[currentPlayerIndex];
    }
    PokerPlayer player = AppState.instance.allPlayers
        .firstWhere((element) => element.id == uuid);
    return player;
  }

  /// Sets the action on player index `i`.
  void setAction(int i) {
    currentPlayerIndex = i;
  }

  /// Sets up the bets for small blind and big blind and puts the action on the
  /// utg player. Should only be called once `dealerIndex` is set.
  void setUpPreFlop() {
    PokerPlayer smallBlind = playerFromDealer(1);
    PokerPlayer bigBlind = playerFromDealer(2);

    smallBlind.updateStack(smallBlind: true);
    bigBlind.updateStack(bigBlind: true);

    List<int> denominations = AppState.instance.chipDenominations;
    lastBet = denominations[denominations.length - 1] * 2;

    setAction(dealerIndex + 3);
  }

  int calculateToCall() {
    Map<String, int> potC = AppState.instance.potContributions;
    PokerPlayer player = playerFromIndex();
    if (potC[player.id] == null) {
      return lastBet - AppState.instance.raiseAmount.value;
    }
    int cont = potC[player.id]!;
    return (lastBet - cont) - AppState.instance.raiseAmount.value;
  }

  @override
  void initState() {
    super.initState();
    if (!mounted) {
      return;
    }

    resetRaise();
    resetPot();
    AppState.instance.potContributions.clear();

    AppState.instance.raiseAmount.addListener(() {
      if (!mounted) {
        return;
      }
      setState(() {});
    });

    AppState.instance.redrawRoundView.addListener(() {
      if (!mounted) {
        return;
      }

      setState(() {});
    });

    AppState.instance.currentRound = PokerRound();
  }

  @override
  void dispose() {
    super.dispose();
    AppState.instance.raiseAmount.removeListener(() {});
    AppState.instance.redrawRoundView.removeListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    PokerPlayer currentPlayer = playerFromIndex();
    PlayingCard playerCard1 =
        AppState.instance.getPlayerCards(currentPlayer.id, 0);
    PlayingCard playerCard2 =
        AppState.instance.getPlayerCards(currentPlayer.id, 1);
    print("to call: ${calculateToCall()} ${AppState.instance.raiseAmount.value}");

    return Scaffold(
        body: Container(
            width: double.infinity,
            height: double.infinity,
            color: Theme.of(context).colorScheme.primary,
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Text(
                  "Pot \$${(potSize / 100).toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 30),
                ),
                SizedBox(
                    height: 55,
                    width: double.infinity,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => GestureDetector(
                          onLongPress: () {
                            HapticFeedback.mediumImpact();
                            dealerIndex = index;
                            setUpPreFlop();
                            setState(() {});
                          },
                          onDoubleTap: () {
                            if (activePlayers & (1 << index) == 0) {
                              activePlayers |= 1 << index;
                            } else {
                              activePlayers = activePlayers & ~(1 << index);
                            }
                            setState(() {});
                          },
                          onTap: () {
                            int n = nextPlayer();
                            currentPlayerIndex = n;
                            setState(() {});
                          },
                          child: PlayerIcon(
                            color: iconColors[index],
                            dealer: dealerIndex == index,
                            selected: currentPlayerIndex == index,
                            folded: (activePlayers & (1 << index)) == 0,
                          )),
                      itemCount: AppState.instance.players.length,
                    )),
                Text(
                  "${currentPlayer.name} - \$${(currentPlayer.calculateStackSize() / 100).toStringAsFixed(2)}",
                  style: TextStyle(
                      color: iconColors[currentPlayerIndex],
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PokerCard(
                      suit: playerCard1.suit,
                      value: playerCard1.card,
                      index: 0,
                      scale: 0.3,
                      uuid: currentPlayer.id,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    PokerCard(
                      suit: playerCard2.suit,
                      value: playerCard2.card,
                      index: 1,
                      scale: 0.3,
                      uuid: currentPlayer.id,
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "\$${(AppState.instance.raiseAmount.value / 100).toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                      ],
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // WARN: make denominations
                      children: [
                        PokerChip(
                          value: 1.0,
                          color: Colors.black,
                        ),
                        PokerChip(
                          value: 0.5,
                          color: Colors.green,
                        ),
                        PokerChip(
                          value: 0.25,
                          color: Colors.red,
                        ),
                        PokerChip(
                          value: 0.1,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Builder(builder: (context) {
                      // last person checked and we aren't betting
                      if (lastBet == 0 &&
                          AppState.instance.raiseAmount.value == 0) {
                        return MainButton(
                            text: "Check",
                            color: Colors.blue,
                            textColor: Colors.white,
                            onTap: () {
                              // TODO: need to do something with the raise attribute.
                              // should make it nicer and have a check
                              PokerAction action = PokerAction(
                                  id: currentPlayer.id,
                                  position:
                                      PokerPosition.values[currentPlayerIndex],
                                  stage: stage,
                                  raise: 0);

                              int i = nextPlayer();
                              currentPlayerIndex = i;

                              AppState.instance.currentRound.actions
                                  .add(action);

                              HapticFeedback.mediumImpact();
                              setState(() {});
                            });
                      }
                      return MainButton(
                        // You need to stop using ternary statements...
                        text: (AppState.instance.raiseAmount.value > lastBet)
                            ? "Raise"
                            : (calculateToCall() > 0)
                                ? "\$${(calculateToCall() / 100).toStringAsFixed(2)} to Call"
                                : "Call",
                        color: (AppState.instance.raiseAmount.value > lastBet)
                            ? Colors.orange
                            : (calculateToCall() > 0)
                                ? Colors.grey
                                : Colors.green,
                        textColor: Colors.white,
                        onTap: () {
                          int raiseAmount = AppState.instance.raiseAmount.value;

                          if (raiseAmount < lastBet) {
                            return;
                          }

                          PokerAction action = PokerAction(
                              id: currentPlayer.id,
                              position:
                                  PokerPosition.values[currentPlayerIndex],
                              stage: stage,
                              raise: 0);

                          if (raiseAmount > lastBet) {
                            lastBet = raiseAmount;
                            action.raise = raiseAmount;
                          }

                          int i = nextPlayer();
                          currentPlayerIndex = i;

                          AppState.instance.currentRound.actions.add(action);
                          // currentPlayer.ad
                          increasePot(raiseAmount);
                          currentPlayer.updateStack(bet: true);
                          resetRaise();

                          HapticFeedback.mediumImpact();
                          setState(() {});
                        },
                      );
                    }),
                    const SizedBox(
                      height: 10,
                    ),
                    MainButton(
                        text: "Fold",
                        color: Colors.red,
                        textColor: Colors.white,
                        onTap: () {
                          PokerAction action = PokerAction(
                              id: currentPlayer.id,
                              position:
                                  PokerPosition.values[currentPlayerIndex],
                              stage: stage,
                              raise: -1);

                          // INFO: bro please make this a function
                          // lmao
                          activePlayers =
                              activePlayers & ~(1 << currentPlayerIndex);
                          int i = nextPlayer();
                          currentPlayerIndex = i;

                          AppState.instance.currentRound.actions.add(action);
                          setState(() {});
                        }),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    PokerCard(
                      index: 0,
                      suit: AppState.instance.currentRound.flop[0].suit,
                      value: AppState.instance.currentRound.flop[0].card,
                      scale: 0.4,
                    ),
                    PokerCard(
                      index: 1,
                      suit: AppState.instance.currentRound.flop[1].suit,
                      value: AppState.instance.currentRound.flop[1].card,
                      scale: 0.4,
                    ),
                    PokerCard(
                      index: 2,
                      suit: AppState.instance.currentRound.flop[2].suit,
                      value: AppState.instance.currentRound.flop[2].card,
                      scale: 0.4,
                    ),
                    PokerCard(
                      suit: AppState.instance.currentRound.turn.suit,
                      value: AppState.instance.currentRound.turn.card,
                      index: 3,
                      scale: 0.4,
                    ),
                    PokerCard(
                      suit: AppState.instance.currentRound.river.suit,
                      value: AppState.instance.currentRound.river.card,
                      index: 4,
                      scale: 0.4,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MainButton(
                      text: "Discard",
                      color: Colors.red,
                      textColor: Colors.white,
                      width: 170,
                      onTap: () {
                        HapticFeedback.mediumImpact();
                      },
                    ),
                    MainButton(
                      text: "Save",
                      color: Colors.green,
                      textColor: Colors.white,
                      width: 170,
                      onTap: () {
                        AppState.instance.storeRound();
                        HapticFeedback.mediumImpact();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            )));
  }
}
