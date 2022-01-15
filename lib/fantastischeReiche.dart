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
  final Map<game.Card, CardState> _hand = {};
  int _sum = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: ExpansionPanelList(
            children: _hand.entries
                .map<ExpansionPanel>((entry) => ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return _buildStats(entry);
                      },
                      body: _buildDescription(entry),
                      isExpanded: entry.value.visibility,
                      canTapOnHeader: true,
                    ))
                .toList(),
            expansionCallback: (index, isActive) {
              setState(() {
                _hand.entries.elementAt(index).value.visibility = !isActive;
              });
            },
          ),
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
          var result = await Navigator.push<Set<game.Cards>>(context, MaterialPageRoute(builder: (context) {
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
          MaterialPageRoute<game.Cards>(builder: (context) {
            return CardSelector(
              selector: (card) => !_hand.keys.map((card) => card.id).contains(card.id),
            );
          }),
        );
        if (result != null && _hand.length <= 8) {
          _addCard(result);
        }
      },
    );
  }

  /// description of given card
  AnimatedOpacity _buildDescription(MapEntry<game.Card, CardState> entry) {
    return AnimatedOpacity(
        opacity: entry.value.visibility ? 1.0 : 0,
        duration: const Duration(milliseconds: 500),
        child: Visibility(
            visible: entry.value.visibility, child: Wrap(children: [Center(child: entry.key.description)])));
  }

  /// Stats containing base strength, name, actionButton, bonus and penalty, and overall total
  Row _buildStats(MapEntry<game.Card, CardState> entry) {
    final card = entry.key;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
            // baseStrength
            margin: const EdgeInsets.all(15),
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
                    color: card.bonus(_hand) - card.penalty(_hand) >= 0
                        ? card.bonus(_hand) - card.penalty(_hand) == 0
                            ? Colors.black
                            : Colors.green
                        : Colors.red)),
          ),
        ),
        Expanded(
          // total
          flex: 1,
          child: Center(
            child: Text('${entry.value.isActive() ? card.calculateStrength(_hand) : 0}',
                style: TextStyle(
                    color: card.calculateStrength(_hand) >= 0
                        ? card.calculateStrength(_hand) == 0
                            ? Colors.black
                            : Colors.green
                        : Colors.red)),
          ),
        ),
        FittedBox(
          child: IconButton(
            icon: const Icon(
              Icons.remove_circle_outline_sharp,
              color: Colors.red,
            ),
            onPressed: () => _removeCard(card),
          ),
        ),
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

  /// performs the action associated with the card if there is any
  Future<void> _performAction(game.Card card) async {
    switch (card.id) {
      case game.Cards.spiegelung:
        final cardID = await Navigator.push(context, MaterialPageRoute<game.Cards>(builder: (context) {
          return CardSelector(
              selector: (card) => {
                    game.CardType.army,
                    game.CardType.land,
                    game.CardType.weather,
                    game.CardType.flood,
                    game.CardType.flame
                  }.contains(card.cardType));
        }));
        if (cardID != null) {
          game.Card chosen = game.Deck().cards.firstWhere((element) => element.id == cardID);
          if ({
            game.CardType.army,
            game.CardType.land,
            game.CardType.weather,
            game.CardType.flood,
            game.CardType.flame
          }.contains(chosen.cardType)) {
            card.name = chosen.name;
            card.cardType = chosen.cardType;
            _hand[card] = _hand[card]!;
          }
        }
        break;
      case game.Cards.gestaltwandler:
        final cardId = await Navigator.push(context, MaterialPageRoute<game.Cards>(builder: (context) {
          return CardSelector(
              selector: (card) => {
                    game.CardType.artifact,
                    game.CardType.leader,
                    game.CardType.wizard,
                    game.CardType.weapon,
                    game.CardType.beast,
                  }.contains(card.cardType));
        }));
        if (cardId != null) {
          game.Card chosen = game.Deck().cards.firstWhere((element) => element.id == cardId);
          if ({
            game.CardType.artifact,
            game.CardType.leader,
            game.CardType.wizard,
            game.CardType.weapon,
            game.CardType.beast,
          }.contains(chosen.cardType)) {
            card.name = chosen.name;
            card.cardType = chosen.cardType;
            _hand[card] = _hand[card]!;
          }
        }
        break;
      case game.Cards.doppelgaenger:
        final cardID = await Navigator.push(context, MaterialPageRoute<game.Cards>(builder: (context) {
          return CardSelector(
            selector: (card) =>
                _hand.keys.map((e) => e.id).contains(card.id) && card.id != game.Cards.doppelgaenger,
          );
        }));
        if (cardID != null) {
          game.Card chosen = _hand.keys.where((element) => element.id == cardID).elementAt(0);
          card.name = chosen.name;
          card.penalty = chosen.penalty;
          card.cardType = chosen.cardType;
          card.baseStrength = chosen.baseStrength;
          _hand[card] = _hand[card]!;
        }
        break;
      case game.Cards.buchDerVeraenderung:
        final cardID = await Navigator.push(context, MaterialPageRoute<game.Cards>(builder: (context) {
          return CardSelector(
            selector: (c) => _hand.keys.map((e) => e.name).contains(c.name) && c.name != card.name,
          );
        }));
        if (cardID != null) {
          final cardType = await Navigator.push(context, MaterialPageRoute<game.CardType>(builder: (context) {
            return TypeSelector(selector: (type) => type != game.CardType.wild);
          }));
          if (cardType != null) {
            game.Card chosen = _hand.keys.where((element) => element.id == cardID).first;
            chosen.cardType = cardType;
            card.hasAction = false;
          }
        }
        break;
      case game.Cards.insel:
        final cardID = await Navigator.push(context, MaterialPageRoute<game.Cards>(builder: (context) {
          return CardSelector(
            selector: (card) =>
                _hand.keys.map((e) => e.name).contains(card.name) &&
                (card.cardType == game.CardType.flame || card.cardType == game.CardType.flood),
          );
        }));
        if (cardID != null) {
          game.Card chosen = _hand.keys.where((element) => element.id == cardID).first;
          _hand[chosen]?.activationState = true;
          chosen.penalty = (deck) => 0;
          chosen.block = (deck) {};
          card.hasAction = false;
        }
        break;
      default:
        return;
    }
    _calculateHand();
  }

  /// adds the card to the current hand if not yet in there
  void _addCard(game.Cards cardID) {
    game.Card card = game.Deck().cards.firstWhere((element) => element.id == cardID);
    if (!_hand.keys.map((card) => card.id).contains(card.id)) {
      _hand[card] = CardState();
      _calculateHand();
    }
  }

  /// removes card from the current hand deck will be calculated again, actions might be undone
  void _removeCard(game.Card card) {
    _hand.remove(card);
    if (card.id == game.Cards.insel || card.id == game.Cards.buchDerVeraenderung) {
      _resetActions();
    } else {
      _calculateHand();
    }
  }

  /// calculates the strength of _hand unblocks everything, blocks, and then sums every card
  void _calculateHand() {
    setState(() {
      for (MapEntry<game.Card, CardState> entry in _hand.entries) {
        entry.value.activationState = null;
      }
      for (var key in _hand.keys) {
        key.aufheben(_hand);
      }
      for (var key in _hand.keys) {
        key.block(_hand);
      }
      for (var key in _hand.keys) {
        key.block(_hand);
      }
      _sum = _hand.entries
          .where((e) => e.value.activationState == null || e.value.activationState == true)
          .fold(0, (previousValue, element) => previousValue + element.key.calculateStrength(_hand));
    });
  }

  /// returns the number of cards that are allowed in the current hand
  int maxCards() {
    if (_hand.keys.map((e) => e.name).contains('Totenbeschwörer')) return 8;
    return 7;
  }

  /// replaces every card in _hand with the original card to undo every change that might have occured.
  void _resetActions() {
    for (var entry in _hand.entries.toList()) {
      game.Card card = game.Deck().cards.firstWhere((element) => element.id == entry.key.id);
      _hand[card] = _hand.remove(entry.key)!;
    }
    _calculateHand();
  }
}

class CardState {
  bool? activationState;
  bool visibility;

  CardState({this.visibility = false, this.activationState});

  bool isActive() {
    if (activationState == null) return true;
    return activationState!;
  }
}
