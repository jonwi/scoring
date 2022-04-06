import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:scoring/game.dart';

part 'card.g.dart';

enum CardType {
  weather,
  wizard,
  weapon,
  land,
  wild,
  flood,
  flame,
  army,
  artifact,
  leader,
  beast,
  building,
  undead,
  outsider,
}

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
        return 'Bestie';
      case CardType.building:
        return 'Gebäude';
      case CardType.undead:
        return 'Untote';
      case CardType.outsider:
        return 'Outsider';
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
        return const Color(0xFF422525);
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
      case CardType.building:
        return const Color(0xff0b203f);
      case CardType.undead:
        return const Color(0xFF023A35);
      case CardType.outsider:
        return const Color(0xFFC59D01);
    }
  }

  /// Gives a Text Color to contrast with color
  Color get textColor {
    return {CardType.army, CardType.leader, CardType.land, CardType.undead, CardType.building}.contains(this)
        ? Colors.white
        : Colors.black;
  }
}

class Card implements Comparable<Card> {
  String name;
  bool hasAction;
  CardType cardType;
  int baseStrength;
  Widget description;
  Cards id;

  void Function(Game, Card tis) hblock;
  void Function(Game, Card tis) haufheben;
  int Function(Game, Card tis) hbonus;

  // function has to be overwritten
  Future<void> Function(Card tis, BuildContext, Game)? haction;

  // Returns a penalty that is subtracted from the overall strength of the card
  int Function(Game, Card tis) hpenalty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Card && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  Card(this.id, this.name, this.cardType, this.hasAction, this.baseStrength, this.hblock, this.hbonus,
      this.description, this.hpenalty,
      {required this.haufheben, this.haction});

  void block(Game game) {
    hblock(game, this);
  }

  void aufheben(Game game) {
    haufheben(game, this);
  }

  int bonus(Game game) {
    return hbonus(game, this);
  }

  int penalty(Game game) {
    return hpenalty(game, this);
  }

  int calculateStrength(Game game) {
    return baseStrength + bonus(game) - penalty(game);
  }

  Future<void> executeAction(BuildContext context, Game game) async {
    if (haction != null) {
      await haction!(this, context, game);
    }
  }

  @override
  int compareTo(Card other) {
    return name.compareTo(other.name);
  }

  @override
  String toString() {
    return name;
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
  @HiveField(54)
  gruft,
  @HiveField(55)
  ghul,
  @HiveField(56)
  gespenst,
  @HiveField(57)
  dunkleKoenigin,
  @HiveField(58)
  kapelle,
  @HiveField(59)
  dschinn,
  @HiveField(60)
  daemon,
  @HiveField(61)
  quelleDesLebensNeu,
  @HiveField(62)
  burg,
  @HiveField(63)
  totenbeschwoererNeu,
  @HiveField(64)
  todesritter,
  @HiveField(65)
  kobold,
  @HiveField(66)
  waldlaeuferNeu,
  @HiveField(67)
  glockenturmNeu,
  @HiveField(68)
  grosseFlutNeu,
  @HiveField(69)
  spiegelungNeu,
  @HiveField(70)
  weltenbaumNeu,
  @HiveField(71)
  gestaltwandlerNeu,
  @HiveField(72)
  engel,
  @HiveField(73)
  lich,
  @HiveField(74)
  richter,
  @HiveField(75)
  verlies,
  @HiveField(76)
  garten,
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
      case Cards.waldlaeuferNeu:
        return 'Waldläufer';
      case Cards.schildVonKeth:
        return 'Schild von Keth';
      case Cards.juwelDerOrdnung:
        return 'Juwel der Ordnung';
      case Cards.weltenbaumNeu:
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
      case Cards.quelleDesLebensNeu:
        return 'Quelle des Lebens';
      case Cards.sumpf:
        return 'Sumpf';
      case Cards.grosseFlut:
      case Cards.grosseFlutNeu:
        return 'Große Flut';
      case Cards.insel:
        return 'Insel';
      case Cards.wasserwesen:
        return 'Wasserwesen';
      case Cards.gestaltwandler:
      case Cards.gestaltwandlerNeu:
        return 'Gestaltwandler';
      case Cards.spiegelung:
      case Cards.spiegelungNeu:
        return 'Spiegelung';
      case Cards.doppelgaenger:
        return 'Doppelgänger';
      case Cards.gebirge:
        return 'Gebirge';
      case Cards.hoehle:
        return 'Höhle';
      case Cards.glockenturm:
      case Cards.glockenturmNeu:
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
      case Cards.totenbeschwoererNeu:
        return 'Totenbeschwörer';
      case Cards.hexenmeister:
        return 'Hexenmeister';
      case Cards.magierin:
        return 'Magierin';
      case Cards.hofnarr:
        return 'Hofnarr';
      case Cards.gruft:
        return 'Gruft';
      case Cards.ghul:
        return 'Ghul';
      case Cards.gespenst:
        return 'Gespenst';
      case Cards.dunkleKoenigin:
        return 'Dunkle Königin';
      case Cards.kapelle:
        return 'Kapelle';
      case Cards.dschinn:
        return 'Dschinn';
      case Cards.daemon:
        return 'Dämon';
      case Cards.burg:
        return 'Burg';
      case Cards.todesritter:
        return 'Todesritter';
      case Cards.kobold:
        return 'Kobold';
      case Cards.engel:
        return 'Engel';
      case Cards.lich:
        return 'Lich';
      case Cards.richter:
        return 'Richter';
      case Cards.verlies:
        return 'Verlies';
      case Cards.garten:
        return 'Garten';
    }
  }
}
