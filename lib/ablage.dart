import 'package:scoring/hand.dart';

import 'card.dart';

class Ablage {
  final Map<Card, CardState> _cards = {};

  int get length {
    return cards.length;
  }

  bool isVisible(Card card) {
    if (_cards[card] == null) return false;
    return _cards[card]!.visibility;
  }

  void addCard(Card card) {
    _cards[card] = CardState();
  }

  void addAll(Iterable<Card> cards) {
    for (Card card in cards) {
      addCard(card);
    }
  }

  void removeCard(Card card) {
    _cards.remove(card);
  }

  Iterable<Card> get cards {
    return _cards.keys;
  }

  void setVisible(Card card, bool visible) {
    if (_cards[card] != null) _cards[card]!.visibility = visible;
  }
}
