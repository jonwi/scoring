// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CardsAdapter extends TypeAdapter<Cards> {
  @override
  final int typeId = 1;

  @override
  Cards read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Cards.koenig;
      case 1:
        return Cards.koenigin;
      case 2:
        return Cards.prinzessin;
      case 3:
        return Cards.kriegsherr;
      case 4:
        return Cards.kaiserin;
      case 5:
        return Cards.ritter;
      case 6:
        return Cards.elbenschuetzen;
      case 7:
        return Cards.leichteKavallerie;
      case 8:
        return Cards.zwergeninfanterie;
      case 9:
        return Cards.waldlaeufer;
      case 10:
        return Cards.schildVonKeth;
      case 11:
        return Cards.juwelDerOrdnung;
      case 12:
        return Cards.weltenbaum;
      case 13:
        return Cards.buchDerVeraenderung;
      case 14:
        return Cards.runeDesSchutzes;
      case 15:
        return Cards.einhorn;
      case 16:
        return Cards.basilisk;
      case 17:
        return Cards.schlachtross;
      case 18:
        return Cards.drache;
      case 19:
        return Cards.hydra;
      case 20:
        return Cards.buschfeuer;
      case 21:
        return Cards.kerze;
      case 22:
        return Cards.schmiede;
      case 23:
        return Cards.blitz;
      case 24:
        return Cards.feuerwesen;
      case 25:
        return Cards.quelleDesLebens;
      case 26:
        return Cards.sumpf;
      case 27:
        return Cards.grosseFlut;
      case 28:
        return Cards.insel;
      case 29:
        return Cards.wasserwesen;
      case 30:
        return Cards.gestaltwandler;
      case 31:
        return Cards.spiegelung;
      case 32:
        return Cards.doppelgaenger;
      case 33:
        return Cards.gebirge;
      case 34:
        return Cards.hoehle;
      case 35:
        return Cards.glockenturm;
      case 36:
        return Cards.wald;
      case 37:
        return Cards.erdwesen;
      case 38:
        return Cards.kriegsschiff;
      case 39:
        return Cards.zauberstab;
      case 40:
        return Cards.schwertVonKeth;
      case 41:
        return Cards.elbischerBogen;
      case 42:
        return Cards.kampfzeppelin;
      case 43:
        return Cards.regensturm;
      case 44:
        return Cards.blizzard;
      case 45:
        return Cards.rauch;
      case 46:
        return Cards.wirbelsturm;
      case 47:
        return Cards.luftwesen;
      case 48:
        return Cards.sammler;
      case 49:
        return Cards.herrDerBestien;
      case 50:
        return Cards.totenbeschwoerer;
      case 51:
        return Cards.hexenmeister;
      case 52:
        return Cards.magierin;
      case 53:
        return Cards.hofnarr;
      default:
        return Cards.koenig;
    }
  }

  @override
  void write(BinaryWriter writer, Cards obj) {
    switch (obj) {
      case Cards.koenig:
        writer.writeByte(0);
        break;
      case Cards.koenigin:
        writer.writeByte(1);
        break;
      case Cards.prinzessin:
        writer.writeByte(2);
        break;
      case Cards.kriegsherr:
        writer.writeByte(3);
        break;
      case Cards.kaiserin:
        writer.writeByte(4);
        break;
      case Cards.ritter:
        writer.writeByte(5);
        break;
      case Cards.elbenschuetzen:
        writer.writeByte(6);
        break;
      case Cards.leichteKavallerie:
        writer.writeByte(7);
        break;
      case Cards.zwergeninfanterie:
        writer.writeByte(8);
        break;
      case Cards.waldlaeufer:
        writer.writeByte(9);
        break;
      case Cards.schildVonKeth:
        writer.writeByte(10);
        break;
      case Cards.juwelDerOrdnung:
        writer.writeByte(11);
        break;
      case Cards.weltenbaum:
        writer.writeByte(12);
        break;
      case Cards.buchDerVeraenderung:
        writer.writeByte(13);
        break;
      case Cards.runeDesSchutzes:
        writer.writeByte(14);
        break;
      case Cards.einhorn:
        writer.writeByte(15);
        break;
      case Cards.basilisk:
        writer.writeByte(16);
        break;
      case Cards.schlachtross:
        writer.writeByte(17);
        break;
      case Cards.drache:
        writer.writeByte(18);
        break;
      case Cards.hydra:
        writer.writeByte(19);
        break;
      case Cards.buschfeuer:
        writer.writeByte(20);
        break;
      case Cards.kerze:
        writer.writeByte(21);
        break;
      case Cards.schmiede:
        writer.writeByte(22);
        break;
      case Cards.blitz:
        writer.writeByte(23);
        break;
      case Cards.feuerwesen:
        writer.writeByte(24);
        break;
      case Cards.quelleDesLebens:
        writer.writeByte(25);
        break;
      case Cards.sumpf:
        writer.writeByte(26);
        break;
      case Cards.grosseFlut:
        writer.writeByte(27);
        break;
      case Cards.insel:
        writer.writeByte(28);
        break;
      case Cards.wasserwesen:
        writer.writeByte(29);
        break;
      case Cards.gestaltwandler:
        writer.writeByte(30);
        break;
      case Cards.spiegelung:
        writer.writeByte(31);
        break;
      case Cards.doppelgaenger:
        writer.writeByte(32);
        break;
      case Cards.gebirge:
        writer.writeByte(33);
        break;
      case Cards.hoehle:
        writer.writeByte(34);
        break;
      case Cards.glockenturm:
        writer.writeByte(35);
        break;
      case Cards.wald:
        writer.writeByte(36);
        break;
      case Cards.erdwesen:
        writer.writeByte(37);
        break;
      case Cards.kriegsschiff:
        writer.writeByte(38);
        break;
      case Cards.zauberstab:
        writer.writeByte(39);
        break;
      case Cards.schwertVonKeth:
        writer.writeByte(40);
        break;
      case Cards.elbischerBogen:
        writer.writeByte(41);
        break;
      case Cards.kampfzeppelin:
        writer.writeByte(42);
        break;
      case Cards.regensturm:
        writer.writeByte(43);
        break;
      case Cards.blizzard:
        writer.writeByte(44);
        break;
      case Cards.rauch:
        writer.writeByte(45);
        break;
      case Cards.wirbelsturm:
        writer.writeByte(46);
        break;
      case Cards.luftwesen:
        writer.writeByte(47);
        break;
      case Cards.sammler:
        writer.writeByte(48);
        break;
      case Cards.herrDerBestien:
        writer.writeByte(49);
        break;
      case Cards.totenbeschwoerer:
        writer.writeByte(50);
        break;
      case Cards.hexenmeister:
        writer.writeByte(51);
        break;
      case Cards.magierin:
        writer.writeByte(52);
        break;
      case Cards.hofnarr:
        writer.writeByte(53);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
