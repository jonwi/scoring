import 'dart:collection';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:scoring/cameraScan.dart';

import 'card.dart' as game;
import 'cardSelector.dart';

class FantastischeReiche extends StatefulWidget {
  const FantastischeReiche({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HandWidget();
  }
}

class HandWidget extends State<FantastischeReiche> {
  /// Card and Active State where true means the card counts towards total and false means its deactivated
  final Map<game.Card, bool?> _hand = HashMap<game.Card, bool?>(equals: (c1, c2) => c1.name == c2.name);
  int _sum = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Deck'),
            FittedBox(fit: BoxFit.fitWidth, child: Text('Punkte: $_sum')),
            Text('${_hand.length}/${maxCards()}')
          ],
        ),
      ),
      body: Center(
        child: ListView.builder(
          // Deck
          itemCount: _hand.length,
          itemBuilder: (context, i) {
            game.Card card = _hand.keys.elementAt(i);
            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      margin: const EdgeInsets.only(right: 15),
                      decoration: BoxDecoration(
                        boxShadow: [BoxShadow(color: card.cardType.color, spreadRadius: 10)],
                        borderRadius: BorderRadius.circular(16),
                        color: card.cardType.color,
                      ),
                      child: Text(
                        '${card.baseStrength}',
                        style: TextStyle(
                          color: card.cardType == game.CardType.Army ? Colors.white : Colors.black,
                        ),
                      )),
                  Center(
                    child: Text(card.name,
                        style: TextStyle(
                            decoration:
                                _hand[card] ?? true ? TextDecoration.none : TextDecoration.lineThrough)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.circle),
                    onPressed: card.hasAction
                        ? () {
                            _performAction(card);
                          }
                        : () {},
                    color: card.hasAction ? Colors.green : Colors.white,
                  ),
                  Text('${card.bonus(_hand)}')
                ],
              ),
              onLongPress: () => _removeCard(card),
              trailing: FittedBox(
                child: IconButton(
                  icon: const Icon(
                    Icons.remove_circle_outline_sharp,
                    color: Colors.red,
                  ),
                  onPressed: () => _removeCard(card),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton(
            heroTag: 'btn1',
            child: const Icon(Icons.camera_alt),
            onPressed: () async {
              // Ensure that plugin services are initialized so that `availableCameras()`
              // can be called before `runApp()`
              WidgetsFlutterBinding.ensureInitialized();

              // Obtain a list of the available cameras on the device.
              final cameras = await availableCameras();

              // Get a specific camera from the list of available cameras.
              final firstCamera = cameras.first;

              var result = await Navigator.push<Set<String>>(context, MaterialPageRoute(builder: (context) {
                return CameraScan(camera: firstCamera);
              }));
              result?.forEach((element) {
                _addCard(element);
              });
            }),
        FloatingActionButton(
          heroTag: 'btn2',
          child: const Icon(Icons.add),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute<String>(builder: (context) {
                return const CardSelector();
              }),
            );
            if (result != null && _hand.length <= 8) {
              _addCard(result);
            }
          },
        ),
      ]),
    );
  }

  void _performAction(card) {}

  void _addCard(String cardName) {
    setState(() {
      game.Card card = game.Deck().cards.firstWhere((element) => element.name == cardName);
      if (!_hand.containsKey(card)) {
        _hand[card] = null;
        _calculateDeck();
      }
    });
  }

  void _removeCard(game.Card card) {
    setState(() {
      _hand.remove(card);
      _calculateDeck();
    });
  }

  void _calculateDeck() {
    setState(() {
      for (var key in _hand.keys) {
        _hand[key] = null;
      }
      for (var key in _hand.keys) {
        key.block(_hand);
      }
      _sum = _hand.keys
          .where((e) => _hand[e] == null || _hand[e]!)
          .fold(0, (previousValue, element) => previousValue + element.calculateStrength(_hand));
    });
  }

  int maxCards() {
    if (_hand.keys.map((e) => e.name).contains('Totenbeschwörer')) return 8;
    return 7;
  }
}
