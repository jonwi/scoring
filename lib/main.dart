import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:scoring/fantastische_reiche.dart';

import 'card.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(CardsAdapter());
  if (kDebugMode) {
    await Hive.deleteBoxFromDisk('hands');
  }
  await Hive.openBox<Map<int, List<Cards>>>('hands');
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
      home: const FantastischeReiche(
        hand: {},
      ),
    );
  }
}
