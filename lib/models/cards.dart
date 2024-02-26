enum CardValues {
  ace,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  ten,
  jack,
  queen,
  king,
  blank,
}

enum Suit {
  hearts,
  spades,
  clubs,
  diamonds,
  blank,
}

class PlayingCard {
  CardValues card;
  Suit suit;

  PlayingCard(this.card, this.suit);
  factory PlayingCard.blank() {
      return PlayingCard(CardValues.blank, Suit.blank);
  }

  factory PlayingCard.fromJson(Map<String, dynamic> json) {
    CardValues c = CardValues.values.firstWhere(
        (element) => element.toString() == "CardValues.${json['card']}");
    Suit s = Suit.values
        .firstWhere((element) => element.toString() == "Suit.${json['suit']}");

    return PlayingCard(c, s);
  }

  Map<String, dynamic> toJson() => {
        "card": card.name,
        "suit": suit.name,
      };

  @override
  String toString() => "${card.name} of ${suit.name}";

  @override
  bool operator ==(other) =>
      other is PlayingCard && other.card == card && other.suit == suit;

  @override
  int get hashCode => Object.hash(card, suit);
}
