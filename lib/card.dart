import 'dart:collection';

import 'package:flutter/material.dart';

class Deck {
  List<Card> cards = [
    Card('König', CardType.leader, false, 8, (deck) {}, (deck) {
      var aDeck = activeDeck(deck);
      if (contains(aDeck, 'Königin')) {
        return amountOf(aDeck, {CardType.army}) * 20;
      } else {
        return amountOf(aDeck, {CardType.army}) * 8;
      }
    },
        RichText(
            text: TextSpan(
          style: const TextStyle(color: Colors.black),
          children: [
            const TextSpan(text: '+5 für jede '),
            TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
            const TextSpan(text: '. ODER +20 für jede '),
            TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
            const TextSpan(text: ', wenn zusammen mit '),
            TextSpan(text: 'Königin', style: TextStyle(color: CardType.leader.color)),
            const TextSpan(text: '.')
          ],
        )),
        ActionCards.none),
    Card('Königin', CardType.leader, false, 6, (deck) {}, (deck) {
      var aDeck = activeDeck(deck);
      if (contains(aDeck, 'König')) {
        return amountOf(aDeck, {CardType.army}) * 20;
      } else {
        return amountOf(aDeck, {CardType.army}) * 8;
      }
    },
        RichText(
            text: TextSpan(
          style: const TextStyle(color: Colors.black),
          children: [
            const TextSpan(text: '+5 für jede '),
            TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
            const TextSpan(text: '. ODER +20 für jede '),
            TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
            const TextSpan(text: ', wenn zusammen mit '),
            TextSpan(text: 'König', style: TextStyle(color: CardType.leader.color)),
            const TextSpan(text: '.')
          ],
        )),
        ActionCards.none),
    Card('Prinzessin', CardType.leader, false, 2, (deck) {}, (deck) {
      var aDeck = activeDeck(deck);
      return 8 * amountOf(aDeck, {CardType.army, CardType.wizard, CardType.leader}) -
          countNames(aDeck, 'Prinzessin');
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '+8 für jede '),
          TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
          const TextSpan(text: ', '),
          TextSpan(text: 'Zauberer', style: TextStyle(color: CardType.wizard.color)),
          const TextSpan(text: ' und/oder andere '),
          TextSpan(text: 'Anführer', style: TextStyle(color: CardType.leader.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none),
    Card('Kriegsherr', CardType.leader, false, 4, (deck) {}, (deck) {
      var aDeck = activeDeck(deck);
      return aDeck
          .where((card) => card._cardType == CardType.army)
          .fold<int>(0, (prev, card) => prev + card._baseStrength);
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: 'Die Summe der Basisstärke jeder '),
          TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none),
    Card('Kaiserin', CardType.leader, false, 15, (deck) {}, (deck) {
      int sum = 0;
      sum += 10 * amountOf(activeDeck(deck), {CardType.army});
      sum -= 5 * amountOf(activeDeck(deck), {CardType.leader});
      if (contains(activeDeck(deck), 'Kaiserin')) {
        sum += 5;
      }
      return sum;
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '+10 für jede '),
          TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
          const TextSpan(text: '. -5 für jeden anderen '),
          TextSpan(text: 'Anführer', style: TextStyle(color: CardType.leader.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none),
    Card('Ritter', CardType.army, false, 20, (deck) {}, (deck) {
      if (amountOf(activeDeck(deck), {CardType.leader}) > 0) {
        return 0;
      }
      return -8;
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '-8 wenn ohne '),
          TextSpan(text: 'Anführer', style: TextStyle(color: CardType.leader.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none),
    Card('Elbenschützen', CardType.army, false, 10, (deck) {}, (deck) {
      if (amountOf(activeDeck(deck), {CardType.weather}) == 0) {
        return 5;
      }
      return 0;
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '+5 wenn ohne '),
          TextSpan(text: 'Wetter', style: TextStyle(color: CardType.weather.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none),
    Card('Leichte Kavallerie', CardType.army, false, 17, (deck) {}, (deck) {
      return amountOf(activeDeck(deck), {CardType.land}) * -2;
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '-2 fúr jedes andere '),
          TextSpan(text: 'Land', style: TextStyle(color: CardType.land.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none),
    Card('Zwergeninfanterie', CardType.army, false, 15, (deck) {}, (deck) {
      if (contains(activeDeck(deck), 'Waldläufer')) return 0;
      return activeDeck(deck)
              .where((element) => element._cardType == CardType.army && element._name != 'Zwergeninfanterie')
              .length *
          -2;
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '-2 für jede andere '),
          TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none),
    Card('Waldläufer', CardType.army, false, 5, (deck) {}, (deck) {
      return amountOf(activeDeck(deck), {CardType.land}) * 10;
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '+10 für jedes '),
          TextSpan(text: 'Land', style: TextStyle(color: CardType.land.color)),
          const TextSpan(text: '. HEBT das Wort '),
          TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
          const TextSpan(text: ' von allen Strafen AUF.')
        ])),
        ActionCards.none),
    Card('Schild von Keth', CardType.artifact, false, 4, (deck) {}, (deck) {
      if (amountOf(activeDeck(deck), {CardType.leader}) > 0) {
        if (contains(activeDeck(deck), 'Schwert von Keth')) {
          return 40;
        } else {
          return 15;
        }
      }
      return 0;
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '+15 mit mindestens einem '),
          TextSpan(text: 'Anführer', style: TextStyle(color: CardType.leader.color)),
          const TextSpan(text: '. ODER +40 mit '),
          TextSpan(text: 'Anführer', style: TextStyle(color: CardType.leader.color)),
          const TextSpan(text: ' und '),
          TextSpan(text: 'Schwert von Keth.', style: TextStyle(color: CardType.artifact.color))
        ])),
        ActionCards.none),
    Card('Juwel der Ordnung', CardType.artifact, false, 5, (deck) {}, (deck) {
      // TODO: hier muss nochgemacht werden
      return 0;
    },
        RichText(
            text: const TextSpan(
                style: TextStyle(color: Colors.black),
                text:
                    '+10 für eine "Strasse" von 3 Karten, +30 für 4 Karten, +60 für 5 Karten, + 100 für 6 Karten, +150 für 7 Karten.')),
        ActionCards.none),
    Card('Weltenbaum', CardType.artifact, false, 2, (deck) {}, (deck) {
      return 0; // TODO: hier muss noch geamcht werden
    },
        RichText(
            text: const TextSpan(
                style: TextStyle(color: Colors.black),
                text: '+50 wenn jede Nicht-Blockierte Karte eine unterschiedliche Farbe hat.')),
        ActionCards.none),
    Card('Buch der Veränderung', CardType.artifact, true, 3, (deck) {}, (deck) {
      return 0; //TODO: hier muss noch gemacht werden
    },
        RichText(
            text: const TextSpan(
                style: TextStyle(color: Colors.black),
                text:
                    'Du darfst die Farbe einer anderen Karte verändern. Name, Bonus, Strafe und Basisstärke bleiben unverändert')),
        ActionCards.none),
    Card('Rune des Schutzes', CardType.artifact, false, 1, (deck) {
      for (var key in deck.keys) {
        deck[key]?.activationState = true;
      } // TODO: wahrscheinlich muss statt bool ein tristate gemacht werden
    }, (deck) {
      return 0;
    },
        RichText(
            text: const TextSpan(
                style: TextStyle(color: Colors.black), text: 'HEBT die Strafen auf allen Karten AUF.')),
        ActionCards.none),
    Card('Einhorn', CardType.beast, false, 9, (deck) {}, (deck) {
      var aDeck = activeDeck(deck);
      if (contains(aDeck, 'Prinzessin')) {
        return 40;
      }
      if (contains(aDeck, 'Königin') || contains(aDeck, 'Kaiserin') || contains(aDeck, 'Magierin')) {
        return 15;
      }
      return 0;
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '+30 mit '),
          TextSpan(text: 'Prinzessin', style: TextStyle(color: CardType.leader.color)),
          const TextSpan(text: '. ODER +15 mit'),
          TextSpan(text: 'Kaiserin', style: TextStyle(color: CardType.leader.color)),
          const TextSpan(text: ', '),
          TextSpan(text: 'Königin', style: TextStyle(color: CardType.leader.color)),
          const TextSpan(text: ' oder '),
          TextSpan(text: 'Magierin', style: TextStyle(color: CardType.wizard.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none),
    Card('Basilisk', CardType.beast, false, 35, (deck) {
      for (var card in deck.keys) {
        if ({CardType.beast, CardType.leader, CardType.army}.contains(card._cardType) &&
            card._name != 'Basilisk') {
          if (deck[card]?.activationState == null) {
            deck[card]?.activationState = false;
          }
        }
      }
    }, (deck) {
      return 0;
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: 'BLOCKIERT alle '),
          TextSpan(text: 'Armeen', style: TextStyle(color: CardType.army.color)),
          const TextSpan(text: ', '),
          TextSpan(text: 'Anführer', style: TextStyle(color: CardType.leader.color)),
          const TextSpan(text: ' und andere '),
          TextSpan(text: 'Bestien', style: TextStyle(color: CardType.beast.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none),
    Card('Schlachtenross', CardType.beast, false, 6, (deck) {}, (deck) {
      if (amountOf(activeDeck(deck), {CardType.leader, CardType.wizard}) > 0) {
        return 14;
      }
      return 0;
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '+14 mit mindestens einem'),
          TextSpan(text: 'Anführer', style: TextStyle(color: CardType.leader.color)),
          const TextSpan(text: ' oder '),
          TextSpan(text: 'Zauberer', style: TextStyle(color: CardType.wizard.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none),
    Card('Drache', CardType.beast, false, 30, (deck) {}, (deck) {
      if (amountOf(activeDeck(deck), {CardType.wizard}) > 0) {
        return 0;
      }
      return -40;
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '-40 wenn ohne '),
          TextSpan(text: 'Zauberer', style: TextStyle(color: CardType.wizard.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none),
    Card('Hydra', CardType.beast, false, 12, (deck) {}, (deck) {
      if (contains(activeDeck(deck), 'Sumpf')) {
        return 28;
      }
      return 0;
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '+20 mit '),
          TextSpan(text: 'Sumpf', style: TextStyle(color: CardType.flood.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none),
    Card('Buschfeuer', CardType.flame, false, 40, (deck) {
      for (var card in deck.keys) {
        if ({CardType.flame, CardType.wizard, CardType.weather, CardType.weapon, CardType.artifact}
                .contains(card._cardType) ||
            card._name == 'Gebirge' ||
            card._name == 'Grosse Flut' ||
            card._name == 'Insel' ||
            card._name == 'Einhorn' ||
            card._name == 'Drache' ||
            card._name == 'Buschfeuer') {
          // Eigentlich muss die Bedingung negiert werden, so ist es aber einfacher
        } else {
          if (deck[card]?.activationState == null) {
            deck[card]?.activationState = false;
          }
        }
      }
    }, (deck) {
      return 0;
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: 'BLOCKIERT alle Karten, ausser '),
          TextSpan(text: 'Flammen', style: TextStyle(color: CardType.flame.color)),
          const TextSpan(text: ', '),
          TextSpan(text: 'Zauberer', style: TextStyle(color: CardType.wizard.color)),
          const TextSpan(text: ', '),
          TextSpan(text: 'Wetter', style: TextStyle(color: CardType.weather.color)),
          const TextSpan(text: ', '),
          TextSpan(text: 'Waffen', style: TextStyle(color: CardType.weapon.color)),
          const TextSpan(text: ', '),
          TextSpan(text: 'Artefakte', style: TextStyle(color: CardType.artifact.color)),
          const TextSpan(text: ', '),
          TextSpan(text: 'Gebirge', style: TextStyle(color: CardType.land.color)),
          const TextSpan(text: ', '),
          TextSpan(text: 'Grosse Flut', style: TextStyle(color: CardType.flood.color)),
          const TextSpan(text: ', '),
          TextSpan(text: 'Insel', style: TextStyle(color: CardType.flood.color)),
          const TextSpan(text: ', '),
          TextSpan(text: 'Einhorn', style: TextStyle(color: CardType.beast.color)),
          const TextSpan(text: ' und '),
          TextSpan(text: 'Drache', style: TextStyle(color: CardType.beast.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none),
    Card('Kerze', CardType.flame, false, 2, (deck) {}, (deck) {
      var aDeck = activeDeck(deck);
      if (contains(aDeck, 'Buch der Veränderung') &&
          contains(aDeck, 'Glockenturm') &&
          amountOf(aDeck, {CardType.wizard}) > 0) {
        return 100;
      }
      return 0;
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '+100 mit '),
          TextSpan(text: 'Buch der Veränderung', style: TextStyle(color: CardType.artifact.color)),
          const TextSpan(text: ' und '),
          TextSpan(text: 'Glockenturm', style: TextStyle(color: CardType.land.color)),
          const TextSpan(text: ' sowie mindestens einem '),
          TextSpan(text: 'Zauberer', style: TextStyle(color: CardType.wizard.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none),
    Card('Schmiede', CardType.flame, false, 9, (deck) {}, (deck) {
      return amountOf(activeDeck(deck), {CardType.weapon, CardType.artifact}) * 9;
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '+9 für jede '),
          TextSpan(text: 'Waffe', style: TextStyle(color: CardType.weapon.color)),
          const TextSpan(text: ' und/oder jedes '),
          TextSpan(text: 'Artefakt', style: TextStyle(color: CardType.artifact.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none),
    Card('Blitz', CardType.flame, false, 11, (deck) {}, (deck) {
      if (contains(activeDeck(deck), 'Regensturm')) {
        return 30;
      }
      return 0;
    },
        RichText(
            text: const TextSpan(
                style: TextStyle(color: Colors.black),
                children: [TextSpan(text: '+30 mit '), TextSpan(text: 'Regensturm'), TextSpan(text: '.')])),
        ActionCards.none),
    Card('Feuerwesen', CardType.flame, false, 4, (deck) {}, (deck) {
      return amountOf(activeDeck(deck), {CardType.flame}) * 15 -
          countNames(activeDeck(deck), 'Feuerwesen') * 15;
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '+15 für jede andere '),
          TextSpan(text: 'Flamme', style: TextStyle(color: CardType.flame.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none),
    Card('Quelle des Lebens', CardType.flood, false, 1, (deck) {}, (deck) {
      var aDeck = activeDeck(deck);
      return aDeck
          .where((card) => {CardType.weapon, CardType.flood, CardType.flame, CardType.land, CardType.weather}
              .contains(card._cardType))
          .fold<int>(0, (prev, card) => prev > card._baseStrength ? prev : card._baseStrength);
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: 'Addiere die Basisstärke einer beliebigen '),
          TextSpan(text: 'Waffe', style: TextStyle(color: CardType.weapon.color)),
          const TextSpan(text: ', '),
          TextSpan(text: 'Flut', style: TextStyle(color: CardType.flood.color)),
          const TextSpan(text: ', '),
          TextSpan(text: 'Falmme', style: TextStyle(color: CardType.flame.color)),
          const TextSpan(text: ', '),
          TextSpan(text: 'Land', style: TextStyle(color: CardType.land.color)),
          const TextSpan(text: ' oder '),
          TextSpan(text: 'Wetter', style: TextStyle(color: CardType.weather.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none),
    Card('Sumpf', CardType.flood, false, 18, (deck) {}, (deck) {
      var aDeck = activeDeck(deck);

      if (contains(aDeck, 'Waldläufer')) {
        return -3 * amountOf(aDeck, {CardType.flame});
      } else {
        return -3 * amountOf(aDeck, {CardType.flame, CardType.army});
      }
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '-3 für jede '),
          TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
          const TextSpan(text: ' und/oder '),
          TextSpan(text: 'Flamme', style: TextStyle(color: CardType.flame.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none),
    Card('Grosse Flut', CardType.flood, false, 32, (deck) {
      for (var card in deck.keys) {
        if (contains(activeDeck(deck), 'Waldläufer')) {
          if ({CardType.land, CardType.flame}.contains(card._cardType)) {
            if (card._name != 'Gebirge' || card._name != 'Blitz') {
              if (deck[card]?.activationState == null) {
                deck[card]?.activationState = false;
              }
            }
          }
        } else {
          if ({CardType.army, CardType.land, CardType.flame}.contains(card._cardType)) {
            if (card._name != 'Gebirge' || card._name != 'Blitz') {
              if (deck[card]?.activationState == null) {
                deck[card]?.activationState = false;
              }
            }
          }
        }
      }
    }, (deck) {
      return 0;
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: 'BLOCKIERT alle '),
          TextSpan(text: 'Armeen', style: TextStyle(color: CardType.army.color)),
          const TextSpan(text: ', alle '),
          TextSpan(text: 'Länder', style: TextStyle(color: CardType.land.color)),
          const TextSpan(text: ', ausser '),
          TextSpan(text: 'Gebirge', style: TextStyle(color: CardType.land.color)),
          const TextSpan(text: ' und alle '),
          TextSpan(text: 'Flammen', style: TextStyle(color: CardType.flame.color)),
          const TextSpan(text: ' ausser '),
          TextSpan(text: 'Blitz', style: TextStyle(color: CardType.flame.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none),
    Card('Insel', CardType.flood, true, 14, (deck) {}, (deck) {
      return 0;
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: 'HEBT die Strafe einer beliebigen '),
          TextSpan(text: 'Flut', style: TextStyle(color: CardType.flood.color)),
          const TextSpan(text: ' oder '),
          TextSpan(text: 'Flamme', style: TextStyle(color: CardType.flame.color)),
          const TextSpan(text: ' AUF.')
        ])),
        ActionCards.none),
    Card('Wasserwesen', CardType.flood, false, 4, (deck) {}, (deck) {
      return amountOf(activeDeck(deck), {CardType.flood}) * 15 -
          countNames(activeDeck(deck), 'Wasserwesen') * 15;
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '+15 für jede andere '),
          TextSpan(text: 'Flut', style: TextStyle(color: CardType.flood.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none),
    Card('Gestaltenwandler', CardType.wild, true, 0, (deck) {}, (deck) {
      return 0;
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: 'Kann Namen und Farbe eines beliebigen '),
          TextSpan(text: 'Artefakts', style: TextStyle(color: CardType.artifact.color)),
          const TextSpan(text: ', '),
          TextSpan(text: 'Anführers', style: TextStyle(color: CardType.leader.color)),
          const TextSpan(text: ', '),
          TextSpan(text: 'Zauberers', style: TextStyle(color: CardType.wizard.color)),
          const TextSpan(text: ', '),
          TextSpan(text: 'Waffe', style: TextStyle(color: CardType.weapon.color)),
          const TextSpan(text: ' oder '),
          TextSpan(text: 'Bestie', style: TextStyle(color: CardType.beast.color)),
          const TextSpan(
              text:
                  ' des Spiels kopieren. Übernimmt nicht Bonus, Strafen oder Basisstärke der entsprechenden Karte.')
        ])),
        ActionCards.gestaltwandler),
    Card('Spiegelung', CardType.wild, true, 0, (deck) {}, (deck) {
      return 0;
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: 'Kann Namen und Farbe einer beliebigen '),
          TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
          const TextSpan(text: ', '),
          TextSpan(text: 'Land', style: TextStyle(color: CardType.land.color)),
          const TextSpan(text: ', '),
          TextSpan(text: 'Wetter', style: TextStyle(color: CardType.weather.color)),
          const TextSpan(text: ', '),
          TextSpan(text: 'Flut', style: TextStyle(color: CardType.flood.color)),
          const TextSpan(text: ' oder '),
          TextSpan(text: 'Flamme', style: TextStyle(color: CardType.flame.color)),
          const TextSpan(
              text:
                  ' im Spiel kopieren. Übernimmt nicht Bonus, Strafen oder Basisstärke der entsprechenden Karte.')
        ])),
        ActionCards.spiegelung),
    Card('Doppelgänger', CardType.wild, true, 0, (deck) {}, (deck) {
      return 0;
    },
        RichText(
            text: const TextSpan(
                text:
                    'Kann Namen, Basisstärke, Farbe und Strafe ABER NICHT DEN BONUS einer anderen Karte in deiner Hand kopieren.')),
        ActionCards.none),
    Card('Gebirge', CardType.land, false, 9, (deck) {
      for (var card in deck.keys) {
        if (card._cardType == CardType.flood) {
          deck[card]?.activationState = true;
        }
      }
    }, (deck) {
      var aDeck = activeDeck(deck);
      if (contains(aDeck, 'Rauch') && contains(aDeck, 'Buschfeuer')) {
        return 50;
      }
      return 0;
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '+50 mit '),
          TextSpan(text: 'Rauch', style: TextStyle(color: CardType.weather.color)),
          const TextSpan(text: ' und '),
          TextSpan(text: 'Buschfeuer', style: TextStyle(color: CardType.flame.color)),
          const TextSpan(text: '. HEBT die Strafe auf allen '),
          TextSpan(text: 'Fluten', style: TextStyle(color: CardType.flood.color)),
          const TextSpan(text: ' AUF.')
        ])),
        ActionCards.none),
    Card('Höhle', CardType.land, false, 6, (deck) {
      for (var card in deck.keys) {
        if (card._cardType == CardType.weather) {
          deck[card]?.activationState = true;
        }
      }
    }, (deck) {
      var aDeck = activeDeck(deck);
      if (contains(aDeck, 'Zwergeninfanterie') || contains(aDeck, 'Drache')) {
        return 25;
      }
      return 0;
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '+25 mit '),
          TextSpan(text: 'Zwergeninfanterie', style: TextStyle(color: CardType.army.color)),
          const TextSpan(text: ' oder '),
          TextSpan(text: 'Drache', style: TextStyle(color: CardType.beast.color)),
          const TextSpan(text: '. HEBT die Strafe auf allen '),
          TextSpan(text: 'Wettern', style: TextStyle(color: CardType.weather.color)),
          const TextSpan(text: ' AUF.')
        ])),
        ActionCards.none),
    Card('Glockenturm', CardType.land, false, 8, (deck) {}, (deck) {
      if (amountOf(activeDeck(deck), {CardType.wizard}) > 0) {
        return 15;
      }
      return 0;
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '+15 mit mindestens einem '),
          TextSpan(text: 'Zauberer', style: TextStyle(color: CardType.wizard.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none),
    Card('Wald', CardType.land, false, 7, (deck) {}, (deck) {
      return amountOf(activeDeck(deck), {CardType.beast}) * 12 +
          (contains(activeDeck(deck), 'Waldläufer') ? 12 : 0);
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '+12 für jede '),
          TextSpan(text: 'Bestie', style: TextStyle(color: CardType.beast.color)),
          const TextSpan(text: ' und/oder '),
          TextSpan(text: 'Elbenschützen', style: TextStyle(color: CardType.army.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none),
    Card('Erdwesen', CardType.land, false, 4, (deck) {}, (deck) {
      return amountOf(activeDeck(deck), {CardType.land}) * 15 - countNames(activeDeck(deck), 'Erdwesen') * 15;
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '+15 für jedes andere '),
          TextSpan(text: 'Land', style: TextStyle(color: CardType.land.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none),
    Card('Kriegsschiff', CardType.weapon, false, 23, (deck) {
      if (!deckContainsType(deck, CardType.flood)) {
        deck.keys.where((element) => element._name == 'Kriegsschiff').forEach((element) {
          if (deck[element]?.activationState == null) {
            deck[element]?.activationState = false;
          }
        });
      }
    }, (deck) {
      return 0;
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: 'HEBT das Wort '),
          TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
          const TextSpan(text: ' von allen Strafen auf allen '),
          TextSpan(text: 'Fluten', style: TextStyle(color: CardType.flood.color)),
          const TextSpan(text: ' AUF.')
        ])),
        ActionCards.none),
    Card('Zauberstab', CardType.weapon, false, 1, (deck) {}, (deck) {
      if (amountOf(activeDeck(deck), {CardType.wizard}) > 0) {
        return 25;
      }
      return 0;
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '+25 mit mindestens einem '),
          TextSpan(text: 'Zauberer', style: TextStyle(color: CardType.wizard.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none),
    Card('Schwert von Keth', CardType.weapon, false, 7, (deck) {}, (deck) {
      if (amountOf(activeDeck(deck), {CardType.leader}) > 0) {
        if (contains(activeDeck(deck), 'Schild von Keth')) {
          return 40;
        } else {
          return 10;
        }
      }
      return 0;
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '+10 mit mindestens einem '),
          TextSpan(text: 'Anführer', style: TextStyle(color: CardType.leader.color)),
          const TextSpan(text: '. ODER +40 mit '),
          TextSpan(text: 'Anführer', style: TextStyle(color: CardType.leader.color)),
          const TextSpan(text: ' und '),
          TextSpan(text: 'Schild von Keth', style: TextStyle(color: CardType.artifact.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none),
    Card('Elbischer Bogen', CardType.weapon, false, 3, (deck) {}, (deck) {
      var aDeck = activeDeck(deck);
      if (contains(aDeck, 'Elbenschützen') ||
          contains(aDeck, 'Kriegsherr') ||
          contains(aDeck, 'Herr der Bestien')) {
        return 30;
      }
      return 0;
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '+30 mit '),
          TextSpan(text: 'Elbenschützen', style: TextStyle(color: CardType.army.color)),
          const TextSpan(text: ', '),
          TextSpan(text: 'Kriegsherr', style: TextStyle(color: CardType.leader.color)),
          const TextSpan(text: ' oder '),
          TextSpan(text: 'Herr der Bestien', style: TextStyle(color: CardType.wizard.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none),
    Card('Kampfzeppelin', CardType.weapon, false, 35, (deck) {
      if (deck.keys.where((element) => element._cardType == CardType.army).isEmpty ||
          deck.keys.where((card) => card._cardType == CardType.weather).isNotEmpty) {
        for (var card in deck.keys) {
          if (card._name == 'Kampfzeppelin') {
            if (deck[card]?.activationState == null) {
              deck[card]?.activationState = false;
            }
          }
        }
      }
    }, (deck) {
      return 0;
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: 'Ist BLOCKIERT wenn ohne '),
          TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
          const TextSpan(text: '. Ist BLOCKIERT wenn zusammen mit '),
          TextSpan(text: 'Wetter', style: TextStyle(color: CardType.weather.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none),
    Card('Regensturm', CardType.weather, false, 8, (deck) {
      for (var card in deck.keys) {
        if (card._cardType == CardType.flame && card._name != 'Blitz') {
          if (deck[card]?.activationState == null) {
            deck[card]?.activationState = false;
          }
        }
      }
    }, (deck) {
      return amountOf(activeDeck(deck), {CardType.flood}) * 10;
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '+10 für jede '),
          TextSpan(text: 'Flut', style: TextStyle(color: CardType.flood.color)),
          const TextSpan(text: '. BLOCKIERT alle '),
          TextSpan(text: 'Flammen', style: TextStyle(color: CardType.flame.color)),
          const TextSpan(text: ', ausser '),
          TextSpan(text: 'Blitz', style: TextStyle(color: CardType.flame.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none),
    Card('Blizzard', CardType.weather, false, 30, (deck) {
      for (var card in deck.keys) {
        if (card._cardType == CardType.flood) {
          if (deck[card]?.activationState == null) {
            deck[card]?.activationState = false;
          }
        }
      }
    }, (deck) {
      if (contains(activeDeck(deck), 'Waldläufer')) {
        return amountOf(activeDeck(deck), {CardType.leader, CardType.beast, CardType.flame}) * -5;
      } else {
        return amountOf(activeDeck(deck), {CardType.army, CardType.leader, CardType.beast, CardType.flame}) *
            -5;
      }
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '-5 für jede '),
          TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
          const TextSpan(text: ', '),
          TextSpan(text: 'Anführer', style: TextStyle(color: CardType.leader.color)),
          const TextSpan(text: ', '),
          TextSpan(text: 'Bestie', style: TextStyle(color: CardType.beast.color)),
          const TextSpan(text: ' und/oder '),
          TextSpan(text: 'Flamme', style: TextStyle(color: CardType.flame.color)),
          const TextSpan(text: '. BLOCKIERT alle '),
          TextSpan(text: 'Fluten', style: TextStyle(color: CardType.flood.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none),
    Card('Rauch', CardType.weather, false, 27, (deck) {
      if (deck.keys.where((card) => card._cardType == CardType.flame).isEmpty) {
        for (var card in deck.keys) {
          if (card._name == 'Flamme') {
            if (deck[card]?.activationState == null) {
              deck[card]?.activationState = false;
            }
          }
        }
      }
    }, (deck) {
      return 0;
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: 'Ist BLOCKIERT wenn ohne '),
          TextSpan(text: 'Flamme', style: TextStyle(color: CardType.flame.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none),
    Card('Wirbelsturm', CardType.weather, false, 13, (deck) {}, (deck) {
      var aDeck = activeDeck(deck);
      if (contains(aDeck, 'Regensturm') && (contains(aDeck, 'Blizzard') || contains(aDeck, 'Grosse Flut'))) {
        return 40;
      }
      return 0;
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '+40 mit '),
          TextSpan(text: 'Regensturm', style: TextStyle(color: CardType.weather.color)),
          const TextSpan(text: ' und entweder '),
          TextSpan(text: 'Blizzard', style: TextStyle(color: CardType.weather.color)),
          const TextSpan(text: ' oder '),
          TextSpan(text: 'Grosse Flut', style: TextStyle(color: CardType.flood.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none),
    Card('Luftwesen', CardType.weather, false, 4, (deck) {}, (deck) {
      return amountOf(activeDeck(deck), {CardType.weather}) * 15 -
          countNames(activeDeck(deck), 'Luftwesen') * 15;
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '+15 für jedes andere '),
          TextSpan(text: 'Wetter', style: TextStyle(color: CardType.weather.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none),
    Card('Sammler', CardType.wizard, false, 7, (deck) {}, (deck) {
      int max = activeDeck(deck) // TODO: es dürfen nur unterschiedliche Karten sein.
          .map((card) => card._cardType)
          .fold<Map<CardType, int>>(HashMap<CardType, int>(), (map, type) {
            map.putIfAbsent(type, () => 0);
            map[type] = map[type]! + 1;
            return map;
          })
          .entries
          .fold<MapEntry<CardType, int>>(const MapEntry(CardType.wizard, 0),
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
    },
        RichText(
            text: const TextSpan(
                style: TextStyle(color: Colors.black),
                text:
                    '+10 für drei unterschiedliche Karten der gleichen Farbe, +40 für vier Karten der gleichen Farbe, +100 für fünf unterschiedliche Karten der gleichen Farbe')),
        ActionCards.none),
    Card('Herr der Bestien', CardType.wizard, false, 9, (deck) {
      for (var card in deck.keys) {
        if (card._cardType == CardType.beast) {
          deck[card]?.activationState = true;
        }
      }
    }, (deck) {
      return amountOf(activeDeck(deck), {CardType.beast}) * 9;
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '+9 für jede '),
          TextSpan(text: 'Bestie', style: TextStyle(color: CardType.beast.color)),
          const TextSpan(text: '. HEBT die Strafen auf allen '),
          TextSpan(text: 'Bestien', style: TextStyle(color: CardType.beast.color)),
          const TextSpan(text: ' AUF.')
        ])),
        ActionCards.none),
    Card('Totenbeschwörer', CardType.wizard, false, 3, (deck) {}, (deck) {
      return 0;
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: 'Du darfst am Spielende einer '),
          TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
          const TextSpan(text: ', '),
          TextSpan(text: 'Anführer', style: TextStyle(color: CardType.leader.color)),
          const TextSpan(text: ', '),
          TextSpan(text: 'Zauberer', style: TextStyle(color: CardType.wizard.color)),
          const TextSpan(text: ' oder '),
          TextSpan(text: 'Bestie', style: TextStyle(color: CardType.beast.color)),
          const TextSpan(text: ' aus dem Ablagefach nehmen und sie als Karte deiner Hand werten.')
        ])),
        ActionCards.none),
    Card('Hexenmeister', CardType.wizard, false, 25, (deck) {}, (deck) {
      return amountOf(activeDeck(deck), {CardType.leader, CardType.wizard}) * -10 +
          countNames(activeDeck(deck), 'Hexenmeister') * 10;
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '-10 für jeden '),
          TextSpan(text: 'Anführer', style: TextStyle(color: CardType.leader.color)),
          const TextSpan(text: ' und/oder anderen '),
          TextSpan(text: 'Zauberer', style: TextStyle(color: CardType.wizard.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none),
    Card('Magierin', CardType.wizard, false, 5, (deck) {}, (deck) {
      return amountOf(activeDeck(deck), {CardType.land, CardType.flood, CardType.weather, CardType.flame}) *
          5;
    },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '+5 für jedes '),
          TextSpan(text: 'Land', style: TextStyle(color: CardType.land.color)),
          const TextSpan(text: ', '),
          TextSpan(text: 'Wetter', style: TextStyle(color: CardType.weather.color)),
          const TextSpan(text: ', '),
          TextSpan(text: 'Flut', style: TextStyle(color: CardType.flood.color)),
          const TextSpan(text: ' und/oder '),
          TextSpan(text: 'Flamme', style: TextStyle(color: CardType.flame.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none),
    Card('Hofnarr', CardType.wizard, false, 3, (deck) {}, (deck) {
      if (activeDeck(deck).where((card) => card.name != 'Hofnarr' && card._baseStrength % 2 == 0).isEmpty) {
        return 50;
      }
      return activeDeck(deck).where((card) => card._baseStrength % 2 == 1).length * 3;
    },
        RichText(
            text: const TextSpan(
                style: TextStyle(color: Colors.black),
                text:
                    '+3 für jede andere Karte mit einer ungeraden Basisstärke. ODER +50 wenn alle Karten eine ungerade Basisstärke haben.')),
        ActionCards.none),
  ];
}

bool contains(Iterable<Card> aDeck, String s) {
  return aDeck.map((e) => e._name).contains(s);
}

Iterable<Card> activeDeck(Map<Card, CardState> deck) {
  return deck.keys.where((card) => deck[card]?.activationState ?? true);
}

bool deckContainsType(Map<Card, CardState> deck, CardType type) {
  return deck.keys.where((card) => deck[card]?.activationState ?? true && card._cardType == type).isNotEmpty;
}

int amountOf(Iterable<Card> aDeck, Iterable<CardType> set) {
  return aDeck.fold<int>(0, (prev, card) => set.contains(card._cardType) ? 1 + prev : prev);
}

int countNames(Iterable<Card> aDeck, String name) {
  return aDeck.where((element) => element.name == name).fold<int>(0, (prev, cur) => prev + 1);
}

enum CardType { weather, wizard, weapon, land, wild, flood, flame, army, artifact, leader, beast }

extension CardTypeExtension on CardType {
  String get name {
    switch (this) {
      case CardType.weather:
        return 'Wetter';
      case CardType.wizard:
        return 'Zauberer';
      case CardType.army:
        return 'Armee';
      case CardType.weapon:
        return 'Waffe';
      case CardType.land:
        return 'Land';
      case CardType.wild:
        return 'Joker';
      case CardType.flood:
        return 'Flut';
      case CardType.flame:
        return 'Flamme';
      case CardType.artifact:
        return 'Artefakt';
      case CardType.leader:
        return 'Anführer';
      case CardType.beast:
        return 'Beast';
      default:
        return 'Unbekannter Kartentyp';
    }
  }

  Color get color {
    switch (this) {
      case CardType.weather:
        return Colors.lightBlueAccent;
      case CardType.wizard:
        return Colors.purpleAccent;
      case CardType.army:
        return Colors.black;
      case CardType.weapon:
        return Colors.grey;
      case CardType.land:
        return Colors.brown;
      case CardType.wild:
        return Colors.white;
      case CardType.flood:
        return Colors.blue;
      case CardType.flame:
        return Colors.redAccent;
      case CardType.artifact:
        return Colors.orangeAccent;
      case CardType.leader:
        return Colors.deepPurple;
      case CardType.beast:
        return Colors.green;
      default:
        return Colors.white;
    }
  }
}

enum ActionCards { none, spiegelung, gestaltwandler }

class Card implements Comparable<Card> {
  String _name;
  bool _hasAction;
  CardType _cardType;
  int _baseStrength;
  Widget _description;
  ActionCards actionCards;

  void Function(Map<Card, CardState>) _block;
  int Function(Map<Card, CardState>) _bonus;

  Card(this._name, this._cardType, this._hasAction, this._baseStrength, this._block, this._bonus,
      this._description, this.actionCards);

  void executeBlock(Map<Card, CardState> deck) {
    _block(deck);
  }

  int calculateStrength(Map<Card, CardState> deck) {
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

  Widget get description => _description;

  set description(Widget value) {
    _description = value;
  }

  set baseStrength(int value) {
    _baseStrength = value;
  }

  set cardType(CardType value) {
    _cardType = value;
  }

  set hasAction(bool value) {
    _hasAction = value;
  }

  set name(String value) {
    _name = value;
  }
}

class CardState {
  bool? activationState;
  bool visibility;

  CardState({this.visibility = false, this.activationState = null});
}
