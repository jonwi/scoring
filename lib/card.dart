import 'dart:collection';

import 'package:flutter/material.dart';

class Deck {
  List<Card> cards = [
    Card('König', CardType.Leader, false, 8, (deck) {}, (deck) {
      var aDeck = activeDeck(deck);
      if (contains(aDeck, 'Königin')) {
        return amountOf(aDeck, {CardType.Army}) * 20;
      } else {
        return amountOf(aDeck, {CardType.Army}) * 8;
      }
    }),
    Card('Königin', CardType.Leader, false, 6, (deck) {}, (deck) {
      var aDeck = activeDeck(deck);
      if (contains(aDeck, 'König')) {
        return amountOf(aDeck, {CardType.Army}) * 20;
      } else {
        return amountOf(aDeck, {CardType.Army}) * 8;
      }
    }),
    Card('Prinzessin', CardType.Leader, false, 2, (deck) {}, (deck) {
      var aDeck = activeDeck(deck);
      return 8 * amountOf(aDeck, {CardType.Army, CardType.Wizard, CardType.Leader});
    }),
    Card('Kriegsherr', CardType.Leader, false, 4, (deck) {}, (deck) {
      var aDeck = activeDeck(deck);
      return aDeck
          .where((card) => card._cardType == CardType.Army)
          .fold<int>(0, (prev, card) => prev + card._baseStrength);
    }),
    Card('Kaiserin', CardType.Leader, false, 15, (deck) {}, (deck) {
      int sum = 0;
      sum += 10 * amountOf(activeDeck(deck), {CardType.Army});
      sum -= 5 * amountOf(activeDeck(deck), {CardType.Leader});
      if (contains(activeDeck(deck), 'Kaiserin')) {
        sum += 5;
      }
      return sum;
    }),
    Card('Ritter', CardType.Army, false, 20, (deck) {}, (deck) {
      if (amountOf(activeDeck(deck), {CardType.Leader}) > 0) {
        return 0;
      }
      return -8;
    }),
    Card('Elbenschützen', CardType.Army, false, 10, (deck) {}, (deck) {
      if (amountOf(activeDeck(deck), {CardType.Weather}) == 0) {
        return 5;
      }
      return 0;
    }),
    Card('Leichte Kavallerie', CardType.Army, false, 17, (deck) {}, (deck) {
      return amountOf(activeDeck(deck), {CardType.Land}) * -2;
    }),
    Card('Zwergeninfanterie', CardType.Army, false, 15, (deck) {}, (deck) {
      if (contains(activeDeck(deck), 'Waldläufer')) return 0;
      return activeDeck(deck)
              .where((element) => element._cardType == CardType.Army && element._name != 'Zwergeninfanterie')
              .length *
          -2;
    }),
    Card('Waldläufer', CardType.Army, false, 5, (deck) {}, (deck) {
      return amountOf(activeDeck(deck), {CardType.Land}) * 10;
    }),
    Card('Schild von Keth', CardType.Artifact, false, 4, (deck) {}, (deck) {
      if (amountOf(activeDeck(deck), {CardType.Leader}) > 0) {
        if (contains(activeDeck(deck), 'Schwert von Keth')) {
          return 40;
        } else {
          return 15;
        }
      }
      return 0;
    }),
    Card('Juwel der Ordnung', CardType.Artifact, false, 5, (deck) {}, (deck) {
      // TODO: hier muss nochgemacht werden
      return 0;
    }),
    Card('Weltenbaum', CardType.Artifact, false, 2, (deck) {}, (deck) {
      return 0;
    }),
    Card('Buch der Veränderung', CardType.Artifact, true, 3, (deck) {}, (deck) {
      return 0;
    }),
    Card('Rune des Schutzes', CardType.Artifact, false, 1, (deck) {
      for (var key in deck.keys) {
        deck[key] = true;
      } // TODO: wahrscheinlich muss statt bool ein tristate gemacht werden
    }, (deck) {
      return 0;
    }),
    Card('Einhorn', CardType.Beast, false, 9, (deck) {}, (deck) {
      var aDeck = activeDeck(deck);
      if (contains(aDeck, 'Prinzessin')) {
        return 40;
      }
      if (contains(aDeck, 'Königin') || contains(aDeck, 'Kaiserin') || contains(aDeck, 'Magierin')) {
        return 15;
      }
      return 0;
    }),
    Card('Basilisk', CardType.Beast, false, 35, (deck) {
      for (var card in deck.keys) {
        if ({CardType.Beast, CardType.Leader, CardType.Army}.contains(card._cardType) &&
            card._name != 'Basilisk') {
          if (deck[card] == null) {
            deck[card] = false;
          }
        }
      }
    }, (deck) {
      return 0;
    }),
    Card('Schlachtenross', CardType.Beast, false, 6, (deck) {}, (deck) {
      if (amountOf(activeDeck(deck), {CardType.Leader, CardType.Wizard}) > 0) {
        return 15;
      }
      return 0;
    }),
    Card('Drache', CardType.Beast, false, 30, (deck) {}, (deck) {
      if (amountOf(activeDeck(deck), {CardType.Wizard}) > 0) {
        return 0;
      }
      return -40;
    }),
    Card('Hydra', CardType.Beast, false, 12, (deck) {}, (deck) {
      if (contains(activeDeck(deck), 'Sumpf')) {
        return 28;
      }
      return 0;
    }),
    Card('Buschfeuer', CardType.Flame, false, 40, (deck) {
      for (var card in deck.keys) {
        if ({CardType.Flame, CardType.Wizard, CardType.Weather, CardType.Weapon, CardType.Artifact}
                .contains(card._cardType) ||
            card._name == 'Gebirge' ||
            card._name == 'Grosse Flut' ||
            card._name == 'Insel' ||
            card._name == 'Einhorn' ||
            card._name == 'Drache' ||
            card._name == 'Buschfeuer') {
          // Eigentlich muss die Bedingung negiert werden, so ist es aber einfacher
        } else {
          if (deck[card] == null) {
            deck[card] = false;
          }
        }
      }
    }, (deck) {
      return 0;
    }),
    Card('Kerze', CardType.Flame, false, 2, (deck) {}, (deck) {
      var aDeck = activeDeck(deck);
      if (contains(aDeck, 'Buch der Veränderung') &&
          contains(aDeck, 'Glockenturm') &&
          amountOf(aDeck, {CardType.Wizard}) > 0) {
        return 100;
      }
      return 0;
    }),
    Card('Schmiede', CardType.Flame, false, 9, (deck) {}, (deck) {
      return amountOf(activeDeck(deck), {CardType.Weapon, CardType.Artifact}) * 9;
    }),
    Card('Blitz', CardType.Flame, false, 11, (deck) {}, (deck) {
      if (contains(activeDeck(deck), 'Regensturm')) {
        return 30;
      }
      return 0;
    }),
    Card('Feuerwesen', CardType.Flame, false, 4, (deck) {}, (deck) {
      return amountOf(activeDeck(deck), {CardType.Flame}) * 15 -
          countNames(activeDeck(deck), 'Feuerwesen') * 15;
    }),
    Card('Quelle des Lebens', CardType.Flood, false, 1, (deck) {}, (deck) {
      var aDeck = activeDeck(deck);
      return aDeck
          .where((card) => {CardType.Weapon, CardType.Flood, CardType.Flame, CardType.Land, CardType.Weather}
              .contains(card._cardType))
          .fold<int>(0, (prev, card) => prev > card._baseStrength ? prev : card._baseStrength);
    }),
    Card('Sumpf', CardType.Flood, false, 18, (deck) {}, (deck) {
      var aDeck = activeDeck(deck);

      if (contains(aDeck, 'Waldläufer')) {
        return -3 * amountOf(aDeck, {CardType.Flame});
      } else {
        return -3 * amountOf(aDeck, {CardType.Flame, CardType.Army});
      }
    }),
    Card('Grosse Flut', CardType.Flood, false, 32, (deck) {
      for (var card in deck.keys) {
        if (contains(activeDeck(deck), 'Waldläufer')) {
          if ({CardType.Land, CardType.Flame}.contains(card._cardType)) {
            if (card._name != 'Gebirge' || card._name != 'Blitz') {
              if (deck[card] == null) {
                deck[card] = false;
              }
            }
          }
        } else {
          if ({CardType.Army, CardType.Land, CardType.Flame}.contains(card._cardType)) {
            if (card._name != 'Gebirge' || card._name != 'Blitz') {
              if (deck[card] == null) {
                deck[card] = false;
              }
            }
          }
        }
      }
    }, (deck) {
      return 0;
    }),
    Card('Insel', CardType.Flood, true, 14, (deck) {}, (deck) {
      return 0;
    }),
    Card('Wasserwesen', CardType.Flood, false, 4, (deck) {}, (deck) {
      return amountOf(activeDeck(deck), {CardType.Flood}) * 15 -
          countNames(activeDeck(deck), 'Wasserwesen') * 15;
    }),
    Card('Gestaltenwandler', CardType.Wild, true, 0, (deck) {}, (deck) {
      return 0;
    }),
    Card('Spiegelung', CardType.Wild, true, 0, (deck) {}, (deck) {
      return 0;
    }),
    Card('Doppelgänger', CardType.Wild, true, 0, (deck) {}, (deck) {
      return 0;
    }),
    Card('Gebirge', CardType.Land, false, 9, (deck) {
      for (var card in deck.keys) {
        if (card._cardType == CardType.Flood) {
          deck[card] = true;
        }
      }
    }, (deck) {
      var aDeck = activeDeck(deck);
      if (contains(aDeck, 'Rauch') && contains(aDeck, 'Buschfeuer')) {
        return 50;
      }
      return 0;
    }),
    Card('Höhle', CardType.Land, false, 6, (deck) {
      for (var card in deck.keys) {
        if (card._cardType == CardType.Weather) {
          deck[card] = true;
        }
      }
    }, (deck) {
      var aDeck = activeDeck(deck);
      if (contains(aDeck, 'Zwergeninfanterie') || contains(aDeck, 'Drache')) {
        return 25;
      }
      return 0;
    }),
    Card('Glockenturm', CardType.Land, false, 8, (deck) {}, (deck) {
      if (amountOf(activeDeck(deck), {CardType.Wizard}) > 0) {
        return 15;
      }
      return 0;
    }),
    Card('Wald', CardType.Land, false, 7, (deck) {}, (deck) {
      return amountOf(activeDeck(deck), {CardType.Beast}) * 12 +
          (contains(activeDeck(deck), 'Waldläufer') ? 12 : 0);
    }),
    Card('Erdwesen', CardType.Land, false, 4, (deck) {}, (deck) {
      return amountOf(activeDeck(deck), {CardType.Land}) * 15 - countNames(activeDeck(deck), 'Erdwesen') * 15;
    }),
    Card('Kriegsschiff', CardType.Weapon, false, 23, (deck) {
      if (!deckContainsType(deck, CardType.Flood)) {
        deck.keys.where((element) => element._name == 'Kriegsschiff').forEach((element) {
          if (deck[element] == null) {
            deck[element] = false;
          }
        });
      }
    }, (deck) {
      return 0;
    }),
    Card('Zauberstab', CardType.Weapon, false, 1, (deck) {}, (deck) {
      if (amountOf(activeDeck(deck), {CardType.Wizard}) > 0) {
        return 25;
      }
      return 0;
    }),
    Card('Schwert von Keth', CardType.Weapon, false, 7, (deck) {}, (deck) {
      if (amountOf(activeDeck(deck), {CardType.Leader}) > 0) {
        if (contains(activeDeck(deck), 'Schild von Keth')) {
          return 40;
        } else {
          return 10;
        }
      }
      return 0;
    }),
    Card('Elbischer Bogen', CardType.Weapon, false, 3, (deck) {}, (deck) {
      var aDeck = activeDeck(deck);
      if (contains(aDeck, 'Elbenschützen') ||
          contains(aDeck, 'Kriegsherr') ||
          contains(aDeck, 'Herr der Bestien')) {
        return 30;
      }
      return 0;
    }),
    Card('Kampfzeppelin', CardType.Weapon, false, 35, (deck) {
      if (deck.keys.where((element) => element._cardType == CardType.Army).isEmpty ||
          deck.keys.where((card) => card._cardType == CardType.Weather).isNotEmpty) {
        for (var card in deck.keys) {
          if (card._name == 'Kampfzeppelin') {
            if (deck[card] == null) {
              deck[card] = false;
            }
          }
        }
      }
    }, (deck) {
      return 0;
    }),
    Card('Regensturm', CardType.Weather, false, 8, (deck) {
      for (var card in deck.keys) {
        if (card._cardType == CardType.Flame && card._name != 'Blitz') {
          if (deck[card] == null) {
            deck[card] = false;
          }
        }
      }
    }, (deck) {
      return amountOf(activeDeck(deck), {CardType.Flood}) * 10;
    }),
    Card('Blizzard', CardType.Weather, false, 30, (deck) {
      for (var card in deck.keys) {
        if (card._cardType == CardType.Flood) {
          if (deck[card] == null) {
            deck[card] = false;
          }
        }
      }
    }, (deck) {
      if (contains(activeDeck(deck), 'Waldläufer')) {
        return amountOf(activeDeck(deck), {CardType.Leader, CardType.Beast, CardType.Flame}) * -5;
      } else {
        return amountOf(activeDeck(deck), {CardType.Army, CardType.Leader, CardType.Beast, CardType.Flame}) *
            -5;
      }
    }),
    Card('Rauch', CardType.Weather, false, 27, (deck) {
      if (deck.keys.where((card) => card._cardType == CardType.Flame).isEmpty) {
        for (var card in deck.keys) {
          if (card._name == 'Flamme') {
            if (deck[card] == null) {
              deck[card] = false;
            }
          }
        }
      }
    }, (deck) {
      return 0;
    }),
    Card('Wirbelsturm', CardType.Weather, false, 13, (deck) {}, (deck) {
      var aDeck = activeDeck(deck);
      if (contains(aDeck, 'Regensturm') && (contains(aDeck, 'Blizzard') || contains(aDeck, 'Grosse Flut'))) {
        return 40;
      }
      return 0;
    }),
    Card('Luftwesen', CardType.Weather, false, 4, (deck) {}, (deck) {
      return amountOf(activeDeck(deck), {CardType.Weather}) * 15 -
          countNames(activeDeck(deck), 'Luftwesen') * 15;
    }),
    Card('Sammler', CardType.Wizard, false, 7, (deck) {}, (deck) {
      int max = activeDeck(deck)
          .map((card) => card._cardType)
          .fold<Map<CardType, int>>(HashMap<CardType, int>(), (map, type) {
            map.putIfAbsent(type, () => 0);
            map[type] = map[type]! + 1;
            return map;
          })
          .entries
          .fold<MapEntry<CardType, int>>(const MapEntry(CardType.Wizard, 0),
              (entry, current) => current.value >= entry.value ? current : entry)
          .value;
      if (max >= 5) {
        return 100;
      } else if (max == 4) {
        return 40;
      } else if (max == 3) {
        return 10;
      }
      return 0;
    }),
    Card('Herr der Bestien', CardType.Wizard, false, 9, (deck) {
      for (var card in deck.keys) {
        if (card._cardType == CardType.Beast) {
          deck[card] = true;
        }
      }
    }, (deck) {
      return amountOf(activeDeck(deck), {CardType.Beast}) * 9;
    }),
    Card('Totenbeschwörer', CardType.Wizard, false, 3, (deck) {}, (deck) {
      return 0;
    }),
    Card('Hexenmeister', CardType.Wizard, false, 25, (deck) {}, (deck) {
      return amountOf(activeDeck(deck), {CardType.Leader, CardType.Wizard}) * -10;
    }),
    Card('Magierin', CardType.Wizard, false, 5, (deck) {}, (deck) {
      return amountOf(activeDeck(deck), {CardType.Land, CardType.Flood, CardType.Weather, CardType.Flame}) *
          5;
    }),
    Card('Hofnarr', CardType.Wizard, false, 3, (deck) {}, (deck) {
      if (activeDeck(deck).where((card) => card._baseStrength % 2 == 0).isEmpty) {
        return 50;
      }
      return activeDeck(deck).where((card) => card._baseStrength % 2 == 1).length * 3;
    }),
  ];
}

