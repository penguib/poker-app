enum PokerStage {
    preflop,
    flop,
    turn,
    river,
}

extension StageEx on PokerStage {
    String get text {
        if (this == PokerStage.preflop) {
            return "Pre-Flop";
        }
        return name[0].toUpperCase() + name.substring(1);
    }
}


