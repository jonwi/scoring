import 'package:flutter/material.dart';
import 'package:scoring/fantastischeReiche.dart';

Future<void> main() async {
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
      home: const FantastischeReiche(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        ListTile(
          title: const Text('Fantastische Reiche'),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (BuildContext) {
                return FantastischeReiche();
              }),
            );
          },
        )
      ],
    ));
  }
}