bool contains(Iterable<Card> aDeck, String s) {
  return aDeck.map((e) => e._name).contains(s);
}

Iterable<Card> activeDeck(Map<Card, bool?> deck) {
  return deck.keys.where((card) => deck[card] ?? true);
}

bool deckContainsType(Map<Card, bool?> deck, CardType type) {
  return deck.keys.where((card) => deck[card] ?? true && card._cardType == type).isNotEmpty;
}

int amountOf(Iterable<Card> aDeck, Iterable<CardType> set) {
  return aDeck.fold<int>(0, (prev, card) => set.contains(card._cardType) ? 1 + prev : prev);
}

int countNames(Iterable<Card> aDeck, String name) {
  return aDeck.where((element) => element.name == name).fold<int>(0, (prev, cur) => prev + 1);
}

enum CardType { Weather, Wizard, Weapon, Land, Wild, Flood, Flame, Army, Artifact, Leader, Beast }

extension CardTypeExtension on CardType {
  String get name {
    switch (this) {
      case CardType.Weather:
        return 'Wetter';
      case CardType.Wizard:
        return 'Zauberer';
      case CardType.Army:
        return 'Armee';
      case CardType.Weapon:
        return 'Waffe';
      case CardType.Land:
        return 'Land';
      case CardType.Wild:
        return 'Joker';
      case CardType.Flood:
        return 'Flut';
      case CardType.Flame:
        return 'Flamme';
      case CardType.Artifact:
        return 'Artefakt';
      case CardType.Leader:
        return 'Anführer';
      case CardType.Beast:
        return 'Beast';
      default:
        return 'Unbekannter Kartentyp';
    }
  }

