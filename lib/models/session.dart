import 'package:poker_app/models/round.dart';
import 'package:uuid/uuid.dart';

class StackData {
  String playerID;
  int buyIn;
  List<int> buyBacks = [];
  List<int> chips = [];

  StackData(this.playerID, this.buyIn);

  Map<String, dynamic> toJson() => {
        "playerID": playerID,
        "buyIn": buyIn,
        "buyBacks": buyBacks,
        "chips": chips,
      };

  factory StackData.fromJson(Map<String, dynamic> json) {
    return StackData(json["playerID"], json["buyIn"]);
  }
}

class PokerSession {
  late String id;
  List<PokerRound> rounds = [];
  List<StackData> stackData = [];
  late DateTime date;
  bool parsingJson;

  PokerSession({this.parsingJson = false}) {
    if (parsingJson) {
      return;
    }

    id = const Uuid().v4();
    date = DateTime.now();
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "rounds": rounds,
        "stackData": stackData,
        "date": date,
      };

  factory PokerSession.fromJson(Map<String, dynamic> json) {
    PokerSession p = PokerSession(parsingJson: true);
    p.date = json["date"];
    p.id = json["id"];
    p.rounds = json["rounds"];
    p.stackData = json["stackData"];

    return p;
  }
}
