import 'package:flutter/material.dart';

import 'card.dart' as game;

class CardSelector extends StatefulWidget {
  const CardSelector({Key? key, this.selector}) : super(key: key);
  final bool Function(game.Card)? selector;

  @override
  State<StatefulWidget> createState() {
    return CardSelectorState();
  }
}

class CardSelectorState extends State<CardSelector> {
  late List<game.Card> _filtered;
  late final Map<game.Card, bool> _expanded = {};

  @override
  void initState() {
    _filtered =
        widget.selector != null ? game.Deck().cards.where(widget.selector!).toList() : game.Deck().cards;
    for (var card in _filtered) {
      _expanded[card] = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: _filtered.map((card) {
        return ListTile(
          subtitle: AnimatedOpacity(
              opacity: _expanded[card]! ? 1 : 0,
              duration: const Duration(milliseconds: 700),
              child: Visibility(
                  visible: _expanded[card]!,
                  child: Row(children: [
                    const Spacer(),
                    Expanded(flex: 5, child: Wrap(children: [Center(child: card.description)])),
                    const Spacer(),
                  ]))),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(color: card.cardType.color, spreadRadius: 10)],
                    borderRadius: BorderRadius.circular(16),
                    color: card.cardType.color,
                  ),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        '${card.baseStrength}',
                        style: TextStyle(
                          color: card.cardType == game.CardType.army ? Colors.white : Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 5,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(card.name),
                ),
              ),
              Flexible(
                child: IconButton(
                  icon: _expanded[card]! ? const Icon(Icons.expand_less) : const Icon(Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      _expanded[card] = !_expanded[card]!;
                    });
                  },
                ),
              )
            ],
          ),
          onTap: () {
            Navigator.pop(context, card.id);
          },
        );
      }).toList(),
    ));
  }
}
