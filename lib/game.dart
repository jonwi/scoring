import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:scoring/settings.dart';

import 'ablage.dart';
import 'card.dart';
import 'deck.dart';
import 'hand.dart';

class Game {
  final Hand _hand;
  final Ablage _ablage;

  int sum = 0;
  int? id;
  int maxSum = 0;

  Game(this._hand, this._ablage);

  Future<void> save() async {
    var box = getGamesBox();
    Map<int, List<Cards>> map = {};
    map[sum] = _hand.cards.map((card) => card.id).toList();
    //TODO: Magic Number here that cant be reached
    map[100000] = _ablage.cards.map((card) => card.id).toList();
    if (id == null) {
      box.add(map).then((value) => id = value);
    } else {
      box.put(id, map);
    }
  }

  static Game load(int gameID) {
    var map = getGamesBox().getAt(gameID);
    if (map != null) {
      return parseMap(map, gameID);
    }
    throw Exception('cannot load game with id $gameID');
  }

  static Game parseMap(Map<int, List<Cards>> map, int id) {
    var handEntry = map.entries.first;
    Hand hand = Hand();
    for (Cards id in handEntry.value) {
      hand.addCard(Deck().cards.firstWhere((element) => element.id == id));
    }
    var ablageEntry = map.entries.last;
    Ablage ablage = Ablage();
    for (Cards id in ablageEntry.value) {
      ablage.addCard(Deck().cards.firstWhere((c) => c.id == id));
    }
    Game game = Game(hand, ablage);
    game.id = id;
    game.maxSum = handEntry.key;
    return game;
  }

  static Box<Map<int, List<Cards>>> getGamesBox() {
    return Hive.box('games');
  }

  void calculateSum() {
    _hand.resetActivationState();
    for (var key in _hand.cards) {
      key.aufheben(this);
    }
    for (var key in _hand.cards) {
      key.block(this);
    }
    for (var key in _hand.cards) {
      key.block(this);
    }
    sum = _hand.activeCards.fold(0, (previousValue, card) => previousValue + card.calculateStrength(this));
  }

  void addCardsHandByID(List<Cards> ids) {
    for (Cards id in ids) {
      _hand.addCard(Deck().cards.firstWhere((element) => element.id == id));
    }
    calculateSum();
    save();
  }

  void addCardsAblageByID(List<Cards> ids) {
    for (Cards id in ids) {
      _ablage.addCard(Deck().cards.firstWhere((element) => element.id == id));
    }
    calculateSum();
    save();
  }

  void addCardHandByID(Cards id) {
    _hand.addCard(Deck().cards.firstWhere((element) => element.id == id));
    calculateSum();
    save();
  }

  void addCardAblageByID(Cards id) {
    _ablage.addCard(Deck().cards.firstWhere((c) => c.id == id));
    calculateSum();
    save();
  }

  void removeCardHand(Card card) {
    _hand.removeCard(card);
    calculateSum();
    save();
  }

  void removeCardAblage(Card card) {
    _ablage.removeCard(card);
    calculateSum();
    save();
  }

  int get lengthHand {
    return _hand.length;
  }

  int get lengthAblage {
    return _ablage.length;
  }

  Iterable<Card> get cardsHand {
    return _hand.cards;
  }

  Iterable<Card> get cardsAblage {
    return _ablage.cards;
  }

  bool isVisibleHand(Card card) {
    return _hand.isVisible(card);
  }

  bool isVisibleAblage(Card card) {
    return _ablage.isVisible(card);
  }

  bool isActiveHand(Card card) {
    return _hand.isActive(card);
  }

  int bonus(Card card) {
    return card.bonus(this);
  }

  int penalty(Card card) {
    return card.penalty(this);
  }

  int strength(Card card) {
    return card.calculateStrength(this);
  }

  void resetHand() {
    _hand.reset();
    calculateSum();
  }

  void setVisibleHand(Card card, bool visible) {
    _hand.setVisible(card, visible);
  }

  void setVisibleAblage(Card card, bool visible) {
    _ablage.setVisible(card, visible);
  }

  void removeAllHand() {
    for (Card card in _hand.cards) {
      _hand.removeCard(card);
    }
  }

  /// returns the number of cards that are allowed in the current hand
  int maxCardsHand() {
    int size = 7;
    if (cardsHand.map((e) => e.id).contains(Cards.totenbeschwoerer)) size++;
    if (Settings.getInstance().isExpansion) size++;
    if (cardsHand.map((e) => e.id).contains(Cards.kobold)) size++;
    return size;
  }

  static List<Game> games() {
    List<Game> list = [];
    for (var id in getGamesBox().keys) {
      var map = getGamesBox().get(id)!;
      list.add(parseMap(map, id));
    }
    return list;
  }

  Future<void> executeAction(BuildContext context, Card card) async {
    await card.executeAction(context, this);
    calculateSum();
    save();
  }

  void delete() {
    getGamesBox().delete(id);
  }

  Iterable<Card> get activeCards {
    return _hand.activeCards;
  }

  void blockCard(Card card) {
    _hand.blockCard(card);
  }

  void setUnblockable(Card card) {
    _hand.setUnblockable(card);
  }
}
