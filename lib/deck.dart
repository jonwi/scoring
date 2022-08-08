import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart' as mat;
import 'package:flutter/material.dart' hide Card;
import 'package:scoring/numberpicker.dart';
import 'package:scoring/type_selector.dart';

import 'card.dart';
import 'card_selector.dart';
import 'game.dart';

class Deck {
  Iterable<Card> cards(isExpansion) {
    if (isExpansion) {
      return expansionIDs().map((id) => allCards().firstWhere((element) => element.id == id));
    }
    return standardIDs().map((id) => allCards().firstWhere((element) => element.id == id));
  }

  bool contains(Iterable<Card> aDeck, String s) {
    return aDeck.map((e) => e.name).contains(s);
  }

  bool containsID(Iterable<Card> aDeck, Cards id) {
    return aDeck.map((e) => e.id).contains(id);
  }

  bool deckContainsType(Game game, CardType type) {
    return game.cardsHand.where((card) => card.cardType == type).isNotEmpty;
  }

  bool activeDeckContainsType(Game game, CardType type) {
    return game.activeCards.where((card) => card.cardType == type).isNotEmpty;
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

  List<Cards> standardIDs() {
    return [
      Cards.koenig,
      Cards.koenigin,
      Cards.prinzessin,
      Cards.kriegsherr,
      Cards.kaiserin,
      Cards.ritter,
      Cards.elbenschuetzen,
      Cards.leichteKavallerie,
      Cards.zwergeninfanterie,
      Cards.waldlaeufer,
      Cards.schildVonKeth,
      Cards.juwelDerOrdnung,
      Cards.weltenbaum,
      Cards.buchDerVeraenderung,
      Cards.runeDesSchutzes,
      Cards.einhorn,
      Cards.basilisk,
      Cards.schlachtross,
      Cards.drache,
      Cards.hydra,
      Cards.buschfeuer,
      Cards.kerze,
      Cards.schmiede,
      Cards.blitz,
      Cards.feuerwesen,
      Cards.quelleDesLebens,
      Cards.sumpf,
      Cards.grosseFlut,
      Cards.insel,
      Cards.wasserwesen,
      Cards.gestaltwandler,
      Cards.spiegelung,
      Cards.doppelgaenger,
      Cards.gebirge,
      Cards.hoehle,
      Cards.glockenturm,
      Cards.wald,
      Cards.erdwesen,
      Cards.kriegsschiff,
      Cards.zauberstab,
      Cards.schwertVonKeth,
      Cards.elbischerBogen,
      Cards.kampfzeppelin,
      Cards.regensturm,
      Cards.blizzard,
      Cards.rauch,
      Cards.wirbelsturm,
      Cards.luftwesen,
      Cards.sammler,
      Cards.herrDerBestien,
      Cards.totenbeschwoerer,
      Cards.hexenmeister,
      Cards.magierin,
    ];
  }

  List<Cards> expansionIDs() {
    return [
      Cards.koenig,
      Cards.koenigin,
      Cards.prinzessin,
      Cards.kriegsherr,
      Cards.kaiserin,
      Cards.ritter,
      Cards.waldlaeuferNeu,
      Cards.elbenschuetzen,
      Cards.leichteKavallerie,
      Cards.zwergeninfanterie,
      Cards.weltenbaumNeu,
      Cards.schildVonKeth,
      Cards.juwelDerOrdnung,
      Cards.buchDerVeraenderung,
      Cards.runeDesSchutzes,
      Cards.einhorn,
      Cards.basilisk,
      Cards.schlachtross,
      Cards.drache,
      Cards.hydra,
      Cards.buschfeuer,
      Cards.kerze,
      Cards.schmiede,
      Cards.blitz,
      Cards.feuerwesen,
      Cards.quelleDesLebensNeu,
      Cards.grosseFlutNeu,
      Cards.sumpf,
      Cards.insel,
      Cards.wasserwesen,
      Cards.spiegelungNeu,
      Cards.gestaltwandlerNeu,
      Cards.doppelgaenger,
      Cards.gebirge,
      Cards.hoehle,
      Cards.wald,
      Cards.erdwesen,
      Cards.garten,
      Cards.kriegsschiff,
      Cards.zauberstab,
      Cards.schwertVonKeth,
      Cards.elbischerBogen,
      Cards.kampfzeppelin,
      Cards.regensturm,
      Cards.blizzard,
      Cards.rauch,
      Cards.wirbelsturm,
      Cards.luftwesen,
      Cards.sammler,
      Cards.herrDerBestien,
      Cards.hexenmeister,
      Cards.magierin,
      Cards.totenbeschwoererNeu,
      Cards.ghul,
      Cards.gespenst,
      Cards.dunkleKoenigin,
      Cards.todesritter,
      Cards.lich,
      Cards.gruft,
      Cards.kapelle,
      Cards.glockenturmNeu,
      Cards.verlies,
      Cards.burg,
      Cards.richter,
      Cards.kobold,
      Cards.dschinn,
      Cards.daemon,
      Cards.engel,
    ];
  }

  List<Card> allCards() {
    return [
      Card(
          Cards.koenig,
          Cards.koenig.cardName,
          CardType.leader,
          false,
          8,
          (game, tis) {},
          (game, tis) {
            var aDeck = game.activeCards;
            if (contains(aDeck, Cards.koenigin.cardName)) {
              return amountOf(aDeck, {CardType.army}) * 20;
            } else {
              return amountOf(aDeck, {CardType.army}) * 5;
            }
          },
          RichText(
              text: TextSpan(
            style: const TextStyle(color: mat.Colors.black),
            children: [
              const TextSpan(text: '+5 für jede '),
              TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
              const TextSpan(text: '. ODER +20 für jede '),
              TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
              const TextSpan(text: ', wenn zusammen mit '),
              TextSpan(text: Cards.koenigin.cardName, style: TextStyle(color: CardType.leader.color)),
              const TextSpan(text: '.')
            ],
          )),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.koenigin,
          Cards.koenigin.cardName,
          CardType.leader,
          false,
          6,
          (game, tis) {},
          (game, tis) {
            var aDeck = game.activeCards;
            if (contains(aDeck, Cards.koenig.cardName)) {
              return amountOf(aDeck, {CardType.army}) * 20;
            } else {
              return amountOf(aDeck, {CardType.army}) * 5;
            }
          },
          RichText(
              text: TextSpan(
            style: const TextStyle(color: mat.Colors.black),
            children: [
              const TextSpan(text: '+5 für jede '),
              TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
              const TextSpan(text: '. ODER +20 für jede '),
              TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
              const TextSpan(text: ', wenn zusammen mit '),
              TextSpan(text: Cards.koenig.cardName, style: TextStyle(color: CardType.leader.color)),
              const TextSpan(text: '.')
            ],
          )),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.prinzessin,
          Cards.prinzessin.cardName,
          CardType.leader,
          false,
          2,
          (game, tis) {},
          (game, tis) {
            var aDeck = game.activeCards;
            return 8 *
                amountOf(aDeck, {CardType.army, CardType.wizard, CardType.leader}, ids: {Cards.prinzessin});
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: '+8 für jede '),
            TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
            const TextSpan(text: ', '),
            TextSpan(text: 'Zauberer', style: TextStyle(color: CardType.wizard.color)),
            const TextSpan(text: ' und/oder andere '),
            TextSpan(text: 'Anführer', style: TextStyle(color: CardType.leader.color)),
            const TextSpan(text: '.')
          ])),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.kriegsherr,
          Cards.kriegsherr.cardName,
          CardType.leader,
          false,
          4,
          (game, tis) {},
          (game, tis) {
            var aDeck = game.activeCards;
            return aDeck
                .where((card) => card.cardType == CardType.army)
                .fold<int>(0, (prev, card) => prev + card.baseStrength);
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: 'Die Summe der Basisstärke jeder '),
            TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
            const TextSpan(text: '.')
          ])),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.kaiserin,
          Cards.kaiserin.cardName,
          CardType.leader,
          false,
          15,
          (game, tis) {},
          (game, tis) {
            return 10 * amountOf(game.activeCards, {CardType.army});
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: '+10 für jede '),
            TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
            const TextSpan(text: '. -5 für jeden anderen '),
            TextSpan(text: 'Anführer', style: TextStyle(color: CardType.leader.color)),
            const TextSpan(text: '.')
          ])),
          (game, tis) {
            return 5 * amountOf(game.activeCards, {CardType.leader}, ids: {tis.id});
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.ritter,
          Cards.ritter.cardName,
          CardType.army,
          false,
          20,
          (game, tis) {},
          (game, tis) {
            return 0;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: '-8 wenn ohne '),
            TextSpan(text: 'Anführer', style: TextStyle(color: CardType.leader.color)),
            const TextSpan(text: '.')
          ])),
          (game, tis) {
            if (amountOf(game.activeCards, {CardType.leader}) > 0) {
              return 0;
            }
            return 8;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.elbenschuetzen,
          Cards.elbenschuetzen.cardName,
          CardType.army,
          false,
          10,
          (game, tis) {},
          (game, tis) {
            if (amountOf(game.activeCards, {CardType.weather}) == 0) {
              return 5;
            }
            return 0;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: '+5 wenn ohne '),
            TextSpan(text: 'Wetter', style: TextStyle(color: CardType.weather.color)),
            const TextSpan(text: '.')
          ])),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.leichteKavallerie,
          Cards.leichteKavallerie.cardName,
          CardType.army,
          false,
          17,
          (game, tis) {},
          (game, tis) {
            return 0;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: '-2 fúr jedes andere '),
            TextSpan(text: 'Land', style: TextStyle(color: CardType.land.color)),
            const TextSpan(text: '.')
          ])),
          (game, tis) {
            return amountOf(game.activeCards, {CardType.land}, ids: {tis.id}) * 2;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.zwergeninfanterie,
          Cards.zwergeninfanterie.cardName,
          CardType.army,
          false,
          15,
          (game, tis) {},
          (game, tis) {
            if (containsID(game.activeCards, Cards.waldlaeufer) ||
                containsID(game.activeCards, Cards.waldlaeuferNeu)) return 0;
            return amountOf(game.activeCards, {CardType.army}, ids: {tis.id}) * -2;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: '-2 für jede andere '),
            TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
            const TextSpan(text: '.')
          ])),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.waldlaeufer,
          Cards.waldlaeufer.cardName,
          CardType.army,
          false,
          5,
          (game, tis) {},
          (game, tis) {
            return amountOf(game.activeCards, {CardType.land}) * 10;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: '+10 für jedes '),
            TextSpan(text: 'Land', style: TextStyle(color: CardType.land.color)),
            const TextSpan(text: '. HEBT das Wort '),
            TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
            const TextSpan(text: ' von allen Strafen AUF.')
          ])),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.schildVonKeth,
          Cards.schildVonKeth.cardName,
          CardType.artifact,
          false,
          4,
          (game, tis) {},
          (game, tis) {
            if (amountOf(game.activeCards, {CardType.leader}) > 0) {
              if (contains(game.activeCards, Cards.schwertVonKeth.cardName)) {
                return 40;
              } else {
                return 15;
              }
            }
            return 0;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: '+15 mit mindestens einem '),
            TextSpan(text: 'Anführer', style: TextStyle(color: CardType.leader.color)),
            const TextSpan(text: '. ODER +40 mit '),
            TextSpan(text: 'Anführer', style: TextStyle(color: CardType.leader.color)),
            const TextSpan(text: ' und '),
            TextSpan(text: Cards.schwertVonKeth.cardName, style: TextStyle(color: CardType.artifact.color)),
            const TextSpan(text: ".")
          ])),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.juwelDerOrdnung,
          Cards.juwelDerOrdnung.cardName,
          CardType.artifact,
          false,
          5,
          (game, tis) {},
          (game, tis) {
            var aDeck = game.activeCards;
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
                  style: TextStyle(color: mat.Colors.black),
                  text:
                      '+10 für eine "Strasse" von 3 Karten, +30 für 4 Karten, +60 für 5 Karten, + 100 für 6 Karten, +150 für 7 Karten.')),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.weltenbaum,
          Cards.weltenbaum.cardName,
          CardType.artifact,
          false,
          2,
          (game, tis) {},
          (game, tis) {
            var aDeck = game.activeCards;
            var types = aDeck.map((e) => e.cardType).toSet();
            if (aDeck.length == types.length) {
              return 50;
            }
            return 0;
          },
          RichText(
              text: const TextSpan(
                  style: TextStyle(color: mat.Colors.black),
                  text: '+50 wenn jede Nicht-Blockierte Karte eine unterschiedliche Farbe hat.')),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.buchDerVeraenderung,
          Cards.buchDerVeraenderung.cardName,
          CardType.artifact,
          true,
          3,
          (game, tis) {},
          (game, tis) {
            return 0;
          },
          RichText(
              text: const TextSpan(
                  style: TextStyle(color: mat.Colors.black),
                  text:
                      'Du darfst die Farbe einer anderen Karte verändern. Name, Bonus, Strafe und Basisstärke bleiben unverändert')),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {},
          haction: (tis, context, game) async {
            final cardID = await Navigator.push(context, MaterialPageRoute<Cards>(builder: (context) {
              return CardSelector(
                selector: (c) => game.cardsHand.map((e) => e.name).contains(c.name) && c.name != tis.name,
                isExpansion: game.isExpansion,
              );
            }));
            if (cardID != null) {
              final cardType = await Navigator.push(context, MaterialPageRoute<CardType>(builder: (context) {
                return TypeSelector(selector: (type) => baseTypes.contains(type) && type != CardType.wild);
              }));
              if (cardType != null) {
                Card chosen = game.cardsHand.where((element) => element.id == cardID).first;
                chosen.cardType = cardType;
                tis.hasAction = false;
              }
            }
          }),
      Card(
          Cards.runeDesSchutzes,
          Cards.runeDesSchutzes.cardName,
          CardType.artifact,
          false,
          1,
          (game, tis) {},
          (game, tis) {
            return 0;
          },
          RichText(
              text: const TextSpan(
                  style: TextStyle(color: mat.Colors.black), text: 'HEBT die Strafen auf allen Karten AUF.')),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {
            for (var key in game.cardsHand) {
              key.hpenalty = (game, tis) => 0;
              key.hblock = (game, tis) {};
            }
          }),
      Card(
          Cards.einhorn,
          Cards.einhorn.cardName,
          CardType.beast,
          false,
          9,
          (game, tis) {},
          (game, tis) {
            var aDeck = game.activeCards;
            if (contains(aDeck, Cards.prinzessin.cardName)) {
              return 30;
            }
            if (contains(aDeck, Cards.koenigin.cardName) ||
                contains(aDeck, Cards.kaiserin.cardName) ||
                contains(aDeck, Cards.magierin.cardName)) {
              return 15;
            }
            return 0;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: '+30 mit '),
            const TextSpan(text: '. ODER +15 mit'),
            TextSpan(text: Cards.kaiserin.cardName, style: TextStyle(color: CardType.leader.color)),
            const TextSpan(text: ', '),
            TextSpan(text: Cards.koenigin.cardName, style: TextStyle(color: CardType.leader.color)),
            const TextSpan(text: ' oder '),
            TextSpan(text: Cards.magierin.cardName, style: TextStyle(color: CardType.wizard.color)),
            const TextSpan(text: '.')
          ])),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.basilisk,
          Cards.basilisk.cardName,
          CardType.beast,
          false,
          35,
          (game, tis) {
            for (var card in game.cardsHand) {
              if (containsID(game.activeCards, Cards.waldlaeufer) ||
                  containsID(game.activeCards, Cards.waldlaeuferNeu)) {
                if ({CardType.beast, CardType.leader}.contains(card.cardType) && card.id != tis.id) {
                  game.blockCard(card);
                }
              } else {
                if ({CardType.beast, CardType.leader, CardType.army}.contains(card.cardType) &&
                    card.id != tis.id) {
                  game.blockCard(card);
                }
              }
            }
          },
          (game, tis) {
            return 0;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: 'BLOCKIERT alle '),
            TextSpan(text: 'Armeen', style: TextStyle(color: CardType.army.color)),
            const TextSpan(text: ', '),
            TextSpan(text: 'Anführer', style: TextStyle(color: CardType.leader.color)),
            const TextSpan(text: ' und andere '),
            TextSpan(text: 'Bestien', style: TextStyle(color: CardType.beast.color)),
            const TextSpan(text: '.')
          ])),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.schlachtross,
          Cards.schlachtross.cardName,
          CardType.beast,
          false,
          6,
          (game, tis) {},
          (game, tis) {
            if (amountOf(game.activeCards, {CardType.leader, CardType.wizard}) > 0) {
              return 14;
            }
            return 0;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: '+14 mit mindestens einem'),
            TextSpan(text: 'Anführer', style: TextStyle(color: CardType.leader.color)),
            const TextSpan(text: ' oder '),
            TextSpan(text: 'Zauberer', style: TextStyle(color: CardType.wizard.color)),
            const TextSpan(text: '.')
          ])),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.drache,
          Cards.drache.cardName,
          CardType.beast,
          false,
          30,
          (game, tis) {},
          (game, tis) {
            return 0;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: '-40 wenn ohne '),
            TextSpan(text: 'Zauberer', style: TextStyle(color: CardType.wizard.color)),
            const TextSpan(text: '.')
          ])),
          (game, tis) {
            if (amountOf(game.activeCards, {CardType.wizard}) > 0) {
              return 0;
            }
            return 40;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.hydra,
          Cards.hydra.cardName,
          CardType.beast,
          false,
          12,
          (game, tis) {},
          (game, tis) {
            if (contains(game.activeCards, Cards.sumpf.cardName)) {
              return 28;
            }
            return 0;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: '+20 mit '),
            TextSpan(text: Cards.sumpf.cardName, style: TextStyle(color: CardType.flood.color)),
            const TextSpan(text: '.')
          ])),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.buschfeuer,
          Cards.buschfeuer.cardName,
          CardType.flame,
          false,
          40,
          (game, tis) {
            for (var card in game.cardsHand) {
              if ({CardType.flame, CardType.wizard, CardType.weather, CardType.weapon, CardType.artifact}
                      .contains(card.cardType) ||
                  card.name == Cards.gebirge.cardName ||
                  card.name == Cards.grosseFlut.cardName ||
                  card.name == Cards.insel.cardName ||
                  card.name == Cards.einhorn.cardName ||
                  card.name == Cards.drache.cardName) {
                // Eigentlich muss die Bedingung negiert werden, so ist es aber einfacher
              } else {
                game.blockCard(card);
              }
            }
          },
          (game, tis) {
            return 0;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
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
            TextSpan(text: Cards.gebirge.cardName, style: TextStyle(color: CardType.land.color)),
            const TextSpan(text: ', '),
            TextSpan(text: Cards.grosseFlut.cardName, style: TextStyle(color: CardType.flood.color)),
            const TextSpan(text: ', '),
            TextSpan(text: Cards.insel.cardName, style: TextStyle(color: CardType.flood.color)),
            const TextSpan(text: ', '),
            TextSpan(text: 'Einhorn', style: TextStyle(color: CardType.beast.color)),
            const TextSpan(text: ' und '),
            TextSpan(text: Cards.drache.cardName, style: TextStyle(color: CardType.beast.color)),
            const TextSpan(text: '.')
          ])),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.kerze,
          Cards.kerze.cardName,
          CardType.flame,
          false,
          2,
          (game, tis) {},
          (game, tis) {
            var aDeck = game.activeCards;
            if (contains(aDeck, Cards.buchDerVeraenderung.cardName) &&
                contains(aDeck, Cards.glockenturm.cardName) &&
                amountOf(aDeck, {CardType.wizard}) > 0) {
              return 100;
            }
            return 0;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: '+100 mit '),
            TextSpan(
                text: Cards.buchDerVeraenderung.cardName, style: TextStyle(color: CardType.artifact.color)),
            const TextSpan(text: ' und '),
            TextSpan(text: 'Glockenturm', style: TextStyle(color: CardType.land.color)),
            const TextSpan(text: ' sowie mindestens einem '),
            TextSpan(text: 'Zauberer', style: TextStyle(color: CardType.wizard.color)),
            const TextSpan(text: '.')
          ])),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.schmiede,
          Cards.schmiede.cardName,
          CardType.flame,
          false,
          9,
          (game, tis) {},
          (game, tis) {
            return amountOf(game.activeCards, {CardType.weapon, CardType.artifact}) * 9;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: '+9 für jede '),
            TextSpan(text: 'Waffe', style: TextStyle(color: CardType.weapon.color)),
            const TextSpan(text: ' und/oder jedes '),
            TextSpan(text: 'Artefakt', style: TextStyle(color: CardType.artifact.color)),
            const TextSpan(text: '.')
          ])),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.blitz,
          Cards.blitz.cardName,
          CardType.flame,
          false,
          11,
          (game, tis) {},
          (game, tis) {
            if (contains(game.activeCards, Cards.regensturm.cardName)) {
              return 30;
            }
            return 0;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: '+30 mit '),
            TextSpan(text: Cards.regensturm.cardName),
            const TextSpan(text: '.')
          ])),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.feuerwesen,
          Cards.feuerwesen.cardName,
          CardType.flame,
          false,
          4,
          (game, tis) {},
          (game, tis) {
            return amountOf(game.activeCards, {CardType.flame}, ids: {tis.id}) * 15;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: '+15 für jede andere '),
            TextSpan(text: 'Flamme', style: TextStyle(color: CardType.flame.color)),
            const TextSpan(text: '.')
          ])),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.quelleDesLebens,
          Cards.quelleDesLebens.cardName,
          CardType.flood,
          false,
          1,
          (game, tis) {},
          (game, tis) {
            var aDeck = game.activeCards;
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
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
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
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.sumpf,
          Cards.sumpf.cardName,
          CardType.flood,
          false,
          18,
          (game, tis) {},
          (game, tis) {
            return 0;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: '-3 für jede '),
            TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
            const TextSpan(text: ' und/oder '),
            TextSpan(text: 'Flamme', style: TextStyle(color: CardType.flame.color)),
            const TextSpan(text: '.')
          ])),
          (game, tis) {
            var aDeck = game.activeCards;

            if (containsID(aDeck, Cards.waldlaeufer) ||
                containsID(aDeck, Cards.kriegsschiff) ||
                containsID(game.activeCards, Cards.waldlaeuferNeu)) {
              return 3 * amountOf(aDeck, {CardType.flame});
            } else {
              return 3 * amountOf(aDeck, {CardType.flame, CardType.army});
            }
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.grosseFlut,
          Cards.grosseFlut.cardName,
          CardType.flood,
          false,
          32,
          (game, tis) {
            for (var card in game.cardsHand) {
              if (card.name != Cards.gebirge.cardName && card.name != Cards.blitz.cardName) {
                if (containsID(game.activeCards, Cards.waldlaeufer) ||
                    containsID(game.activeCards, Cards.kriegsschiff) ||
                    containsID(game.activeCards, Cards.waldlaeuferNeu)) {
                  if ({CardType.land, CardType.flame}.contains(card.cardType)) {
                    game.blockCard(card);
                  }
                } else {
                  if ({CardType.army, CardType.land, CardType.flame}.contains(card.cardType)) {
                    game.blockCard(card);
                  }
                }
              }
            }
          },
          (game, tis) {
            return 0;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: 'BLOCKIERT alle '),
            TextSpan(text: 'Armeen', style: TextStyle(color: CardType.army.color)),
            const TextSpan(text: ', alle '),
            TextSpan(text: 'Länder', style: TextStyle(color: CardType.land.color)),
            const TextSpan(text: ', ausser '),
            TextSpan(text: Cards.gebirge.cardName, style: TextStyle(color: CardType.land.color)),
            const TextSpan(text: ' und alle '),
            TextSpan(text: 'Flammen', style: TextStyle(color: CardType.flame.color)),
            const TextSpan(text: ' ausser '),
            TextSpan(text: Cards.blitz.cardName, style: TextStyle(color: CardType.flame.color)),
            const TextSpan(text: '.')
          ])),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.insel,
          Cards.insel.cardName,
          CardType.flood,
          true,
          14,
          (game, tis) {},
          (game, tis) {
            return 0;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: 'HEBT die Strafe einer beliebigen '),
            TextSpan(text: 'Flut', style: TextStyle(color: CardType.flood.color)),
            const TextSpan(text: ' oder '),
            TextSpan(text: 'Flamme', style: TextStyle(color: CardType.flame.color)),
            const TextSpan(text: ' AUF.')
          ])),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {},
          haction: (tis, context, game) async {
            final cardID = await Navigator.push(context, MaterialPageRoute<Cards>(builder: (context) {
              return CardSelector(
                selector: (card) =>
                    game.cardsHand.map((e) => e.name).contains(card.name) &&
                    (card.cardType == CardType.flame || card.cardType == CardType.flood),
                isExpansion: game.isExpansion,
              );
            }));
            if (cardID != null) {
              Card chosen = game.cardsHand.where((element) => element.id == cardID).first;
              chosen.hpenalty = (deck, tis) => 0;
              chosen.hblock = (deck, tis) {};
              tis.hasAction = false;
            }
          }),
      Card(
          Cards.wasserwesen,
          Cards.wasserwesen.cardName,
          CardType.flood,
          false,
          4,
          (game, tis) {},
          (game, tis) {
            return amountOf(game.activeCards, {CardType.flood}, ids: {tis.id}) * 15;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: '+15 für jede andere '),
            TextSpan(text: 'Flut', style: TextStyle(color: CardType.flood.color)),
            const TextSpan(text: '.')
          ])),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.gestaltwandler,
          Cards.gestaltwandler.cardName,
          CardType.wild,
          true,
          0,
          (game, tis) {},
          (game, tis) {
            return 0;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
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
          (game, tis) => 0,
          haufheben: (game, tis) {},
          haction: (tis, context, game) async {
            final cardId = await Navigator.push(context, MaterialPageRoute<Cards>(builder: (context) {
              return CardSelector(
                selector: (card) => {
                  CardType.artifact,
                  CardType.leader,
                  CardType.wizard,
                  CardType.weapon,
                  CardType.beast,
                }.contains(card.cardType),
                isExpansion: game.isExpansion,
              );
            }));
            if (cardId != null) {
              Card chosen = Deck().cards(game.isExpansion).firstWhere((element) => element.id == cardId);
              if ({
                CardType.artifact,
                CardType.leader,
                CardType.wizard,
                CardType.weapon,
                CardType.beast,
              }.contains(chosen.cardType)) {
                tis.name = chosen.name;
                tis.cardType = chosen.cardType;
              }
            }
          }),
      Card(
          Cards.spiegelung,
          Cards.spiegelung.cardName,
          CardType.wild,
          true,
          0,
          (game, tis) {},
          (game, tis) {
            return 0;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
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
          (game, tis) => 0,
          haufheben: (game, tis) {},
          haction: (tis, context, game) async {
            final cardID = await Navigator.push(context, MaterialPageRoute<Cards>(builder: (context) {
              return CardSelector(
                selector: (card) => {
                  CardType.army,
                  CardType.land,
                  CardType.weather,
                  CardType.flood,
                  CardType.flame
                }.contains(card.cardType),
                isExpansion: game.isExpansion,
              );
            }));
            if (cardID != null) {
              Card chosen = Deck().cards(game.isExpansion).firstWhere((element) => element.id == cardID);
              if ({CardType.army, CardType.land, CardType.weather, CardType.flood, CardType.flame}
                  .contains(chosen.cardType)) {
                tis.name = chosen.name;
                tis.cardType = chosen.cardType;
              }
            }
          }),
      Card(
          Cards.doppelgaenger,
          Cards.doppelgaenger.cardName,
          CardType.wild,
          true,
          0,
          (game, tis) {},
          (game, tis) {
            return 0;
          },
          RichText(
              text: const TextSpan(
                  style: TextStyle(color: mat.Colors.black),
                  text:
                      'Kann Namen, Basisstärke, Farbe und Strafe ABER NICHT DEN BONUS einer anderen Karte in deiner Hand kopieren.')),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {},
          haction: (tis, context, game) async {
            final cardID = await Navigator.push(context, MaterialPageRoute<Cards>(builder: (context) {
              return CardSelector(
                selector: (card) =>
                    game.cardsHand.map((e) => e.id).contains(card.id) && card.id != Cards.doppelgaenger,
                isExpansion: game.isExpansion,
              );
            }));
            if (cardID != null) {
              Card chosen =
                  Deck().cards(game.isExpansion).where((element) => element.id == cardID).elementAt(0);
              tis.name = chosen.name;
              tis.hpenalty = chosen.hpenalty;
              tis.cardType = chosen.cardType;
              tis.baseStrength = chosen.baseStrength;
              tis.hblock = chosen.hblock;
            }
          }),
      Card(
          Cards.gebirge,
          Cards.gebirge.cardName,
          CardType.land,
          false,
          9,
          (game, tis) {},
          (game, tis) {
            var aDeck = game.activeCards;
            if (contains(aDeck, Cards.rauch.cardName) && contains(aDeck, Cards.buschfeuer.cardName)) {
              return 50;
            }
            return 0;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: '+50 mit '),
            TextSpan(text: Cards.rauch.cardName, style: TextStyle(color: CardType.weather.color)),
            const TextSpan(text: ' und '),
            TextSpan(text: Cards.buschfeuer.cardName, style: TextStyle(color: CardType.flame.color)),
            const TextSpan(text: '. HEBT die Strafe auf allen '),
            TextSpan(text: 'Fluten', style: TextStyle(color: CardType.flood.color)),
            const TextSpan(text: ' AUF.')
          ])),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {
            for (var card in game.cardsHand) {
              if (card.cardType == CardType.flood) {
                card.hpenalty = (game, tis) => 0;
                card.hblock = (game, tis) {};
              }
            }
          }),
      Card(
          Cards.hoehle,
          Cards.hoehle.cardName,
          CardType.land,
          false,
          6,
          (game, tis) {},
          (game, tis) {
            var aDeck = game.activeCards;
            if (contains(aDeck, Cards.zwergeninfanterie.cardName) || contains(aDeck, Cards.drache.cardName)) {
              return 25;
            }
            return 0;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: '+25 mit '),
            TextSpan(text: Cards.zwergeninfanterie.cardName, style: TextStyle(color: CardType.army.color)),
            const TextSpan(text: ' oder '),
            TextSpan(text: Cards.drache.cardName, style: TextStyle(color: CardType.beast.color)),
            const TextSpan(text: '. HEBT die Strafe auf allen '),
            TextSpan(text: 'Wettern', style: TextStyle(color: CardType.weather.color)),
            const TextSpan(text: ' AUF.')
          ])),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {
            for (var card in game.cardsHand) {
              if (card.cardType == CardType.weather) {
                card.hpenalty = (game, tis) => 0;
                card.hblock = (game, tis) {};
              }
            }
          }),
      Card(
          Cards.glockenturm,
          Cards.glockenturm.cardName,
          CardType.land,
          false,
          8,
          (game, tis) {},
          (game, tis) {
            if (amountOf(game.activeCards, {CardType.wizard}) > 0) {
              return 15;
            }
            return 0;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: '+15 mit mindestens einem '),
            TextSpan(text: 'Zauberer', style: TextStyle(color: CardType.wizard.color)),
            const TextSpan(text: '.')
          ])),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.wald,
          Cards.wald.cardName,
          CardType.land,
          false,
          7,
          (game, tis) {},
          (game, tis) {
            return amountOf(game.activeCards, {CardType.beast}) * 12 +
                (contains(game.activeCards, Cards.elbenschuetzen.cardName) ? 12 : 0);
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: '+12 für jede '),
            TextSpan(text: 'Bestie', style: TextStyle(color: CardType.beast.color)),
            const TextSpan(text: ' und/oder '),
            TextSpan(text: Cards.elbenschuetzen.cardName, style: TextStyle(color: CardType.army.color)),
            const TextSpan(text: '.')
          ])),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.erdwesen,
          Cards.erdwesen.cardName,
          CardType.land,
          false,
          4,
          (game, tis) {},
          (game, tis) {
            return amountOf(game.activeCards, {CardType.land}, ids: {tis.id}) * 15;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: '+15 für jedes andere '),
            TextSpan(text: 'Land', style: TextStyle(color: CardType.land.color)),
            const TextSpan(text: '.')
          ])),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.kriegsschiff,
          Cards.kriegsschiff.cardName,
          CardType.weapon,
          false,
          23,
          (game, tis) {
            if (amountOf(game.activeCards, {CardType.flood}) == 0) {
              final card = game.cardsHand.where((card) => card.id == Cards.kriegsschiff).first;
              game.blockCard(card);
            }
          },
          (game, tis) {
            return 0;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: 'Ist BLOCKIERT wenn ohne '),
            TextSpan(text: 'Flut', style: TextStyle(color: CardType.flood.color)),
            const TextSpan(text: '.'),
            const TextSpan(text: 'HEBT das Wort '),
            TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
            const TextSpan(text: ' von allen Strafen auf allen '),
            TextSpan(text: 'Fluten', style: TextStyle(color: CardType.flood.color)),
            const TextSpan(text: ' AUF.')
          ])),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.zauberstab,
          Cards.zauberstab.cardName,
          CardType.weapon,
          false,
          1,
          (game, tis) {},
          (game, tis) {
            if (amountOf(game.activeCards, {CardType.wizard}) > 0) {
              return 25;
            }
            return 0;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: '+25 mit mindestens einem '),
            TextSpan(text: 'Zauberer', style: TextStyle(color: CardType.wizard.color)),
            const TextSpan(text: '.')
          ])),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.schwertVonKeth,
          Cards.schwertVonKeth.cardName,
          CardType.weapon,
          false,
          7,
          (game, tis) {},
          (game, tis) {
            if (amountOf(game.activeCards, {CardType.leader}) > 0) {
              if (contains(game.activeCards, Cards.schildVonKeth.cardName)) {
                return 40;
              } else {
                return 10;
              }
            }
            return 0;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: '+10 mit mindestens einem '),
            TextSpan(text: 'Anführer', style: TextStyle(color: CardType.leader.color)),
            const TextSpan(text: '. ODER +40 mit '),
            TextSpan(text: 'Anführer', style: TextStyle(color: CardType.leader.color)),
            const TextSpan(text: ' und '),
            TextSpan(text: Cards.schildVonKeth.cardName, style: TextStyle(color: CardType.artifact.color)),
            const TextSpan(text: '.')
          ])),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.elbischerBogen,
          Cards.elbischerBogen.cardName,
          CardType.weapon,
          false,
          3,
          (game, tis) {},
          (game, tis) {
            var aDeck = game.activeCards;
            if (contains(aDeck, Cards.elbenschuetzen.cardName) ||
                contains(aDeck, Cards.kriegsherr.cardName) ||
                contains(aDeck, Cards.herrDerBestien.cardName)) {
              return 30;
            }
            return 0;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: '+30 mit '),
            TextSpan(text: Cards.elbenschuetzen.cardName, style: TextStyle(color: CardType.army.color)),
            const TextSpan(text: ', '),
            TextSpan(text: Cards.kriegsherr.cardName, style: TextStyle(color: CardType.leader.color)),
            const TextSpan(text: ' oder '),
            TextSpan(text: 'Herr der Bestien', style: TextStyle(color: CardType.wizard.color)),
            const TextSpan(text: '.')
          ])),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.kampfzeppelin,
          Cards.kampfzeppelin.cardName,
          CardType.weapon,
          false,
          35,
          (game, tis) {
            if (deckContainsType(game, CardType.weather) || !deckContainsType(game, CardType.army)) {
              game.blockCard(tis);
            }
          },
          (game, tis) {
            return 0;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: 'Ist BLOCKIERT wenn ohne '),
            TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
            const TextSpan(text: '. Ist BLOCKIERT wenn zusammen mit '),
            TextSpan(text: 'Wetter', style: TextStyle(color: CardType.weather.color)),
            const TextSpan(text: '.')
          ])),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.regensturm,
          Cards.regensturm.cardName,
          CardType.weather,
          false,
          8,
          (game, tis) {
            for (var card in game.cardsHand) {
              if (card.cardType == CardType.flame && card.name != Cards.blitz.cardName) {
                game.blockCard(card);
              }
            }
          },
          (game, tis) {
            return amountOf(game.activeCards, {CardType.flood}) * 10;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: '+10 für jede '),
            TextSpan(text: 'Flut', style: TextStyle(color: CardType.flood.color)),
            const TextSpan(text: '. BLOCKIERT alle '),
            TextSpan(text: 'Flammen', style: TextStyle(color: CardType.flame.color)),
            const TextSpan(text: ', ausser '),
            TextSpan(text: Cards.blitz.cardName, style: TextStyle(color: CardType.flame.color)),
            const TextSpan(text: '.')
          ])),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.blizzard,
          Cards.blizzard.cardName,
          CardType.weather,
          false,
          30,
          (game, tis) {
            for (var card in game.cardsHand) {
              if (card.cardType == CardType.flood) {
                game.blockCard(card);
              }
            }
          },
          (game, tis) {
            return 0;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
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
          (game, tis) {
            if (containsID(game.activeCards, Cards.waldlaeufer) ||
                containsID(game.activeCards, Cards.waldlaeuferNeu)) {
              return amountOf(game.activeCards, {CardType.leader, CardType.beast, CardType.flame}) * 5;
            } else {
              return amountOf(
                      game.activeCards, {CardType.army, CardType.leader, CardType.beast, CardType.flame}) *
                  5;
            }
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.rauch,
          Cards.rauch.cardName,
          CardType.weather,
          false,
          27,
          (game, tis) {
            if (game.activeCards.where((card) => card.cardType == CardType.flame).isEmpty) {
              game.blockCard(tis);
            }
          },
          (game, tis) {
            return 0;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: 'Ist BLOCKIERT wenn ohne '),
            TextSpan(text: 'Flamme', style: TextStyle(color: CardType.flame.color)),
            const TextSpan(text: '.')
          ])),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.wirbelsturm,
          Cards.wirbelsturm.cardName,
          CardType.weather,
          false,
          13,
          (game, tis) {},
          (game, tis) {
            var aDeck = game.activeCards;
            if (contains(aDeck, Cards.regensturm.cardName) &&
                (contains(aDeck, Cards.blizzard.cardName) || contains(aDeck, Cards.grosseFlut.cardName))) {
              return 40;
            }
            return 0;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: '+40 mit '),
            TextSpan(text: Cards.regensturm.cardName, style: TextStyle(color: CardType.weather.color)),
            const TextSpan(text: ' und entweder '),
            TextSpan(text: Cards.blizzard.cardName, style: TextStyle(color: CardType.weather.color)),
            const TextSpan(text: ' oder '),
            TextSpan(text: Cards.grosseFlut.cardName, style: TextStyle(color: CardType.flood.color)),
            const TextSpan(text: '.')
          ])),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.luftwesen,
          Cards.luftwesen.cardName,
          CardType.weather,
          false,
          4,
          (game, tis) {},
          (game, tis) {
            return amountOf(game.activeCards, {CardType.weather}, ids: {tis.id}) * 15;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: '+15 für jedes andere '),
            TextSpan(text: 'Wetter', style: TextStyle(color: CardType.weather.color)),
            const TextSpan(text: '.')
          ])),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.sammler,
          Cards.sammler.cardName,
          CardType.wizard,
          false,
          7,
          (game, tis) {},
          (game, tis) {
            HashSet<Card> set = HashSet(
                equals: (card1, card2) => card1.compareTo(card2) == 0,
                hashCode: (card) => card.name.hashCode);
            set.addAll(game.activeCards);
            int max = set
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
                  style: TextStyle(color: mat.Colors.black),
                  text:
                      '+10 für drei unterschiedliche Karten der gleichen Farbe, +40 für vier Karten der gleichen Farbe, +100 für fünf unterschiedliche Karten der gleichen Farbe')),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.herrDerBestien,
          Cards.herrDerBestien.cardName,
          CardType.wizard,
          false,
          9,
          (game, tis) {},
          (game, tis) {
            return amountOf(game.activeCards, {CardType.beast}) * 9;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: '+9 für jede '),
            TextSpan(text: 'Bestie', style: TextStyle(color: CardType.beast.color)),
            const TextSpan(text: '. HEBT die Strafen auf allen '),
            TextSpan(text: 'Bestien', style: TextStyle(color: CardType.beast.color)),
            const TextSpan(text: ' AUF.')
          ])),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {
            for (var card in game.cardsHand) {
              if (card.cardType == CardType.beast) {
                card.hpenalty = (game, tis) => 0;
                card.hblock = (game, tis) {};
              }
            }
          }),
      Card(
          Cards.totenbeschwoerer,
          Cards.totenbeschwoerer.cardName,
          CardType.wizard,
          false,
          3,
          (game, tis) {},
          (game, tis) {
            return 0;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
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
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.hexenmeister,
          Cards.hexenmeister.cardName,
          CardType.wizard,
          false,
          25,
          (game, tis) {},
          (game, tis) {
            return 0;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: '-10 für jeden '),
            TextSpan(text: 'Anführer', style: TextStyle(color: CardType.leader.color)),
            const TextSpan(text: ' und/oder anderen '),
            TextSpan(text: 'Zauberer', style: TextStyle(color: CardType.wizard.color)),
            const TextSpan(text: '.')
          ])),
          (game, tis) {
            return amountOf(game.activeCards, {CardType.leader, CardType.wizard}, ids: {tis.id}) * 10;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.magierin,
          Cards.magierin.cardName,
          CardType.wizard,
          false,
          5,
          (game, tis) {},
          (game, tis) {
            return amountOf(
                    game.activeCards, {CardType.land, CardType.flood, CardType.weather, CardType.flame}) *
                5;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
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
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.hofnarr,
          Cards.hofnarr.cardName,
          CardType.wizard,
          false,
          3,
          (game, tis) {},
          (game, tis) {
            if (game.activeCards.where((card) => card.baseStrength % 2 == 0).isEmpty) {
              return 50;
            }
            return game.activeCards
                    .where((card) => card.name != 'Hofnarr' && card.baseStrength % 2 == 1)
                    .length *
                3;
          },
          RichText(
              text: const TextSpan(
                  style: TextStyle(color: mat.Colors.black),
                  text:
                      '+3 für jede andere Karte mit einer ungeraden Basisstärke. ODER +50 wenn alle Karten eine ungerade Basisstärke haben.')),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.totenbeschwoererNeu,
          Cards.totenbeschwoererNeu.cardName,
          CardType.wizard,
          false,
          3,
          (game, tis) {
            for (Card card in game.cardsHand) {
              if (card.cardType == CardType.undead) {
                game.setUnblockable(card);
              }
            }
          },
          (game, tis) {
            return 0;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: 'Du darfst am Spielende einer '),
            TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
            const TextSpan(text: ', '),
            TextSpan(text: 'Anführer', style: TextStyle(color: CardType.leader.color)),
            const TextSpan(text: ', '),
            TextSpan(text: 'Zauberer', style: TextStyle(color: CardType.wizard.color)),
            const TextSpan(text: ', '),
            TextSpan(text: 'Bestie', style: TextStyle(color: CardType.beast.color)),
            const TextSpan(text: ' oder '),
            TextSpan(text: 'Untote', style: TextStyle(color: CardType.undead.color)),
            const TextSpan(text: ' aus dem Ablagefach nehmen. '),
            TextSpan(text: 'Untote', style: TextStyle(color: CardType.undead.color)),
            const TextSpan(text: ' können nicht BLOCKIERT werden.'),
          ])),
          (game, tis) {
            return 0;
          },
          haufheben: (game, tis) {}),
      Card(
          Cards.gruft,
          Cards.gruft.cardName,
          CardType.building,
          false,
          21,
          (game, tis) {
            for (Card card in game.cardsHand) {
              if (card.cardType == CardType.leader) game.blockCard(card);
            }
          },
          (game, tis) {
            return game.activeCards
                .where((c) => c.cardType == CardType.undead)
                .fold(0, (p, el) => p + el.baseStrength);
          },
          RichText(
              text: TextSpan(
            style: const TextStyle(color: mat.Colors.black),
            children: [
              const TextSpan(text: 'BONUS: Die Summe der Basisstärke aller '),
              TextSpan(text: 'Untoten', style: TextStyle(color: CardType.undead.color)),
              const TextSpan(text: '. STRAFE: BLOCKIERT alle '),
              TextSpan(text: 'Anführer', style: TextStyle(color: CardType.leader.color)),
              const TextSpan(text: '.'),
            ],
          )),
          (game, tis) {
            return 0;
          },
          haufheben: (hand, Card tis) {}),
      Card(
          Cards.ghul,
          Cards.ghul.cardName,
          CardType.undead,
          false,
          8,
          (game, tis) {},
          (game, tis) {
            return game.cardsAblage
                .where((card) => {
                      CardType.wizard,
                      CardType.leader,
                      CardType.army,
                      CardType.beast,
                      CardType.undead
                    }.contains(card.cardType))
                .fold(0, (prev, card) => prev + 4);
          },
          RichText(
              text: TextSpan(
            style: const TextStyle(color: mat.Colors.black),
            children: [
              const TextSpan(text: 'BONUS: +4 für jeden '),
              TextSpan(text: 'Zauberer', style: TextStyle(color: CardType.wizard.color)),
              const TextSpan(text: ', '),
              TextSpan(text: 'Anführer', style: TextStyle(color: CardType.leader.color)),
              const TextSpan(text: ', '),
              TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
              const TextSpan(text: ', '),
              TextSpan(text: 'Bestie', style: TextStyle(color: CardType.beast.color)),
              const TextSpan(text: ' und/oder '),
              TextSpan(text: 'Untoten', style: TextStyle(color: CardType.undead.color)),
              const TextSpan(text: ' im Ablagebereich.'),
            ],
          )),
          (game, tis) {
            return 0;
          },
          haufheben: (hand, Card tis) {}),
      Card(
          Cards.gespenst,
          Cards.gespenst.cardName,
          CardType.undead,
          false,
          12,
          (game, tis) {},
          (game, tis) {
            return game.cardsAblage
                .where((card) => {
                      CardType.wizard,
                      CardType.artifact,
                      CardType.outsider,
                    }.contains(card.cardType))
                .fold(0, (prev, card) => prev + 6);
          },
          RichText(
              text: TextSpan(
            style: const TextStyle(color: mat.Colors.black),
            children: [
              const TextSpan(text: 'BONUS: +6 für jeden '),
              TextSpan(text: 'Zauberer', style: TextStyle(color: CardType.wizard.color)),
              const TextSpan(text: ', '),
              TextSpan(text: 'Artefakt', style: TextStyle(color: CardType.artifact.color)),
              const TextSpan(text: ' und/oder '),
              TextSpan(text: 'Outsider', style: TextStyle(color: CardType.outsider.color)),
              const TextSpan(text: ' im Ablagebereich.'),
            ],
          )),
          (game, tis) {
            return 0;
          },
          haufheben: (hand, Card tis) {}),
      Card(
          Cards.dunkleKoenigin,
          Cards.dunkleKoenigin.cardName,
          CardType.undead,
          false,
          10,
          (game, tis) {},
          (game, tis) {
            return game.cardsAblage
                .where((card) =>
                    {
                      CardType.land,
                      CardType.flood,
                      CardType.flame,
                      CardType.weather,
                    }.contains(card.cardType) ||
                    card.name == Cards.einhorn.cardName)
                .fold(0, (prev, card) => prev + 5);
          },
          RichText(
              text: TextSpan(
            style: const TextStyle(color: mat.Colors.black),
            children: [
              const TextSpan(text: 'BONUS: +5 für jedes '),
              TextSpan(text: 'Land', style: TextStyle(color: CardType.land.color)),
              const TextSpan(text: ', '),
              TextSpan(text: 'Flut', style: TextStyle(color: CardType.flood.color)),
              const TextSpan(text: ', '),
              TextSpan(text: 'Flamme', style: TextStyle(color: CardType.flame.color)),
              const TextSpan(text: ', '),
              TextSpan(text: 'Wetter', style: TextStyle(color: CardType.weather.color)),
              const TextSpan(text: ' und/oder '),
              TextSpan(text: 'Einhorn', style: TextStyle(color: CardType.beast.color)),
              const TextSpan(text: ' im Ablagebereich.'),
            ],
          )),
          (game, tis) {
            return 0;
          },
          haufheben: (hand, Card tis) {}),
      Card(
          Cards.kapelle,
          Cards.kapelle.cardName,
          CardType.building,
          false,
          2,
          (game, tis) {},
          (game, tis) {
            var length = game.activeCards
                .where((element) => {CardType.leader, CardType.wizard, CardType.outsider, CardType.undead}
                    .contains(element.cardType))
                .length;
            if (length == 2) {
              return 40;
            }
            return 0;
          },
          RichText(
              text: TextSpan(
            style: const TextStyle(color: mat.Colors.black),
            children: [
              const TextSpan(
                  text: 'BONUS: +40 wenn Du insgesamt genau zwei Karten der folgenden Farben hast: '),
              TextSpan(text: 'Anführer', style: TextStyle(color: CardType.leader.color)),
              const TextSpan(text: ','),
              TextSpan(text: 'Zauberer', style: TextStyle(color: CardType.wizard.color)),
              const TextSpan(text: ', '),
              TextSpan(text: 'Outsider', style: TextStyle(color: CardType.outsider.color)),
              const TextSpan(text: ' und '),
              TextSpan(text: 'Untote', style: TextStyle(color: CardType.undead.color)),
              const TextSpan(text: '.'),
            ],
          )),
          (game, tis) {
            return 0;
          },
          haufheben: (hand, Card tis) {}),
      Card(
          Cards.dschinn,
          Cards.dschinn.cardName,
          CardType.outsider,
          true,
          -50,
          (game, tis) {},
          (game, tis) {
            return 0;
          },
          RichText(
              text: TextSpan(
            style: const TextStyle(color: mat.Colors.black),
            children: [
              const TextSpan(
                  text:
                      'BONUS: +10 pro Mitspieler. Du darfst am Spielende den Nachziehstapel durchsuchen und eine Karte davon auf die Hand nehmen. (Wird nach dem '),
              TextSpan(text: 'Kobold', style: TextStyle(color: CardType.outsider.color)),
              const TextSpan(text: ' ausgeführt.)'),
            ],
          )),
          (game, tis) {
            return 0;
          },
          haufheben: (hand, Card tis) {},
          haction: (tis, context, game) async {
            final int? playerNumber =
                await Navigator.push<int>(context, MaterialPageRoute<int>(builder: (context) {
              return const NumberPickerWidget();
            }));
            if (playerNumber != null) {
              tis.hbonus = (game, tis) => playerNumber * 10;
            }
          }),
      Card(
          Cards.daemon,
          Cards.daemon.cardName,
          CardType.outsider,
          false,
          45,
          (game, tis) {
            for (Card card in game.cardsHand) {
              if (card.cardType != CardType.outsider) {
                int count = game.cardsHand.map((c) => c.cardType == card.cardType).length;
                if (count == 1) {
                  game.blockCard(card);
                }
              }
            }
          },
          (game, tis) {
            return 0;
          },
          RichText(
              text: TextSpan(
            style: const TextStyle(color: mat.Colors.black),
            children: [
              const TextSpan(text: 'STRAFE: Für jede nicht-'),
              TextSpan(text: 'Outsider', style: TextStyle(color: CardType.outsider.color)),
              const TextSpan(
                  text:
                      ' Karte: Wenn diese Karte die einzige Karte ihrer Farbe auf Deiner Hand ist, ist sie BLOCKIERT. Dies geschieht vor allen anderen BLOCKIERUNGEN.)'),
            ],
          )),
          (game, tis) {
            return 0;
          },
          haufheben: (hand, Card tis) {}),
      Card(
          Cards.quelleDesLebensNeu,
          Cards.quelleDesLebensNeu.cardName,
          CardType.flood,
          false,
          1,
          (game, tis) {},
          (game, tis) {
            return game.cardsHand
                .where((c) => {
                      CardType.weapon,
                      CardType.building,
                      CardType.flood,
                      CardType.flame,
                      CardType.land,
                      CardType.weather
                    }.contains(c.cardType))
                .fold<int>(0, (prev, el) => el.baseStrength > prev ? el.baseStrength : prev);
          },
          RichText(
              text: TextSpan(
            style: const TextStyle(color: mat.Colors.black),
            children: [
              const TextSpan(text: 'BONUS: Addiere die Basisstärke einer beliebigen'),
              TextSpan(text: 'Waffe', style: TextStyle(color: CardType.weapon.color)),
              const TextSpan(text: ', '),
              TextSpan(text: 'Gebäude', style: TextStyle(color: CardType.building.color)),
              const TextSpan(text: ', '),
              TextSpan(text: 'Flut', style: TextStyle(color: CardType.flood.color)),
              const TextSpan(text: ', '),
              TextSpan(text: 'Flamme', style: TextStyle(color: CardType.flame.color)),
              const TextSpan(text: ', '),
              TextSpan(text: 'Land', style: TextStyle(color: CardType.land.color)),
              const TextSpan(text: ' oder '),
              TextSpan(text: 'Wetter', style: TextStyle(color: CardType.weather.color)),
              const TextSpan(text: '.'),
            ],
          )),
          (game, tis) {
            return 0;
          },
          haufheben: (hand, Card tis) {}),
      Card(
          Cards.burg,
          Cards.burg.cardName,
          CardType.building,
          false,
          10,
          (game, tis) {},
          (game, tis) {
            int bonus = 0;
            if (activeDeckContainsType(game, CardType.army)) {
              bonus += 10;
            }
            if (activeDeckContainsType(game, CardType.leader)) {
              bonus += 10;
            }
            if (activeDeckContainsType(game, CardType.land)) {
              bonus += 10;
            }
            bonus += max(0, (amountOf(game.activeCards, {CardType.building}) - 1) * 5);
            return bonus;
          },
          RichText(
              text: TextSpan(
            style: const TextStyle(color: mat.Colors.black),
            children: [
              const TextSpan(text: 'BONUS: +10 für jeweils den ersten '),
              TextSpan(text: 'Anführer', style: TextStyle(color: CardType.leader.color)),
              const TextSpan(text: ', '),
              TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
              const TextSpan(text: ', '),
              TextSpan(text: 'Land', style: TextStyle(color: CardType.land.color)),
              const TextSpan(text: ', '),
              TextSpan(text: 'Gebäude', style: TextStyle(color: CardType.building.color)),
              const TextSpan(text: '. +5 für jedes weitere '),
              TextSpan(text: 'Gebäude', style: TextStyle(color: CardType.building.color)),
              const TextSpan(text: '.'),
            ],
          )),
          (game, tis) {
            return 0;
          },
          haufheben: (hand, Card tis) {}),
      Card(
          Cards.todesritter,
          Cards.todesritter.cardName,
          CardType.undead,
          false,
          14,
          (game, tis) {},
          (game, tis) {
            return game.cardsAblage
                    .where((c) => {CardType.weapon, CardType.army}.contains(c.cardType))
                    .length *
                7;
          },
          RichText(
              text: TextSpan(
            style: const TextStyle(color: mat.Colors.black),
            children: [
              const TextSpan(text: 'BONUS: +7 für jede '),
              TextSpan(text: 'Waffe', style: TextStyle(color: CardType.weapon.color)),
              const TextSpan(text: ' und/oder '),
              TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
              const TextSpan(text: ' im Ablagebereich.'),
            ],
          )),
          (game, tis) {
            return 0;
          },
          haufheben: (hand, Card tis) {}),
      Card(
          Cards.kobold,
          Cards.kobold.cardName,
          CardType.outsider,
          false,
          20,
          (game, tis) {},
          (game, tis) {
            return 0;
          },
          RichText(
              text: TextSpan(
            style: const TextStyle(color: mat.Colors.black),
            children: [
              const TextSpan(
                  text:
                      'BONUS: Ziehe am Spielende die oberste Karte des Nachziehstapels und nimm sie auf die Hand. (wird vor dem '),
              TextSpan(text: Cards.dschinn.cardName, style: TextStyle(color: CardType.outsider.color)),
              const TextSpan(text: ' ausgeführt.) '),
            ],
          )),
          (game, tis) {
            return 0;
          },
          haufheben: (hand, Card tis) {}),
      Card(
          Cards.waldlaeuferNeu,
          Cards.waldlaeuferNeu.cardName,
          CardType.army,
          false,
          5,
          (game, tis) {},
          (game, tis) {
            return amountOf(game.activeCards, {CardType.land, CardType.building}) * 10;
          },
          RichText(
              text: TextSpan(
            style: const TextStyle(color: mat.Colors.black),
            children: [
              const TextSpan(text: 'BONUS: +10 für jedes '),
              TextSpan(text: 'Land', style: TextStyle(color: CardType.land.color)),
              const TextSpan(text: ' und '),
              TextSpan(text: 'Gebäude', style: TextStyle(color: CardType.building.color)),
              const TextSpan(text: ' . HEBT das Wort '),
              TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
              const TextSpan(text: ' von allen Strafen AUF.'),
            ],
          )),
          (game, tis) {
            return 0;
          },
          haufheben: (hand, Card tis) {}),
      Card(
          Cards.glockenturmNeu,
          Cards.glockenturmNeu.cardName,
          CardType.building,
          false,
          8,
          (game, tis) {},
          (game, tis) {
            if (activeDeckContainsType(game, CardType.wizard) ||
                activeDeckContainsType(game, CardType.undead)) {
              return 15;
            }
            return 0;
          },
          RichText(
              text: TextSpan(
            style: const TextStyle(color: mat.Colors.black),
            children: [
              const TextSpan(text: 'BONUS: +15 mit mindestens einem '),
              TextSpan(text: 'Zauberer', style: TextStyle(color: CardType.wizard.color)),
              const TextSpan(text: ' oder '),
              TextSpan(text: 'Untoten', style: TextStyle(color: CardType.undead.color)),
              const TextSpan(text: '.'),
            ],
          )),
          (game, tis) {
            return 0;
          },
          haufheben: (hand, Card tis) {}),
      Card(
          Cards.grosseFlutNeu,
          Cards.grosseFlutNeu.cardName,
          CardType.flood,
          false,
          32,
          (game, tis) {
            for (var card in game.cardsHand) {
              if (card.name != Cards.gebirge.cardName && card.name != Cards.blitz.cardName) {
                if (containsID(game.activeCards, Cards.waldlaeufer) ||
                    containsID(game.activeCards, Cards.kriegsschiff) ||
                    containsID(game.activeCards, Cards.waldlaeuferNeu)) {
                  if ({CardType.land, CardType.flame, CardType.building}.contains(card.cardType)) {
                    game.blockCard(card);
                  }
                } else {
                  if ({CardType.army, CardType.land, CardType.flame, CardType.building}
                      .contains(card.cardType)) {
                    game.blockCard(card);
                  }
                }
              }
            }
          },
          (game, tis) {
            return 0;
          },
          RichText(
              text: TextSpan(
            style: const TextStyle(color: mat.Colors.black),
            children: [
              const TextSpan(text: 'Strafe: BLOCKIERT alle '),
              TextSpan(text: 'Armeen', style: TextStyle(color: CardType.army.color)),
              const TextSpan(text: ', '),
              TextSpan(text: 'Gebäude', style: TextStyle(color: CardType.building.color)),
              const TextSpan(text: ', alle '),
              TextSpan(text: 'Länder', style: TextStyle(color: CardType.land.color)),
              const TextSpan(text: ', außer '),
              TextSpan(text: 'Gebirge', style: TextStyle(color: CardType.land.color)),
              const TextSpan(text: ' und alle '),
              TextSpan(text: 'Flammen', style: TextStyle(color: CardType.flame.color)),
              const TextSpan(text: ' außer '),
              TextSpan(text: 'Blitz', style: TextStyle(color: CardType.flame.color)),
              const TextSpan(text: '.'),
            ],
          )),
          (game, tis) {
            return 0;
          },
          haufheben: (hand, Card tis) {}),
      Card(
          Cards.spiegelungNeu,
          Cards.spiegelungNeu.cardName,
          CardType.wild,
          true,
          0,
          (game, tis) {},
          (game, tis) {
            return 0;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: 'Kann Namen und Farbe einer beliebigen '),
            TextSpan(text: 'Armee', style: TextStyle(color: CardType.army.color)),
            const TextSpan(text: ', '),
            TextSpan(text: 'Land', style: TextStyle(color: CardType.land.color)),
            const TextSpan(text: ', '),
            TextSpan(text: 'Gebäude', style: TextStyle(color: CardType.building.color)),
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
          (game, tis) {
            return 0;
          },
          haufheben: (hand, Card tis) {},
          haction: (tis, context, game) async {
            final cardID = await Navigator.push(context, MaterialPageRoute<Cards>(builder: (context) {
              return CardSelector(
                selector: (card) => {
                  CardType.army,
                  CardType.land,
                  CardType.weather,
                  CardType.flood,
                  CardType.flame,
                  CardType.building
                }.contains(card.cardType),
                isExpansion: game.isExpansion,
              );
            }));
            if (cardID != null) {
              Card chosen = Deck().cards(game.isExpansion).firstWhere((element) => element.id == cardID);
              tis.name = chosen.name;
              tis.cardType = chosen.cardType;
            }
          }),
      Card(
          Cards.weltenbaumNeu,
          Cards.weltenbaumNeu.cardName,
          CardType.artifact,
          false,
          2,
          (game, tis) {},
          (game, tis) {
            var aDeck = game.activeCards;
            var types = aDeck.map((e) => e.cardType).toSet();
            if (aDeck.length == types.length) {
              return 70;
            }
            return 0;
          },
          RichText(
              text: const TextSpan(
            style: TextStyle(color: mat.Colors.black),
            children: [
              TextSpan(text: 'BONUS: +70 wenn jede Nicht-BLOCKIERTE Karte eine unterschiedliche Farbe hat.'),
            ],
          )),
          (game, tis) {
            return 0;
          },
          haufheben: (hand, Card tis) {}),
      Card(
          Cards.gestaltwandlerNeu,
          Cards.gestaltwandlerNeu.cardName,
          CardType.wild,
          true,
          0,
          (game, tis) {},
          (game, tis) {
            return 0;
          },
          RichText(
              text: TextSpan(style: const TextStyle(color: mat.Colors.black), children: [
            const TextSpan(text: 'Kann Namen und Farbe eines beliebigen '),
            TextSpan(text: 'Artefakts', style: TextStyle(color: CardType.artifact.color)),
            const TextSpan(text: ', '),
            TextSpan(text: 'Untoten', style: TextStyle(color: CardType.artifact.color)),
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
          (game, tis) => 0,
          haufheben: (game, tis) {},
          haction: (tis, context, game) async {
            final cardId = await Navigator.push(context, MaterialPageRoute<Cards>(builder: (context) {
              return CardSelector(
                selector: (card) => {
                  CardType.artifact,
                  CardType.leader,
                  CardType.wizard,
                  CardType.weapon,
                  CardType.beast,
                  CardType.undead,
                }.contains(card.cardType),
                isExpansion: game.isExpansion,
              );
            }));
            if (cardId != null) {
              Card chosen = Deck().cards(game.isExpansion).firstWhere((element) => element.id == cardId);
              tis.name = chosen.name;
              tis.cardType = chosen.cardType;
            }
          }),
      Card(
          Cards.engel,
          Cards.engel.cardName,
          CardType.outsider,
          true,
          16,
          (game, tis) {},
          (game, tis) {
            return 0;
          },
          RichText(
              text: const TextSpan(
            style: TextStyle(color: mat.Colors.black),
            children: [
              TextSpan(
                  text:
                      'BONUS: Diese Karte kann niemals BLOCKIERT werden. Bewahrt eine beliebige andere Karte davor, BLOCKIERT zu werden.'),
            ],
          )),
          (game, tis) {
            return 0;
          },
          haufheben: (hand, Card tis) {},
          haction: (tis, context, game) async {
            final cardId = await Navigator.push(context, MaterialPageRoute<Cards>(builder: (context) {
              return CardSelector(
                selector: (card) => game.cardsHand.where((c) => !game.isActiveHand(c)).contains(card),
                isExpansion: game.isExpansion,
              );
            }));
            if (cardId != null) {
              Card chosen = Deck().cards(game.isExpansion).firstWhere((element) => element.id == cardId);
              game.setUnblockable(chosen);
            }
          }),
      Card(
        Cards.lich,
        Cards.lich.cardName,
        CardType.undead,
        false,
        13,
        (game, tis) {
          for (Card card in game.cardsHand) {
            if (card.cardType == CardType.undead) {
              game.setUnblockable(card);
            }
          }
        },
        (game, tis) {
          int bonus = game.activeCards
                  .where((element) => element.id != tis.id && element.cardType == CardType.undead)
                  .length *
              10;
          if (game.activeCards.map((e) => e.id).contains(Cards.totenbeschwoererNeu)) bonus += 10;
          return bonus;
        },
        RichText(
            text: TextSpan(
          style: const TextStyle(color: mat.Colors.black),
          children: [
            const TextSpan(text: 'BONUS: +10 für'),
            TextSpan(text: Cards.totenbeschwoerer.cardName, style: TextStyle(color: CardType.wizard.color)),
            const TextSpan(text: ' und jeden anderen '),
            TextSpan(text: 'Untoten', style: TextStyle(color: CardType.undead.color)),
            const TextSpan(text: '. '),
            TextSpan(text: 'Untote', style: TextStyle(color: CardType.undead.color)),
            const TextSpan(text: ' können nicht BLOCKIERT werden.'),
          ],
        )),
        (game, tis) {
          return 0;
        },
        haufheben: (hand, Card tis) {},
      ),
      Card(
        Cards.garten,
        Cards.garten.cardName,
        CardType.land,
        false,
        11,
        (game, tis) {
          if (amountOf(game.activeCards, {CardType.undead}) > 0 ||
              containsID(game.activeCards, Cards.totenbeschwoererNeu) ||
              containsID(game.activeCards, Cards.daemon)) {
            game.blockCard(tis);
          }
        },
        (game, tis) {
          return amountOf(game.activeCards, {CardType.beast, CardType.leader}) * 11;
        },
        RichText(
            text: TextSpan(
          style: const TextStyle(color: mat.Colors.black),
          children: [
            const TextSpan(text: 'BONUS: +11 für jeden'),
            TextSpan(text: 'Anführer', style: TextStyle(color: CardType.leader.color)),
            const TextSpan(text: ' und/oder '),
            TextSpan(text: 'Bestie', style: TextStyle(color: CardType.beast.color)),
            const TextSpan(text: '. STRAFE: Ist BLOCKIERT, wenn zusammen mit '),
            TextSpan(text: 'Untote', style: TextStyle(color: CardType.undead.color)),
            const TextSpan(text: ', '),
            TextSpan(text: Cards.totenbeschwoerer.cardName, style: TextStyle(color: CardType.wizard.color)),
            const TextSpan(text: ' und/oder '),
            TextSpan(text: Cards.daemon.cardName, style: TextStyle(color: CardType.outsider.color)),
            const TextSpan(text: '.'),
          ],
        )),
        (game, tis) {
          return 0;
        },
        haufheben: (hand, Card tis) {},
      ),
      Card(
        Cards.richter,
        Cards.richter.cardName,
        CardType.outsider,
        false,
        11,
        (game, tis) {},
        (game, tis) {
          return 0; // TODO: Bonus implementieren.
        },
        RichText(
            text: const TextSpan(
          style: TextStyle(color: mat.Colors.black),
          children: [
            TextSpan(text: 'BONUS: +10 für jede Karte, die eine Strafe enthällt, die nicht AUFGEHOBEN ist.'),
          ],
        )),
        (game, tis) {
          return 0;
        },
        haufheben: (hand, Card tis) {},
      ),
      Card(
        Cards.verlies,
        Cards.verlies.cardName,
        CardType.building,
        false,
        7,
        (game, tis) {},
        (game, tis) {
          int bonus = 0;
          if (activeDeckContainsType(game, CardType.undead)) {
            bonus += 10;
          }
          if (activeDeckContainsType(game, CardType.beast)) {
            bonus += 10;
          }
          if (activeDeckContainsType(game, CardType.artifact)) {
            bonus += 10;
          }
          bonus += max(0, (amountOf(game.activeCards, {CardType.undead}) - 1) * 5);
          bonus += max(0, (amountOf(game.activeCards, {CardType.beast}) - 1) * 5);
          bonus += max(0, (amountOf(game.activeCards, {CardType.artifact}) - 1) * 5);
          if (containsID(game.activeCards, Cards.totenbeschwoererNeu)) {
            bonus += 5;
          }
          if (containsID(game.activeCards, Cards.kriegsherr)) {
            bonus += 5;
          }
          if (containsID(game.activeCards, Cards.daemon)) {
            bonus += 5;
          }
          return bonus;
        },
        RichText(
            text: TextSpan(
          style: const TextStyle(color: mat.Colors.black),
          children: [
            const TextSpan(text: 'BONUS: +10 für jeweils den ersten '),
            TextSpan(text: 'Untoten', style: TextStyle(color: CardType.undead.color)),
            const TextSpan(text: ', '),
            TextSpan(text: 'Bestie', style: TextStyle(color: CardType.beast.color)),
            const TextSpan(text: ' und '),
            TextSpan(text: 'Artefakt', style: TextStyle(color: CardType.artifact.color)),
            const TextSpan(text: '. +5 für jede weitere Karte dieser Farben sowie '),
            TextSpan(text: Cards.totenbeschwoerer.cardName, style: TextStyle(color: CardType.wizard.color)),
            const TextSpan(text: ', '),
            TextSpan(text: Cards.kriegsherr.cardName, style: TextStyle(color: CardType.leader.color)),
            const TextSpan(text: ', '),
            TextSpan(text: Cards.daemon.cardName, style: TextStyle(color: CardType.outsider.color)),
            const TextSpan(text: '.'),
          ],
        )),
        (game, tis) {
          return 0;
        },
        haufheben: (hand, Card tis) {},
      )
    ];
  }
}
