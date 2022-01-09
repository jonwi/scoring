import 'dart:collection';

import 'package:flutter/material.dart';

class Deck {
  List<Card> cards = [
    Card(
        'König',
        CardType.leader,
        false,
        8,
        (deck) {},
        (deck) {
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
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Königin',
        CardType.leader,
        false,
        6,
        (deck) {},
        (deck) {
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
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Prinzessin',
        CardType.leader,
        false,
        2,
        (deck) {},
        (deck) {
          var aDeck = activeDeck(deck);
          return 8 *
              amountOf(aDeck, {CardType.army, CardType.wizard, CardType.leader}, names: {'Prinzessin'});
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
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Kriegsherr',
        CardType.leader,
        false,
        4,
        (deck) {},
        (deck) {
          var aDeck = activeDeck(deck);
          return aDeck
              .where((card) => card.cardType == CardType.army)
              .fold<int>(0, (prev, card) => prev + card.baseStrength);
        },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: 'Die Summe der Basisstärke jeder '),
          TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Kaiserin',
        CardType.leader,
        false,
        15,
        (deck) {},
        (deck) {
          return 10 * amountOf(activeDeck(deck), {CardType.army});
        },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '+10 für jede '),
          TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
          const TextSpan(text: '. -5 für jeden anderen '),
          TextSpan(text: 'Anführer', style: TextStyle(color: CardType.leader.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none,
        (deck) {
          return 5 * amountOf(activeDeck(deck), {CardType.leader}, names: {'Kaiserin'});
        }),
    Card(
        'Ritter',
        CardType.army,
        false,
        20,
        (deck) {},
        (deck) {
          return 0;
        },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '-8 wenn ohne '),
          TextSpan(text: 'Anführer', style: TextStyle(color: CardType.leader.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none,
        (deck) {
          if (amountOf(activeDeck(deck), {CardType.leader}) > 0) {
            return 0;
          }
          return 8;
        }),
    Card(
        'Elbenschützen',
        CardType.army,
        false,
        10,
        (deck) {},
        (deck) {
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
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Leichte Kavallerie',
        CardType.army,
        false,
        17,
        (deck) {},
        (deck) {
          return 0;
        },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '-2 fúr jedes andere '),
          TextSpan(text: 'Land', style: TextStyle(color: CardType.land.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none,
        (deck) {
          return amountOf(activeDeck(deck), {CardType.land}, names: {'Leichte Kavallerie'}) * 2;
        }),
    Card(
        'Zwergeninfanterie',
        CardType.army,
        false,
        15,
        (deck) {},
        (deck) {
          if (contains(activeDeck(deck), 'Waldläufer')) return 0;
          return amountOf(activeDeck(deck), {CardType.army}, names: {'Zwergeninfanterie'}) * -2;
        },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '-2 für jede andere '),
          TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Waldläufer',
        CardType.army,
        false,
        5,
        (deck) {},
        (deck) {
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
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Schild von Keth',
        CardType.artifact,
        false,
        4,
        (deck) {},
        (deck) {
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
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Juwel der Ordnung',
        CardType.artifact,
        false,
        5,
        (deck) {},
        (deck) {
          // TODO: hier muss nochgemacht werden
          return 0;
        },
        RichText(
            text: const TextSpan(
                style: TextStyle(color: Colors.black),
                text:
                    '+10 für eine "Strasse" von 3 Karten, +30 für 4 Karten, +60 für 5 Karten, + 100 für 6 Karten, +150 für 7 Karten.')),
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Weltenbaum',
        CardType.artifact,
        false,
        2,
        (deck) {},
        (deck) {
          return 0; // TODO: hier muss noch geamcht werden
        },
        RichText(
            text: const TextSpan(
                style: TextStyle(color: Colors.black),
                text: '+50 wenn jede Nicht-Blockierte Karte eine unterschiedliche Farbe hat.')),
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Buch der Veränderung',
        CardType.artifact,
        true,
        3,
        (deck) {},
        (deck) {
          return 0;
        },
        RichText(
            text: const TextSpan(
                style: TextStyle(color: Colors.black),
                text:
                    'Du darfst die Farbe einer anderen Karte verändern. Name, Bonus, Strafe und Basisstärke bleiben unverändert')),
        ActionCards.bookOfChange,
        (deck) {
          return 0;
        }),
    Card(
        'Rune des Schutzes',
        CardType.artifact,
        false,
        1,
        (deck) {
          for (var key in deck.keys) {
            deck[key]?.activationState = true;
          }
        },
        (deck) {
          return 0;
        },
        RichText(
            text: const TextSpan(
                style: TextStyle(color: Colors.black), text: 'HEBT die Strafen auf allen Karten AUF.')),
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Einhorn',
        CardType.beast,
        false,
        9,
        (deck) {},
        (deck) {
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
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Basilisk',
        CardType.beast,
        false,
        35,
        (deck) {
          for (var card in deck.keys) {
            if ({CardType.beast, CardType.leader, CardType.army}.contains(card.cardType) &&
                card.name != 'Basilisk') {
              if (deck[card]?.activationState == null) {
                deck[card]?.activationState = false;
              }
            }
          }
        },
        (deck) {
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
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Schlachtenross',
        CardType.beast,
        false,
        6,
        (deck) {},
        (deck) {
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
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Drache',
        CardType.beast,
        false,
        30,
        (deck) {},
        (deck) {
          return 0;
        },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '-40 wenn ohne '),
          TextSpan(text: 'Zauberer', style: TextStyle(color: CardType.wizard.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none,
        (deck) {
          if (amountOf(activeDeck(deck), {CardType.wizard}) > 0) {
            return 0;
          }
          return 40;
        }),
    Card(
        'Hydra',
        CardType.beast,
        false,
        12,
        (deck) {},
        (deck) {
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
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Buschfeuer',
        CardType.flame,
        false,
        40,
        (deck) {
          for (var card in deck.keys) {
            if ({CardType.flame, CardType.wizard, CardType.weather, CardType.weapon, CardType.artifact}
                    .contains(card.cardType) ||
                card.name == 'Gebirge' ||
                card.name == 'Grosse Flut' ||
                card.name == 'Insel' ||
                card.name == 'Einhorn' ||
                card.name == 'Drache' ||
                card.name == 'Buschfeuer') {
              // Eigentlich muss die Bedingung negiert werden, so ist es aber einfacher
            } else {
              if (deck[card]?.activationState == null) {
                deck[card]?.activationState = false;
              }
            }
          }
        },
        (deck) {
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
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Kerze',
        CardType.flame,
        false,
        2,
        (deck) {},
        (deck) {
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
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Schmiede',
        CardType.flame,
        false,
        9,
        (deck) {},
        (deck) {
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
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Blitz',
        CardType.flame,
        false,
        11,
        (deck) {},
        (deck) {
          if (contains(activeDeck(deck), 'Regensturm')) {
            return 30;
          }
          return 0;
        },
        RichText(
            text: const TextSpan(
                style: TextStyle(color: Colors.black),
                children: [TextSpan(text: '+30 mit '), TextSpan(text: 'Regensturm'), TextSpan(text: '.')])),
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Feuerwesen',
        CardType.flame,
        false,
        4,
        (deck) {},
        (deck) {
          return amountOf(activeDeck(deck), {CardType.flame}, names: {'Feuerwesen'}) * 15;
        },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '+15 für jede andere '),
          TextSpan(text: 'Flamme', style: TextStyle(color: CardType.flame.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Quelle des Lebens',
        CardType.flood,
        false,
        1,
        (deck) {},
        (deck) {
          var aDeck = activeDeck(deck);
          return aDeck
              .where((card) => {
                    CardType.weapon,
                    CardType.flood,
                    CardType.flame,
                    CardType.land,
                    CardType.weather
                  }.contains(card.cardType))
              .fold<int>(0, (prev, card) => prev > card.baseStrength ? prev : card.baseStrength);
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
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Sumpf',
        CardType.flood,
        false,
        18,
        (deck) {},
        (deck) {
          return 0;
        },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '-3 für jede '),
          TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
          const TextSpan(text: ' und/oder '),
          TextSpan(text: 'Flamme', style: TextStyle(color: CardType.flame.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none,
        (deck) {
          var aDeck = activeDeck(deck);

          if (contains(aDeck, 'Waldläufer')) {
            return 3 * amountOf(aDeck, {CardType.flame});
          } else {
            return 3 * amountOf(aDeck, {CardType.flame, CardType.army});
          }
        }),
    Card(
        'Grosse Flut',
        CardType.flood,
        false,
        32,
        (deck) {
          for (var card in deck.keys) {
            if (contains(activeDeck(deck), 'Waldläufer')) {
              if ({CardType.land, CardType.flame}.contains(card.cardType)) {
                if (card.name != 'Gebirge' || card.name != 'Blitz') {
                  if (deck[card]?.activationState == null) {
                    deck[card]?.activationState = false;
                  }
                }
              }
            } else {
              if ({CardType.army, CardType.land, CardType.flame}.contains(card.cardType)) {
                if (card.name != 'Gebirge' || card.name != 'Blitz') {
                  if (deck[card]?.activationState == null) {
                    deck[card]?.activationState = false;
                  }
                }
              }
            }
          }
        },
        (deck) {
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
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Insel',
        CardType.flood,
        true,
        14,
        (deck) {},
        (deck) {
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
        ActionCards.island,
        (deck) {
          return 0;
        }),
    Card(
        'Wasserwesen',
        CardType.flood,
        false,
        4,
        (deck) {},
        (deck) {
          return amountOf(activeDeck(deck), {CardType.flood}, names: {'Wasserwesen'}) * 15;
        },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '+15 für jede andere '),
          TextSpan(text: 'Flut', style: TextStyle(color: CardType.flood.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none,
        (deck) {
          return 0;
        }),
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
        ActionCards.gestaltwandler,
        (deck) => 0),
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
        ActionCards.spiegelung,
        (deck) => 0),
    Card(
        'Doppelgänger',
        CardType.wild,
        true,
        0,
        (deck) {},
        (deck) {
          return 0;
        },
        RichText(
            text: const TextSpan(
                style: TextStyle(color: Colors.black),
                text:
                    'Kann Namen, Basisstärke, Farbe und Strafe ABER NICHT DEN BONUS einer anderen Karte in deiner Hand kopieren.')),
        ActionCards.doppelganger,
        (deck) {
          return 0;
        }),
    Card(
        'Gebirge',
        CardType.land,
        false,
        9,
        (deck) {
          for (var card in deck.keys) {
            if (card.cardType == CardType.flood) {
              deck[card]?.activationState = true;
            }
          }
        },
        (deck) {
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
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Höhle',
        CardType.land,
        false,
        6,
        (deck) {
          for (var card in deck.keys) {
            if (card.cardType == CardType.weather) {
              deck[card]?.activationState = true;
            }
          }
        },
        (deck) {
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
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Glockenturm',
        CardType.land,
        false,
        8,
        (deck) {},
        (deck) {
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
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Wald',
        CardType.land,
        false,
        7,
        (deck) {},
        (deck) {
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
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Erdwesen',
        CardType.land,
        false,
        4,
        (deck) {},
        (deck) {
          return amountOf(activeDeck(deck), {CardType.land}, names: {'Erdwesen'}) * 15;
        },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '+15 für jedes andere '),
          TextSpan(text: 'Land', style: TextStyle(color: CardType.land.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Kriegsschiff',
        CardType.weapon,
        false,
        23,
        (deck) {
          if (!deckContainsType(deck, CardType.flood)) {
            deck.keys.where((element) => element.name == 'Kriegsschiff').forEach((element) {
              if (deck[element]?.activationState == null) {
                deck[element]?.activationState = false;
              }
            });
          }
        },
        (deck) {
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
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Zauberstab',
        CardType.weapon,
        false,
        1,
        (deck) {},
        (deck) {
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
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Schwert von Keth',
        CardType.weapon,
        false,
        7,
        (deck) {},
        (deck) {
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
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Elbischer Bogen',
        CardType.weapon,
        false,
        3,
        (deck) {},
        (deck) {
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
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Kampfzeppelin',
        CardType.weapon,
        false,
        35,
        (deck) {
          if (deck.keys.where((element) => element.cardType == CardType.army).isEmpty ||
              deck.keys.where((card) => card.cardType == CardType.weather).isNotEmpty) {
            for (var card in deck.keys) {
              if (card.name == 'Kampfzeppelin') {
                if (deck[card]?.activationState == null) {
                  deck[card]?.activationState = false;
                }
              }
            }
          }
        },
        (deck) {
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
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Regensturm',
        CardType.weather,
        false,
        8,
        (deck) {
          for (var card in deck.keys) {
            if (card.cardType == CardType.flame && card.name != 'Blitz') {
              if (deck[card]?.activationState == null) {
                deck[card]?.activationState = false;
              }
            }
          }
        },
        (deck) {
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
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Blizzard',
        CardType.weather,
        false,
        30,
        (deck) {
          for (var card in deck.keys) {
            if (card.cardType == CardType.flood) {
              if (deck[card]?.activationState == null) {
                deck[card]?.activationState = false;
              }
            }
          }
        },
        (deck) {
          return 0;
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
        ActionCards.none,
        (deck) {
          if (contains(activeDeck(deck), 'Waldläufer')) {
            return amountOf(activeDeck(deck), {CardType.leader, CardType.beast, CardType.flame}) * 5;
          } else {
            return amountOf(
                    activeDeck(deck), {CardType.army, CardType.leader, CardType.beast, CardType.flame}) *
                5;
          }
        }),
    Card(
        'Rauch',
        CardType.weather,
        false,
        27,
        (deck) {
          if (deck.keys.where((card) => card.cardType == CardType.flame).isEmpty) {
            for (var card in deck.keys) {
              if (card.name == 'Rauch') {
                if (deck[card]?.activationState == null) {
                  deck[card]?.activationState = false;
                }
              }
            }
          }
        },
        (deck) {
          return 0;
        },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: 'Ist BLOCKIERT wenn ohne '),
          TextSpan(text: 'Flamme', style: TextStyle(color: CardType.flame.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Wirbelsturm',
        CardType.weather,
        false,
        13,
        (deck) {},
        (deck) {
          var aDeck = activeDeck(deck);
          if (contains(aDeck, 'Regensturm') &&
              (contains(aDeck, 'Blizzard') || contains(aDeck, 'Grosse Flut'))) {
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
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Luftwesen',
        CardType.weather,
        false,
        4,
        (deck) {},
        (deck) {
          return amountOf(activeDeck(deck), {CardType.weather}, names: {'Luftwesen'}) * 15;
        },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '+15 für jedes andere '),
          TextSpan(text: 'Wetter', style: TextStyle(color: CardType.weather.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Sammler',
        CardType.wizard,
        false,
        7,
        (deck) {},
        (deck) {
          int max = activeDeck(deck)
              .toSet()
              .map((card) => card.cardType)
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
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Herr der Bestien',
        CardType.wizard,
        false,
        9,
        (deck) {
          for (var card in deck.keys) {
            if (card.cardType == CardType.beast) {
              deck[card]?.activationState = true;
            }
          }
        },
        (deck) {
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
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Totenbeschwörer',
        CardType.wizard,
        false,
        3,
        (deck) {},
        (deck) {
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
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Hexenmeister',
        CardType.wizard,
        false,
        25,
        (deck) {},
        (deck) {
          return 0;
        },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '-10 für jeden '),
          TextSpan(text: 'Anführer', style: TextStyle(color: CardType.leader.color)),
          const TextSpan(text: ' und/oder anderen '),
          TextSpan(text: 'Zauberer', style: TextStyle(color: CardType.wizard.color)),
          const TextSpan(text: '.')
        ])),
        ActionCards.none,
        (deck) {
          return amountOf(activeDeck(deck), {CardType.leader, CardType.wizard}, names: {'Hexenmeister'}) * 10;
        }),
    Card(
        'Magierin',
        CardType.wizard,
        false,
        5,
        (deck) {},
        (deck) {
          return amountOf(
                  activeDeck(deck), {CardType.land, CardType.flood, CardType.weather, CardType.flame}) *
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
        ActionCards.none,
        (deck) {
          return 0;
        }),
    Card(
        'Hofnarr',
        CardType.wizard,
        false,
        3,
        (deck) {},
        (deck) {
          if (activeDeck(deck).where((card) => card.baseStrength % 2 == 0).isEmpty) {
            return 50;
          }
          return activeDeck(deck)
                  .where((card) => card.name != 'Hofnarr' && card.baseStrength % 2 == 1)
                  .length *
              3;
        },
        RichText(
            text: const TextSpan(
                style: TextStyle(color: Colors.black),
                text:
                    '+3 für jede andere Karte mit einer ungeraden Basisstärke. ODER +50 wenn alle Karten eine ungerade Basisstärke haben.')),
        ActionCards.none,
        (deck) {
          return 0;
        }),
  ];
}

bool contains(Iterable<Card> aDeck, String s) {
  return aDeck.map((e) => e.name).contains(s);
}

Iterable<Card> activeDeck(Map<Card, CardState> deck) {
  return deck.keys.where((card) => deck[card]?.activationState ?? true);
}

bool deckContainsType(Map<Card, CardState> deck, CardType type) {
  return deck.keys.where((card) => deck[card]?.activationState ?? true && card.cardType == type).isNotEmpty;
}

/// Counts the cards matching types excluding named cards in names
int amountOf(Iterable<Card> aDeck, Iterable<CardType> types, {Set<String>? names}) {
  return aDeck.fold<int>(
      0,
      (prev, card) =>
          types.contains(card.cardType) && (names == null || !names.contains(card.name)) ? 1 + prev : prev);
}

int countNames(Iterable<Card> aDeck, String name) {
  return aDeck.where((element) => element.name == name).fold<int>(0, (prev, cur) => prev + 1);
}

enum CardType { weather, wizard, weapon, land, wild, flood, flame, army, artifact, leader, beast }

extension CardTypeExtension on CardType {
  /// Name that is associated with the Type of Card
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

  /// Color that is associated with the Type of Card
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

  /// Gives a Text Color to contrast with color
  Color get textColor {
    return {CardType.army, CardType.leader, CardType.land}.contains(this) ? Colors.white : Colors.black;
  }
}

enum ActionCards { none, spiegelung, gestaltwandler, doppelganger, bookOfChange, island }

class Card implements Comparable<Card> {
  String name;
  bool hasAction;
  CardType cardType;
  int baseStrength;
  Widget description;
  ActionCards actionCards;

  void Function(Map<Card, CardState>) block;
  int Function(Map<Card, CardState>) bonus;
  // Returns a penalty that is subtracted from the overall strength of the card
  int Function(Map<Card, CardState>) penalty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Card && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;

  Card(this.name, this.cardType, this.hasAction, this.baseStrength, this.block, this.bonus, this.description,
      this.actionCards, this.penalty);

  void executeBlock(Map<Card, CardState> deck) {
    block(deck);
  }

  int calculateStrength(Map<Card, CardState> deck) {
    return baseStrength + bonus(deck) - penalty(deck);
  }

  @override
  int compareTo(Card other) {
    return name.compareTo(other.name);
  }
}

class CardState {
  bool? activationState;
  bool visibility;

  CardState({this.visibility = false, this.activationState});
}
