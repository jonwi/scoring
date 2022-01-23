import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:scoring/fantastischeReiche.dart';
import 'package:uuid/uuid.dart';

import 'card.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(CardsAdapter());
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
      home: FantastischeReiche(
        handID: const Uuid().v1(),
        hand: {},
      ),
    );
  }
}
