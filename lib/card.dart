import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'fantastischeReiche.dart';

part 'card.g.dart';

class Deck {
  List<Card> cards = [
    Card(
        Cards.koenig,
        Cards.koenig.cardName,
        CardType.leader,
        false,
        8,
        (deck) {},
        (deck) {
          var aDeck = activeDeck(deck);
          if (contains(aDeck, 'Königin')) {
            return amountOf(aDeck, {CardType.army}) * 20;
          } else {
            return amountOf(aDeck, {CardType.army}) * 5;
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
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.koenigin,
        Cards.koenigin.cardName,
        CardType.leader,
        false,
        6,
        (deck) {},
        (deck) {
          var aDeck = activeDeck(deck);
          if (contains(aDeck, 'König')) {
            return amountOf(aDeck, {CardType.army}) * 20;
          } else {
            return amountOf(aDeck, {CardType.army}) * 5;
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
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.prinzessin,
        Cards.prinzessin.cardName,
        CardType.leader,
        false,
        2,
        (deck) {},
        (deck) {
          var aDeck = activeDeck(deck);
          return 8 *
              amountOf(aDeck, {CardType.army, CardType.wizard, CardType.leader}, ids: {Cards.prinzessin});
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
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.kriegsherr,
        Cards.kriegsherr.cardName,
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
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.kaiserin,
        Cards.kaiserin.cardName,
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
        (deck) {
          return 5 * amountOf(activeDeck(deck), {CardType.leader}, ids: {Cards.kaiserin});
        },
        aufheben: (deck) {}),
    Card(
        Cards.ritter,
        Cards.ritter.cardName,
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
        (deck) {
          if (amountOf(activeDeck(deck), {CardType.leader}) > 0) {
            return 0;
          }
          return 8;
        },
        aufheben: (deck) {}),
    Card(
        Cards.elbenschuetzen,
        Cards.elbenschuetzen.cardName,
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
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.leichteKavallerie,
        Cards.leichteKavallerie.cardName,
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
        (deck) {
          return amountOf(activeDeck(deck), {CardType.land}, ids: {Cards.leichteKavallerie}) * 2;
        },
        aufheben: (deck) {}),
    Card(
        Cards.zwergeninfanterie,
        Cards.zwergeninfanterie.cardName,
        CardType.army,
        false,
        15,
        (deck) {},
        (deck) {
          if (contains(activeDeck(deck), 'Waldläufer')) return 0;
          return amountOf(activeDeck(deck), {CardType.army}, ids: {Cards.zwergeninfanterie}) * -2;
        },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '-2 für jede andere '),
          TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
          const TextSpan(text: '.')
        ])),
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.waldlaeufer,
        Cards.waldlaeufer.cardName,
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
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.schildVonKeth,
        Cards.schildVonKeth.cardName,
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
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.juwelDerOrdnung,
        Cards.juwelDerOrdnung.cardName,
        CardType.artifact,
        false,
        5,
        (deck) {},
        (deck) {
          var aDeck = activeDeck(deck);
          var list = aDeck.map((e) => e.baseStrength).toSet().toList()..sort();
          int max = 1;
          int current = 1;
          for (int i = 1; i < list.length; i++) {
            if (list.elementAt(i) == list.elementAt(i - 1) + 1) {
              current++;
              if (current > max) {
                max = current;
              }
            } else if (list.elementAt(i) == list.elementAt(i - 1)) {
              // ignore same baseStrength
            } else {
              // start over with the current element
              current = 1;
            }
          }
          switch (max) {
            case 3:
              return 10;
            case 4:
              return 30;
            case 5:
              return 60;
            case 6:
              return 100;
            default:
              if (max >= 7) {
                return 150;
              } else {
                return 0;
              }
          }
        },
        RichText(
            text: const TextSpan(
                style: TextStyle(color: Colors.black),
                text:
                    '+10 für eine "Strasse" von 3 Karten, +30 für 4 Karten, +60 für 5 Karten, + 100 für 6 Karten, +150 für 7 Karten.')),
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.weltenbaum,
        Cards.weltenbaum.cardName,
        CardType.artifact,
        false,
        2,
        (deck) {},
        (deck) {
          var aDeck = activeDeck(deck);
          var types = aDeck.map((e) => e.cardType).toSet();
          if (aDeck.length == types.length) {
            return 50;
          }
          return 0;
        },
        RichText(
            text: const TextSpan(
                style: TextStyle(color: Colors.black),
                text: '+50 wenn jede Nicht-Blockierte Karte eine unterschiedliche Farbe hat.')),
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.buchDerVeraenderung,
        Cards.buchDerVeraenderung.cardName,
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
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.runeDesSchutzes,
        Cards.runeDesSchutzes.cardName,
        CardType.artifact,
        false,
        1,
        (deck) {},
        (deck) {
          return 0;
        },
        RichText(
            text: const TextSpan(
                style: TextStyle(color: Colors.black), text: 'HEBT die Strafen auf allen Karten AUF.')),
        (deck) {
          return 0;
        },
        aufheben: (deck) {
          for (var key in deck.keys) {
            deck[key]?.activationState = true;
            key.penalty = (deck) => 0;
            key.block = (deck) {};
          }
        }),
    Card(
        Cards.einhorn,
        Cards.einhorn.cardName,
        CardType.beast,
        false,
        9,
        (deck) {},
        (deck) {
          var aDeck = activeDeck(deck);
          if (contains(aDeck, 'Prinzessin')) {
            return 30;
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
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.basilisk,
        Cards.basilisk.cardName,
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
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.schlachtross,
        Cards.schlachtross.cardName,
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
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.drache,
        Cards.drache.cardName,
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
        (deck) {
          if (amountOf(activeDeck(deck), {CardType.wizard}) > 0) {
            return 0;
          }
          return 40;
        },
        aufheben: (deck) {}),
    Card(
        Cards.hydra,
        Cards.hydra.cardName,
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
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.buschfeuer,
        Cards.buschfeuer.cardName,
        CardType.flame,
        false,
        40,
        (deck) {
          for (var card in deck.keys) {
            if ({CardType.flame, CardType.wizard, CardType.weather, CardType.weapon, CardType.artifact}
                    .contains(card.cardType) ||
                card.name == 'Gebirge' ||
                card.name == 'Große Flut' ||
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
          TextSpan(text: 'Große Flut', style: TextStyle(color: CardType.flood.color)),
          const TextSpan(text: ', '),
          TextSpan(text: 'Insel', style: TextStyle(color: CardType.flood.color)),
          const TextSpan(text: ', '),
          TextSpan(text: 'Einhorn', style: TextStyle(color: CardType.beast.color)),
          const TextSpan(text: ' und '),
          TextSpan(text: 'Drache', style: TextStyle(color: CardType.beast.color)),
          const TextSpan(text: '.')
        ])),
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.kerze,
        Cards.kerze.cardName,
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
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.schmiede,
        Cards.schmiede.cardName,
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
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.blitz,
        Cards.blitz.cardName,
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
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.feuerwesen,
        Cards.feuerwesen.cardName,
        CardType.flame,
        false,
        4,
        (deck) {},
        (deck) {
          return amountOf(activeDeck(deck), {CardType.flame}, ids: {Cards.feuerwesen}) * 15;
        },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '+15 für jede andere '),
          TextSpan(text: 'Flamme', style: TextStyle(color: CardType.flame.color)),
          const TextSpan(text: '.')
        ])),
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.quelleDesLebens,
        Cards.quelleDesLebens.cardName,
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
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.sumpf,
        Cards.sumpf.cardName,
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
        (deck) {
          var aDeck = activeDeck(deck);

          if (contains(aDeck, 'Waldläufer')) {
            return 3 * amountOf(aDeck, {CardType.flame});
          } else {
            return 3 * amountOf(aDeck, {CardType.flame, CardType.army});
          }
        },
        aufheben: (deck) {}),
    Card(
        Cards.grosseFlut,
        Cards.grosseFlut.cardName,
        CardType.flood,
        false,
        32,
        (deck) {
          for (var card in deck.keys) {
            if (card.name != Cards.gebirge.cardName && card.name != Cards.blitz.cardName) {
              if (contains(activeDeck(deck), Cards.waldlaeufer.cardName)) {
                if ({CardType.land, CardType.flame}.contains(card.cardType)) {
                  if (deck[card]?.activationState == null) {
                    deck[card]?.activationState = false;
                  }
                }
              } else {
                if ({CardType.army, CardType.land, CardType.flame}.contains(card.cardType)) {
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
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.insel,
        Cards.insel.cardName,
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
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.wasserwesen,
        Cards.wasserwesen.cardName,
        CardType.flood,
        false,
        4,
        (deck) {},
        (deck) {
          return amountOf(activeDeck(deck), {CardType.flood}, ids: {Cards.wasserwesen}) * 15;
        },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '+15 für jede andere '),
          TextSpan(text: 'Flut', style: TextStyle(color: CardType.flood.color)),
          const TextSpan(text: '.')
        ])),
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(Cards.gestaltwandler, Cards.gestaltwandler.cardName, CardType.wild, true, 0, (deck) {}, (deck) {
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
        (deck) => 0,
        aufheben: (deck) {}),
    Card(Cards.spiegelung, 'Spiegelung', CardType.wild, true, 0, (deck) {}, (deck) {
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
        (deck) => 0,
        aufheben: (deck) {}),
    Card(
        Cards.doppelgaenger,
        Cards.doppelgaenger.cardName,
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
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.gebirge,
        Cards.gebirge.cardName,
        CardType.land,
        false,
        9,
        (deck) {},
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
        (deck) {
          return 0;
        },
        aufheben: (deck) {
          for (var card in deck.keys) {
            if (card.cardType == CardType.flood) {
              deck[card]?.activationState = true;
              card.penalty = (deck) => 0;
              card.block = (deck) {};
            }
          }
        }),
    Card(
        Cards.hoehle,
        Cards.hoehle.cardName,
        CardType.land,
        false,
        6,
        (deck) {},
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
        (deck) {
          return 0;
        },
        aufheben: (deck) {
          for (var card in deck.keys) {
            if (card.cardType == CardType.weather) {
              deck[card]?.activationState = true;
              card.penalty = (deck) => 0;
              card.block = (deck) {};
            }
          }
        }),
    Card(
        Cards.glockenturm,
        Cards.glockenturm.cardName,
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
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.wald,
        Cards.wald.cardName,
        CardType.land,
        false,
        7,
        (deck) {},
        (deck) {
          return amountOf(activeDeck(deck), {CardType.beast}) * 12 +
              (contains(activeDeck(deck), 'Elbenschützen') ? 12 : 0);
        },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '+12 für jede '),
          TextSpan(text: 'Bestie', style: TextStyle(color: CardType.beast.color)),
          const TextSpan(text: ' und/oder '),
          TextSpan(text: 'Elbenschützen', style: TextStyle(color: CardType.army.color)),
          const TextSpan(text: '.')
        ])),
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.erdwesen,
        Cards.erdwesen.cardName,
        CardType.land,
        false,
        4,
        (deck) {},
        (deck) {
          return amountOf(activeDeck(deck), {CardType.land}, ids: {Cards.erdwesen}) * 15;
        },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '+15 für jedes andere '),
          TextSpan(text: 'Land', style: TextStyle(color: CardType.land.color)),
          const TextSpan(text: '.')
        ])),
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.kriegsschiff,
        Cards.kriegsschiff.cardName,
        CardType.weapon,
        false,
        23,
        (deck) {
          if (amountOf(activeDeck(deck), {CardType.flood}) == 0) {
            final card = deck.keys.where((card) => card.id == Cards.kriegsschiff).first;
            if (deck[card]?.activationState == null) {
              deck[card]?.activationState = false;
            }
          }
        },
        (deck) {
          return 0;
        },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: 'Ist BLOCKIERT wenn ohne '),
          TextSpan(text: 'Flut', style: TextStyle(color: CardType.flood.color)),
          const TextSpan(text: '.'),
          const TextSpan(text: 'HEBT das Wort '),
          TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
          const TextSpan(text: ' von allen Strafen auf allen '),
          TextSpan(text: 'Fluten', style: TextStyle(color: CardType.flood.color)),
          const TextSpan(text: ' AUF.')
        ])),
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.zauberstab,
        Cards.zauberstab.cardName,
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
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.schwertVonKeth,
        Cards.schwertVonKeth.cardName,
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
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.elbischerBogen,
        Cards.elbischerBogen.cardName,
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
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.kampfzeppelin,
        Cards.kampfzeppelin.cardName,
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
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.regensturm,
        Cards.regensturm.cardName,
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
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.blizzard,
        Cards.blizzard.cardName,
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
        (deck) {
          if (contains(activeDeck(deck), 'Waldläufer')) {
            return amountOf(activeDeck(deck), {CardType.leader, CardType.beast, CardType.flame}) * 5;
          } else {
            return amountOf(
                    activeDeck(deck), {CardType.army, CardType.leader, CardType.beast, CardType.flame}) *
                5;
          }
        },
        aufheben: (deck) {}),
    Card(
        Cards.rauch,
        Cards.rauch.cardName,
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
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.wirbelsturm,
        Cards.wirbelsturm.cardName,
        CardType.weather,
        false,
        13,
        (deck) {},
        (deck) {
          var aDeck = activeDeck(deck);
          if (contains(aDeck, 'Regensturm') &&
              (contains(aDeck, 'Blizzard') || contains(aDeck, 'Große Flut'))) {
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
          TextSpan(text: 'Große Flut', style: TextStyle(color: CardType.flood.color)),
          const TextSpan(text: '.')
        ])),
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.luftwesen,
        Cards.luftwesen.cardName,
        CardType.weather,
        false,
        4,
        (deck) {},
        (deck) {
          return amountOf(activeDeck(deck), {CardType.weather}, ids: {Cards.luftwesen}) * 15;
        },
        RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
          const TextSpan(text: '+15 für jedes andere '),
          TextSpan(text: 'Wetter', style: TextStyle(color: CardType.weather.color)),
          const TextSpan(text: '.')
        ])),
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.sammler,
        Cards.sammler.cardName,
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
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.herrDerBestien,
        Cards.herrDerBestien.cardName,
        CardType.wizard,
        false,
        9,
        (deck) {},
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
        (deck) {
          return 0;
        },
        aufheben: (deck) {
          for (var card in deck.keys) {
            if (card.cardType == CardType.beast) {
              deck[card]?.activationState = true;
              card.penalty = (deck) => 0;
              card.block = (deck) {};
            }
          }
        }),
    Card(
        Cards.totenbeschwoerer,
        Cards.totenbeschwoerer.cardName,
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
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.hexenmeister,
        Cards.hexenmeister.cardName,
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
        (deck) {
          return amountOf(activeDeck(deck), {CardType.leader, CardType.wizard}, ids: {Cards.hexenmeister}) *
              10;
        },
        aufheben: (deck) {}),
    Card(
        Cards.magierin,
        Cards.magierin.cardName,
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
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
    Card(
        Cards.hofnarr,
        Cards.hofnarr.cardName,
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
        (deck) {
          return 0;
        },
        aufheben: (deck) {}),
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

/// Counts the cards matching types excluding ids
int amountOf(Iterable<Card> aDeck, Iterable<CardType> types, {Set<Cards>? ids}) {
  return aDeck.fold<int>(
      0,
      (prev, card) =>
          types.contains(card.cardType) && (ids == null || !ids.contains(card.id)) ? 1 + prev : prev);
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

class Card implements Comparable<Card> {
  String name;
  bool hasAction;
  CardType cardType;
  int baseStrength;
  Widget description;
  Cards id;

  void Function(Map<Card, CardState>) block;
  void Function(Map<Card, CardState>) aufheben;
  int Function(Map<Card, CardState>) bonus;
  // Returns a penalty that is subtracted from the overall strength of the card
  int Function(Map<Card, CardState>) penalty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Card && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  Card(this.id, this.name, this.cardType, this.hasAction, this.baseStrength, this.block, this.bonus,
      this.description, this.penalty,
      {required this.aufheben});

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

@HiveType(typeId: 1)
enum Cards {
  @HiveField(0)
  koenig,
  @HiveField(1)
  koenigin,
  @HiveField(2)
  prinzessin,
  @HiveField(3)
  kriegsherr,
  @HiveField(4)
  kaiserin,
  @HiveField(5)
  ritter,
  @HiveField(6)
  elbenschuetzen,
  @HiveField(7)
  leichteKavallerie,
  @HiveField(8)
  zwergeninfanterie,
  @HiveField(9)
  waldlaeufer,
  @HiveField(10)
  schildVonKeth,
  @HiveField(11)
  juwelDerOrdnung,
  @HiveField(12)
  weltenbaum,
  @HiveField(13)
  buchDerVeraenderung,
  @HiveField(14)
  runeDesSchutzes,
  @HiveField(15)
  einhorn,
  @HiveField(16)
  basilisk,
  @HiveField(17)
  schlachtross,
  @HiveField(18)
  drache,
  @HiveField(19)
  hydra,
  @HiveField(20)
  buschfeuer,
  @HiveField(21)
  kerze,
  @HiveField(22)
  schmiede,
  @HiveField(23)
  blitz,
  @HiveField(24)
  feuerwesen,
  @HiveField(25)
  quelleDesLebens,
  @HiveField(26)
  sumpf,
  @HiveField(27)
  grosseFlut,
  @HiveField(28)
  insel,
  @HiveField(29)
  wasserwesen,
  @HiveField(30)
  gestaltwandler,
  @HiveField(31)
  spiegelung,
  @HiveField(32)
  doppelgaenger,
  @HiveField(33)
  gebirge,
  @HiveField(34)
  hoehle,
  @HiveField(35)
  glockenturm,
  @HiveField(36)
  wald,
  @HiveField(37)
  erdwesen,
  @HiveField(38)
  kriegsschiff,
  @HiveField(39)
  zauberstab,
  @HiveField(40)
  schwertVonKeth,
  @HiveField(41)
  elbischerBogen,
  @HiveField(42)
  kampfzeppelin,
  @HiveField(43)
  regensturm,
  @HiveField(44)
  blizzard,
  @HiveField(45)
  rauch,
  @HiveField(46)
  wirbelsturm,
  @HiveField(47)
  luftwesen,
  @HiveField(48)
  sammler,
  @HiveField(49)
  herrDerBestien,
  @HiveField(50)
  totenbeschwoerer,
  @HiveField(51)
  hexenmeister,
  @HiveField(52)
  magierin,
  @HiveField(53)
  hofnarr,
}

extension CardsExtension on Cards {
  String get cardName {
    switch (this) {
      case Cards.koenig:
        return 'König';
      case Cards.koenigin:
        return 'Königin';
      case Cards.prinzessin:
        return 'Prinzessin';
      case Cards.kriegsherr:
        return 'Kriegsherr';
      case Cards.kaiserin:
        return 'Kaiserin';
      case Cards.ritter:
        return 'Ritter';
      case Cards.elbenschuetzen:
        return 'Elbenschützen';
      case Cards.leichteKavallerie:
        return 'Leichte Kavallerie';
      case Cards.zwergeninfanterie:
        return 'Zwergeninfanterie';
      case Cards.waldlaeufer:
        return 'Waldläufer';
      case Cards.schildVonKeth:
        return 'Schild von Keth';
      case Cards.juwelDerOrdnung:
        return 'Juwel der Ordnung';
      case Cards.weltenbaum:
        return 'Weltenbaum';
      case Cards.buchDerVeraenderung:
        return 'Buch der Veränderung';
      case Cards.runeDesSchutzes:
        return 'Rune des Schutzes';
      case Cards.einhorn:
        return 'Einhorn';
      case Cards.basilisk:
        return 'Basilisk';
      case Cards.schlachtross:
        return 'Schlachtross';
      case Cards.drache:
        return 'Drache';
      case Cards.hydra:
        return 'Hydra';
      case Cards.buschfeuer:
        return 'Buschfeuer';
      case Cards.kerze:
        return 'Kerze';
      case Cards.schmiede:
        return 'Schmiede';
      case Cards.blitz:
        return 'Blitz';
      case Cards.feuerwesen:
        return 'Feuerwesen';
      case Cards.quelleDesLebens:
        return 'Quelle des Lebens';
      case Cards.sumpf:
        return 'Sumpf';
      case Cards.grosseFlut:
        return 'Große Flut';
      case Cards.insel:
        return 'Insel';
      case Cards.wasserwesen:
        return 'Wasserwesen';
      case Cards.gestaltwandler:
        return 'Gestaltwandler';
      case Cards.spiegelung:
        return 'Spiegelung';
      case Cards.doppelgaenger:
        return 'Doppelgänger';
      case Cards.gebirge:
        return 'Gebirge';
      case Cards.hoehle:
        return 'Höhle';
      case Cards.glockenturm:
        return 'Glockenturm';
      case Cards.wald:
        return 'Wald';
      case Cards.erdwesen:
        return 'Erdwesen';
      case Cards.kriegsschiff:
        return 'Kriegsschiff';
      case Cards.zauberstab:
        return 'Zauberstab';
      case Cards.schwertVonKeth:
        return 'Schwert von Keth';
      case Cards.elbischerBogen:
        return 'Elbischer Bogen';
      case Cards.kampfzeppelin:
        return 'Kampfzeppelin';
      case Cards.regensturm:
        return 'Regensturm';
      case Cards.blizzard:
        return 'Blizzard';
      case Cards.rauch:
        return 'Rauch';
      case Cards.wirbelsturm:
        return 'Wirbelsturm';
      case Cards.luftwesen:
        return 'Luftwesen';
      case Cards.sammler:
        return 'Sammler';
      case Cards.herrDerBestien:
        return 'Herr der Bestien';
      case Cards.totenbeschwoerer:
        return 'Totenbeschwörer';
      case Cards.hexenmeister:
        return 'Hexenmeister';
      case Cards.magierin:
        return 'Magierin';
      case Cards.hofnarr:
        return 'Hofnarr';

      default:
        return 'Unknown Card';
    }
  }
}
