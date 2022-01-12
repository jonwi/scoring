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
  final Map<game.Card, game.CardState> _hand = {};
  int _sum = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Center(
        child: ListView.builder(
          // Deck
          itemCount: _hand.length + 1,
          itemBuilder: (context, i) {
            if (i == _hand.length) {
              return const ListTile(
                title: SizedBox(
                  height: 100,
                ),
              );
            } else {
              var entry = _hand.entries.elementAt(i);
              var card = entry.key;
              return ListTile(
                onTap: () {
                  setState(() {
                    entry.value.visibility = !entry.value.visibility;
                  });
                },
                title: _buildStats(entry),
                subtitle: _buildDescription(entry),
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
        _buildScanButton(context),
        _buildAddButton(context),
      ]),
    );
  }

  /// floating button to go to scanner
  FloatingActionButton _buildScanButton(BuildContext context) {
    return FloatingActionButton(
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
        });
  }

  /// Floating add button to go to card selector
  FloatingActionButton _buildAddButton(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'btn2',
      child: const Icon(Icons.add),
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute<String>(builder: (context) {
            return const CardSelector(); // TODO: remove current hand from selection, this requires a id for every card since everything else can be changed with actions
          }),
        );
        if (result != null && _hand.length <= 8) {
          _addCard(result);
        }
      },
    );
  }

  /// description of given card
  AnimatedOpacity _buildDescription(MapEntry<game.Card, game.CardState> entry) {
    return AnimatedOpacity(
        opacity: entry.value.visibility ? 1.0 : 0,
        duration: const Duration(milliseconds: 500),
        child: Visibility(
            visible: entry.value.visibility, child: Wrap(children: [Center(child: entry.key.description)])));
  }

  /// Stats containing base strength, name, actionButton, bonus and penalty, and overall total
  Row _buildStats(MapEntry<game.Card, game.CardState> entry) {
    final card = entry.key;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
            // baseStrength
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
          // name
          flex: 5,
          child: Text(card.name,
              style: TextStyle(
                  decoration: entry.value.activationState ?? true
                      ? TextDecoration.none
                      : TextDecoration.lineThrough)),
        ),
        card.hasAction // actionButton
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
          // bonus - penalty
          flex: 1,
          child: Center(
            child: Text('${entry.value.isActive() ? card.bonus(_hand) - card.penalty(_hand) : 0}',
                style: TextStyle(
                    color: card.bonus(_hand) - card.penalty(_hand) > 0 ? Colors.green : Colors.red)),
          ),
        ),
        Expanded(
          // total
          flex: 1,
          child: Center(
            child: Text('${entry.value.isActive() ? card.calculateStrength(_hand) : 0}',
                style: TextStyle(color: card.bonus(_hand) > 0 ? Colors.green : Colors.red)),
          ),
        )
      ],
    );
  }

  /// AppBar containing score total and amount of cards in hand
  AppBar _buildAppBar() {
    return AppBar(
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
    );
  }

  Future<void> _performAction(card) async {
    switch (card.id) {
      case game.Cards.spiegelung:
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
            print('Spiegelung ausgewählt');
          }
        }
        break;
      case game.Cards.gestaltwandler:
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
            print('gestaltwandler ausgewahlt');
          }
        }
        break;
      case game.Cards.doppelgaenger:
        final cardName = await Navigator.push(context, MaterialPageRoute<String>(builder: (context) {
          return CardSelector(
            selector: (card) =>
                _hand.keys.map((e) => e.name).contains(card.name) && card.id != game.Cards.doppelgaenger,
          );
        }));
        if (cardName != null) {
          game.Card chosen = _hand.keys.where((element) => element.name == cardName).elementAt(0);
          card.name = chosen.name;
          // TODO hier muss noch eine penalty gemacht werden
          // card.penalty = chosen.penalty;
          card.cardType = chosen.cardType;
          card.baseStrength = chosen.baseStrength;
          print('doppelgänger ausgewählt');
        }
        break;
      case game.Cards.buchDerVeraenderung:
        final cardName = await Navigator.push(context, MaterialPageRoute<String>(builder: (context) {
          return CardSelector(
            selector: (c) => _hand.keys.map((e) => e.name).contains(c.name) && c.name != card.name,
          );
        }));
        if (cardName != null) {
          final cardType = await Navigator.push(context, MaterialPageRoute<game.CardType>(builder: (context) {
            return TypeSelector(selector: (type) => type != game.CardType.wild);
          }));
          if (cardType != null) {
            game.Card chosen = _hand.keys.where((element) => element.name == cardName).first;
            chosen.cardType = cardType;
          }
        }
        print('book of change ausgewahlt');
        break;
      case game.Cards.insel:
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
        print('insel ausgweal');
        break;
    }
    _calculateDeck();
  }

  void _addCard(String cardName) {
    game.Card card = game.Deck().cards.firstWhere((element) => element.name == cardName);
    //TODO: Better with ID
    if (!_hand.keys.map((card) => card.name).contains(card.name)) {
      _hand[card] = game.CardState();
      _calculateDeck();
    }
  }

  void _removeCard(game.Card card) {
    _hand.remove(card);
    _calculateDeck();
  }

  void _calculateDeck() {
    print('Start calculation');
    setState(() {
      for (var entry in _hand.entries) {
        print(entry.key.name);
        entry.value.activationState = null;
      }
      for (var key in _hand.keys) {
        key.block(_hand);
      }
      _sum = _hand.entries
          .where((e) => e.value.activationState == null || e.value.activationState == true)
          .fold(0, (previousValue, element) => previousValue + element.key.calculateStrength(_hand));
      print('finish state');
    });
    print('finish calc');
  }

  int maxCards() {
    if (_hand.keys.map((e) => e.name).contains('Totenbeschwörer')) return 8;
    return 7;
  }

  void _resetActions() {
    for (var entry in _hand.entries.toList()) {
      game.Card card = game.Deck().cards.firstWhere((element) => element.id == entry.key.id);
      _hand[card] = _hand.remove(entry.key)!;
    }
    _calculateDeck();
  }
}
