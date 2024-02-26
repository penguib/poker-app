import 'package:poker_app/models/cards.dart';
import 'package:poker_app/models/player.dart';
import 'package:poker_app/models/stage.dart';
import 'package:poker_app/util/app_state.dart';
import 'package:uuid/uuid.dart';

enum PokerPosition {
  btn,
  sb,
  bb,
  utg,
  utg1,
  mp,
  co,
  hj,

  blank,
}

class PokerRound {
  late String id;
  List<PokerAction> actions = [
      PokerAction.preflop(),
  ];
  List<PlayingCard> flop = [
    PlayingCard(CardValues.blank, Suit.blank),
    PlayingCard(CardValues.blank, Suit.blank),
    PlayingCard(CardValues.blank, Suit.blank)
  ];
  PlayingCard turn = PlayingCard(CardValues.blank, Suit.blank);
  PlayingCard river = PlayingCard(CardValues.blank, Suit.blank);
  String notes = "";
  Map<String, List<int>> startingStacks = {};
  Map<String, List<PlayingCard>> playerCards = {};

  PokerRound() {
    id = const Uuid().v4();
    _initStartingStacks();
  }

  _initStartingStacks() {
    for (int i = 0; i < AppState.instance.players.length; ++i) {
      String uuid = AppState.instance.players[i];
      PokerPlayer? player = AppState.instance.playerFromUuid(uuid);
      if (player == null) {
        continue;
      }

      startingStacks[uuid] = player.chips;
      playerCards[uuid] = [
        PlayingCard.blank(),
        PlayingCard.blank(),
      ];
    }
  }

  void setPlayerCard(String uuid, PlayingCard? card1, PlayingCard? card2) {
    if (playerCards[uuid] == null) {
      return;
    }

    if (card1 != null) {
      playerCards[uuid]![0] = card1;
    }

    if (card2 != null) {
      playerCards[uuid]![1] = card2;
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "notes": notes,
        "actions": actions,
        "flop": flop,
        "turn": turn,
        "river": river,
      };
}

class PokerAction {
  /// Player ID
  final String id;
  PokerStage stage;

  /// 0 is call. -1 is fold
  int raise;
  PokerPosition position;

  PokerAction({
    required this.id,
    required this.position,
    required this.stage,
    required this.raise,
  });

  // These constructors are supposed to act as divders between bets. The way
  // we store actions is in an array, and it will be easier when iterating 
  // through it to detect one of these and end the action of that street.
  factory PokerAction.preflop() {
    return PokerAction(
        id: "0",
        position: PokerPosition.blank,
        stage: PokerStage.preflop,
        raise: -2);
  }

  factory PokerAction.flop() {
    return PokerAction(
        id: "1",
        position: PokerPosition.blank,
        stage: PokerStage.flop,
        raise: -2);
  }
  factory PokerAction.turn() {
    return PokerAction(
        id: "2",
        position: PokerPosition.blank,
        stage: PokerStage.turn,
        raise: -2);
  }
  factory PokerAction.river() {
    return PokerAction(
        id: "3",
        position: PokerPosition.blank,
        stage: PokerStage.river,
        raise: -2);
  }

  factory PokerAction.fromJson(Map<String, dynamic> json) {
    PokerPosition pos = PokerPosition.values.firstWhere(
        (element) => element.toString() == "PokerPosition.${json['position']}");
    PokerStage s = PokerStage.values.firstWhere(
        (element) => element.toString() == "PokerStage.${json['stage']}");

    return PokerAction(
        id: json["id"], position: pos, stage: s, raise: json["raise"]);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "stage": stage.name,
        "position": position.name,
        "raise": raise,
      };

  @override
  String toString() {
    String s = "[$id]: ";
    if (raise == -1) {
      s += "folded ";
    } else if (raise == 0) {
      s += "called ";
    } else {
      s += "raised to \$$raise ";
    }

    s += "as the $position in the $stage";
    return s;
  }
}
