import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:scoring/fantastische_reiche.dart';
import 'package:scoring/settings.dart';

import 'ablage.dart';
import 'card.dart';
import 'game.dart';
import 'hand.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(CardsAdapter());

  await Hive.deleteBoxFromDisk('games');

  // await Hive.deleteBoxFromDisk('settings');
  await Hive.openBox<Map<int, List<Cards>>>('games');
  await Hive.openBox<Map<dynamic, dynamic>>('settings');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scoring',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: FantastischeReiche(game: Game(Hand(), Ablage(), Settings.getInstance().isExpansion)),
    );
  }
}
