import 'card.dart';
import 'deck.dart';

class Hand {
  final Map<Card, CardState> _cards = {};

  int get length {
    return cards.length;
  }

  void addCard(Card card) {
    _cards[card] = CardState();
  }

  bool get isNotEmpty {
    return _cards.isNotEmpty;
  }

  bool removeCard(Card card) {
    if (_cards.remove(card) == null) return false;
    return true;
  }

  Iterable<Card> get cards {
    return _cards.keys;
  }

  Iterable<Card> get activeCards {
    return cards.where((card) => isActive(card));
  }

  bool isActive(Card card) {
    if (_cards.containsKey(card)) {
      return _cards[card]!.isActive();
    }
    return false;
  }

  void blockCard(Card card) {
    if (_cards.containsKey(card)) {
      if (_cards[card]!.activationState == null) {
        _cards[card]!.activationState = false;
      }
    }
  }

  void resetActivationState() {
    for (CardState state in _cards.values) {
      state.activationState = null;
    }
  }

  // TODO: visible should be tracked in the widget using visible
  bool isVisible(Card card) {
    if (_cards.containsKey(card)) {
      return _cards[card]!.visibility;
    }
    return false;
  }

  void setVisible(Card card, bool visible) {
    if (_cards.containsKey(card)) {
      _cards[card]!.visibility = visible;
    }
  }

  void reset(bool isExpansion) {
    Map<Card, CardState> newCards = {};
    for (Card card in cards) {
      Card cop = Deck().cards(isExpansion).firstWhere((element) => element.id == card.id);
      newCards[cop] = _cards[card]!;
    }
    _cards.removeWhere((key, value) => true);
    _cards.addAll(newCards);
  }

  void setUnblockable(Card card) {
    _cards[card]?.activationState = true;
  }
}

class CardState {
  bool? activationState;
  // true if the card is collapsed
  bool visibility;

  CardState({this.visibility = false, this.activationState});

  bool isActive() {
    if (activationState == null) return true;
    return activationState!;
  }
}
