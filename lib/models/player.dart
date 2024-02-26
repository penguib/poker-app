import 'package:poker_app/util/app_state.dart';
import 'package:uuid/uuid.dart';

class PokerPlayer {
  String name;
  late String id;

  /// buyIn will be used once a new poker session is started and will be used to
  /// track how much the player earns/loses in the `chips` property.
  int buyIn;

  /// Each position in chips corresponds to a deomination in
  /// `AppState.instance.chipDenominations`. We should change it to something
  /// better than ints in the future.
  List<int> chips = [1, 2, 3, 4];

  // TODO: should be tracking the chips they buy back in with
  // convert to List<List<int>>
  List<int> buyBacks = [];

  /// Refer to `chips` property explanation.
  int calculateStackSize() {
    int n = 0;
    for (int i = 0; i < chips.length; i++) {
      n += chips[i] * AppState.instance.chipDenominations[i];
    }
    return n;
  }

  /// Updates the stack of the player. When `won` is `true`, the player wins
  /// all the money in the pot, and will reset the pot. If `bet` is true,
  /// the player will lose the chips in their stack according to
  /// `AppState.instance.raiseAmount`. We do not check the validity of the
  /// raise since this is not a game and should be only recording what happens
  /// on the table. If `buyBack` is `true`, the player has bought back into the
  /// game with `bbChips`. If `smallBlind` is true, the player will bet `0.5`bb.
  /// Similarly, if `bigBlind` is true, the player will bet `1`bb.
  void updateStack(
      {bool won = false,
      bool bet = false,
      bool buyBack = false,
      bool smallBlind = false,
      bool bigBlind = false,
      List<int> bbChips = const [0, 0, 0, 0]}) {
    if (won) {
      for (int i = 0; i < chips.length; ++i) {
        chips[i] += AppState.instance.potChips[i];
      }
      AppState.instance.potChips = [0, 0, 0, 0];
      return;
    }

    if (bet) {
      for (int i = 0; i < chips.length; ++i) {
        chips[i] -= AppState.instance.raiseChips[i];
      }
      Map<String, int> potC = AppState.instance.potContributions;
      if (potC[id] == null) {
          potC[id] = AppState.instance.raiseAmount.value;
          return;
      }

      potC[id] = potC[id]! + AppState.instance.raiseAmount.value;
      return;
    }

    if (buyBack) {
      // Assuming that the player can also add onto their stack so that is
      // why i'm not directly setting the values, but instead adding them
      for (int i = 0; i < chips.length; ++i) {
        chips[i] += bbChips[i];
      }
      return;
    }

    if (smallBlind) {
      chips[chips.length - 1] -= 1;
      Map<String, int> potC = AppState.instance.potContributions;
      potC[id] = AppState.instance.chipDenominations[
              AppState.instance.chipDenominations.length - 1];
      return;
    }

    if (bigBlind) {
      chips[chips.length - 1] -= 2;
      Map<String, int> potC = AppState.instance.potContributions;
      potC[id] = AppState.instance.chipDenominations[
              AppState.instance.chipDenominations.length - 1] * 2;
      return;
    }
  }

  /// `parsingJson` is needed to not overwrite player uuids
  bool parsingJson;
  PokerPlayer(this.name, {this.buyIn = 0, this.parsingJson = false}) {
    if (parsingJson) {
      return;
    }
    id = const Uuid().v4();
  }

  @override
  String toString() => name;

  /// No need to be storing chips, buy ins, buy backs, etc. in the player object
  /// itself. The poker sessions should be storing all this data.
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  factory PokerPlayer.fromJson(Map<String, dynamic> json) {
    PokerPlayer p = PokerPlayer("placeholder", buyIn: 0, parsingJson: true);

    p.id = json["id"];
    p.name = json["name"];

    return p;
  }
}