  Color get color {
    switch (this) {
      case CardType.Weather:
        return Colors.lightBlueAccent;
      case CardType.Wizard:
        return Colors.purpleAccent;
      case CardType.Army:
        return Colors.black;
      case CardType.Weapon:
        return Colors.grey;
      case CardType.Land:
        return Colors.brown;
      case CardType.Wild:
        return Colors.white;
      case CardType.Flood:
        return Colors.blue;
      case CardType.Flame:
        return Colors.redAccent;
      case CardType.Artifact:
        return Colors.orangeAccent;
      case CardType.Leader:
        return Colors.deepPurple;
      case CardType.Beast:
        return Colors.green;
      default:
        return Colors.white;
    }
  }
}

class Card implements Comparable<Card> {
  final String _name;
  final bool _hasAction;
  final CardType _cardType;
  final int _baseStrength;

  final void Function(Map<Card, bool?>) _block;
  final int Function(Map<Card, bool?>) _bonus;

  Card(this._name, this._cardType, this._hasAction, this._baseStrength, this._block, this._bonus);

  void executeBlock(Map<Card, bool> deck) {
    _block(deck);
  }

  int calculateStrength(Map<Card, bool?> deck) {
    return _baseStrength + _bonus(deck);
  }

  String get name => _name;

  @override
  int compareTo(Card other) {
    return _name.compareTo(other._name);
  }

  bool get hasAction => _hasAction;

  CardType get cardType => _cardType;

  int get baseStrength => _baseStrength;

  Function get block => _block;

  Function get bonus => _bonus;
}
