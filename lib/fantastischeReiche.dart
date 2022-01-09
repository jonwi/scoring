import 'dart:collection';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:scoring/cameraScan.dart';
import 'package:scoring/typeSelector.dart';

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
  /// Card and Active State where true means the card counts towards total and false means its deactivated and visibility
  final Map<game.Card, game.CardState> _hand =
      SplayTreeMap<game.Card, game.CardState>((c1, c2) => c1.name.compareTo(c2.name));
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
            Row(children: [
              Text(
                '${_hand.length}',
                style: TextStyle(color: _hand.length > maxCards() ? Colors.red : null),
              ),
              Text('/${maxCards()}'),
            ])
          ],
        ),
      ),
      body: Center(
        child: ListView.builder(
          // Deck
          itemCount: _hand.length + 1,
          itemBuilder: (context, i) {
            if (i == _hand.length) {
              return ListTile(
                title: SizedBox(
                  height: 100,
                ),
              );
            } else {
              game.Card card = _hand.keys.elementAt(i);
              return ListTile(
                onTap: () {
                  setState(() {
                    _hand[card]!.visibility = !_hand[card]!.visibility;
                  });
                },
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                        margin: const EdgeInsets.only(right: 15),
                        decoration: BoxDecoration(
                          boxShadow: [BoxShadow(color: card.cardType.color, spreadRadius: 10)],
                          borderRadius: BorderRadius.circular(16),
                          color: card.cardType.color,
                        ),
                        child: SizedBox(
                          width: 20,
                          child: Center(
                            child: Text(
                              '${card.baseStrength}',
                              style: TextStyle(
                                color: card.cardType.textColor,
                              ),
                            ),
                          ),
                        )),
                    Expanded(
                      flex: 5,
                      child: Text(card.name,
                          style: TextStyle(
                              decoration: _hand[card]?.activationState ?? true
                                  ? TextDecoration.none
                                  : TextDecoration.lineThrough)),
                    ),
                    card.hasAction
                        ? Expanded(
                            flex: 1,
                            child: IconButton(
                              icon: const Icon(
                                Icons.circle,
                                size: 35,
                              ),
                              onPressed: card.hasAction
                                  ? () {
                                      _performAction(card);
                                    }
                                  : () {},
                              color: card.hasAction ? Colors.green : Colors.white,
                            ),
                          )
                        : const Spacer(
                            flex: 1,
                          ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text('${card.bonus(_hand) - card.penalty(_hand)}',
                            style: TextStyle(
                                color:
                                    card.bonus(_hand) - card.penalty(_hand) > 0 ? Colors.green : Colors.red)),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text('${card.calculateStrength(_hand)}',
                            style: TextStyle(color: card.bonus(_hand) > 0 ? Colors.green : Colors.red)),
                      ),
                    )
                  ],
                ),
                subtitle: AnimatedOpacity(
                    opacity: _hand[card]!.visibility ? 1.0 : 0,
                    duration: const Duration(milliseconds: 500),
                    child: Visibility(
                        visible: _hand[card]!.visibility,
                        child: Wrap(children: [Center(child: card.description)]))),
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
            }
          },
        ),
      ),
      bottomNavigationBar: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        ElevatedButton(onPressed: () => _resetActions(), child: const Text('Aktionen rückgängig')),
        ElevatedButton(
            onPressed: () {
              while (_hand.isNotEmpty) {
                _removeCard(_hand.keys.first);
              }
            },
            child: const Text('Alle entfernen')),
      ]),
      floatingActionButton: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton(
            heroTag: 'btn1',
            child: const Icon(Icons.camera_alt),
            onPressed: () async {
              WidgetsFlutterBinding.ensureInitialized();
              final cameras = await availableCameras();
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

  Future<void> _performAction(card) async {
    switch (card.actionCards) {
      case game.ActionCards.spiegelung:
        final cardName = await Navigator.push(context, MaterialPageRoute<String>(builder: (context) {
          return CardSelector(
              selector: (card) => {
                    game.CardType.army,
                    game.CardType.land,
                    game.CardType.weather,
                    game.CardType.flood,
                    game.CardType.flame
                  }.contains(card.cardType));
        }));
        if (cardName != null) {
          game.Card chosen = game.Deck().cards.firstWhere((element) => element.name == cardName);
          if ({
            game.CardType.army,
            game.CardType.land,
            game.CardType.weather,
            game.CardType.flood,
            game.CardType.flame
          }.contains(chosen.cardType)) {
            card.name = chosen.name;
            card.cardType = chosen.cardType;
            setState(() {});
          }
        }

        break;
      case game.ActionCards.gestaltwandler:
        final cardName = await Navigator.push(context, MaterialPageRoute<String>(builder: (context) {
          return CardSelector(
              selector: (card) => {
                    game.CardType.artifact,
                    game.CardType.leader,
                    game.CardType.wizard,
                    game.CardType.weapon,
                    game.CardType.beast,
                  }.contains(card.cardType));
        }));
        if (cardName != null) {
          game.Card chosen = game.Deck().cards.firstWhere((element) => element.name == cardName);
          if ({
            game.CardType.artifact,
            game.CardType.leader,
            game.CardType.wizard,
            game.CardType.weapon,
            game.CardType.beast,
          }.contains(chosen.cardType)) {
            card.name = chosen.name;
            card.cardType = chosen.cardType;
            setState(() {});
          }
        }
        break;
      case game.ActionCards.doppelganger:
        final cardName = await Navigator.push(context, MaterialPageRoute<String>(builder: (context) {
          return CardSelector(
            selector: (card) =>
                _hand.keys.map((e) => e.name).contains(card.name) &&
                card.actionCards != game.ActionCards.doppelganger,
          );
        }));
        if (cardName != null) {
          game.Card chosen = _hand.keys.where((element) => element.name == cardName).elementAt(0);
          card.name = chosen.name;
          // card.penalty = chosen.penalty;
          card.cardType = chosen.cardType;
          card.baseStrength = chosen.baseStrength;
        }
        break;
      case game.ActionCards.bookOfChange:
        final cardName = await Navigator.push(context, MaterialPageRoute<String>(builder: (context) {
          return CardSelector(
            selector: (card) => _hand.keys.map((e) => e.name).contains(card.name),
          );
        }));
        final cardType = await Navigator.push(context, MaterialPageRoute<game.CardType>(builder: (context) {
          return TypeSelector(selector: (type) => type != game.CardType.wild);
        }));
        if (cardName != null && cardType != null) {
          game.Card chosen = _hand.keys.where((element) => element.name == cardName).first;
          chosen.cardType = cardType;
        }
        break;
      case game.ActionCards.island:
        final cardName = await Navigator.push(context, MaterialPageRoute<String>(builder: (context) {
          return CardSelector(
            selector: (card) =>
                _hand.keys.map((e) => e.name).contains(card.name) &&
                (card.cardType == game.CardType.flame || card.cardType == game.CardType.flood),
          );
        }));
        if (cardName != null) {
          game.Card chosen = _hand.keys.where((element) => element.name == cardName).first;
          _hand[chosen]?.activationState = true;
          chosen.penalty = (deck) => 0;
        }
        break;
    }
    setState(() {
      _calculateDeck();
    });
  }

  void _addCard(String cardName) {
    setState(() {
      game.Card card = game.Deck().cards.firstWhere((element) => element.name == cardName);
      if (!_hand.keys.map((card) => card.name).contains(card.name)) {
        _hand[card] = game.CardState();
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
        _hand[key]?.activationState = null;
      }
      for (var key in _hand.keys) {
        key.block(_hand);
      }
      _sum = _hand.keys
          .where((e) => _hand[e]?.activationState == null || _hand[e]?.activationState == true)
          .fold(0, (previousValue, element) => previousValue + element.calculateStrength(_hand));
    });
  }

  int maxCards() {
    if (_hand.keys.map((e) => e.name).contains('Totenbeschwörer')) return 8;
    return 7;
  }

  void _resetActions() {
    for (var key in _hand.keys.toList()) {
      if (key.actionCards != game.ActionCards.none) {
        game.Card card = game.Deck().cards.where((element) => element.actionCards == key.actionCards).first;
        _hand[card] = _hand.remove(key)!;
      } else {
        game.Card card = game.Deck().cards.where((element) => element.name == key.name).first;
        _hand[card] = _hand.remove(key)!;
      }
    }
    setState(() {
      _calculateDeck();
    });
  }
}
