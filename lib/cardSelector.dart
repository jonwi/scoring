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
  late List<bool> _expanded;

  @override
  void initState() {
    _filtered =
        widget.selector != null ? game.Deck().cards.where(widget.selector!).toList() : game.Deck().cards;
    _expanded = _filtered.map((e) => false).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: _filtered.length,
          itemBuilder: (context, i) {
            var card = _filtered.elementAt(i);
            return ListTile(
              subtitle: AnimatedOpacity(
                  opacity: _expanded[i] ? 1 : 0,
                  duration: const Duration(milliseconds: 700),
                  child: Visibility(
                      visible: _expanded[i], child: Wrap(children: [Center(child: card.description)]))),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        boxShadow: [BoxShadow(color: card.cardType.color, spreadRadius: 10)],
                        borderRadius: BorderRadius.circular(16),
                        color: card.cardType.color,
                      ),
                      child: SizedBox(
                        width: 20,
                        child: Center(
                          child: Text('${card.baseStrength}',
                              style: TextStyle(
                                color: card.cardType == game.CardType.army ? Colors.white : Colors.black,
                              )),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(card.name),
                    ),
                  ),
                  Flexible(
                    child: IconButton(
                      icon: _expanded[i] ? const Icon(Icons.expand_less) : const Icon(Icons.expand_more),
                      onPressed: () {
                        setState(() {
                          _expanded[i] = !_expanded[i];
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
          }),
    );
  }
}
