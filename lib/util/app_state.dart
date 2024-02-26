import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:poker_app/models/cards.dart';
import 'package:poker_app/models/player.dart';
import 'package:poker_app/models/round.dart';
import 'package:poker_app/models/session.dart';

class AppState {
  static final AppState _instance = AppState._internal();
  static AppState get instance => _instance;

  /// Current players in the round
  List<String> players = [];

  /// Each round is being created in the `initState` of views/round.dart
  late PokerRound currentRound;
  PokerSession currentSession = PokerSession();

  /// ValueNotifier used when there is a change in the active players
  ValueNotifier activePlayers = ValueNotifier<bool>(true);

  /// `raiseChips` is used to keep track of which chips are being used to call/raise
  List<int> raiseChips = [ 0, 0, 0, 0 ];
  ValueNotifier<int> raiseAmount = ValueNotifier<int>(0);
  List<int> potChips = [0, 0, 0, 0];

  ValueNotifier<List<int>> defaultChipValues = ValueNotifier<List<int>>([0, 0, 0, 0]);
  double lastBet = 0.0;
  List<int> chipDenominations = [ 100, 50, 25, 10 ];
  Map<String, int> potContributions = {};

  /// Used for when we add a new card, we need to redraw the round view to
  /// show the new card.
  ValueNotifier<bool> redrawRoundView = ValueNotifier<bool>(false);

  // TODO: load in from disk
  List<PokerPlayer> allPlayers = [
    PokerPlayer("Aidan"),
    PokerPlayer("Benito"),
    PokerPlayer("Alex"),
    PokerPlayer("Liam"),
    PokerPlayer("Jamie"),
    PokerPlayer("Pat"),
    PokerPlayer("Noah"),
    PokerPlayer("Ben"),
  ];

  factory AppState() {
    return _instance;
  }

  AppState._internal();

  PokerPlayer? playerFromUuid(String uuid) {
      return allPlayers.firstWhereOrNull((element) => element.id == uuid);
  }

  PlayingCard getPlayerCards(String uuid, int index) {
      if (currentRound.playerCards[uuid] == null) {
          return PlayingCard.blank();
      }
      return currentRound.playerCards[uuid]![index];
  }

  /// Stores current poker round. Should be called when the "Save" button is
  /// pressed. Assuming that once the "Save" button is pressed, the view
  /// is dismissed. This is important because we are relying on the action
  /// of the `initState` of the round view to reset the current round.
  ///
  /// We should also probably be writing this to disk since we don't want to
  /// be saving a bunch of rounds in memory at once.
  void storeRound() {
      // TODO: store on disk
      currentSession.rounds.add(currentRound);
  }

  void updatePlayers(String id, bool isPlaying) {
    if (!isPlaying) {
      players.remove(id);
      activePlayers.value = !activePlayers.value;
      return;
    }

    if (players.contains(id)) {
      return;
    }
    players.add(id);
    activePlayers.value = !activePlayers.value;
  }
}
