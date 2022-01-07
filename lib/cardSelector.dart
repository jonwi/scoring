import 'package:flutter/material.dart';

import 'card.dart' as game;

class CardSelector extends StatelessWidget {
  const CardSelector({Key? key, this.selector}) : super(key: key);
  final bool Function(game.Card)? selector;

  @override
  Widget build(BuildContext context) {
    final filtered = selector != null ? game.Deck().cards.where(selector!) : game.Deck().cards;

    return Scaffold(
      body: ListView.builder(
          itemCount: filtered.length,
          itemBuilder: (context, i) {
            var card = filtered.elementAt(i);
            return ListTile(
              subtitle: Wrap(children: [card.description]),
              title: Row(
                children: [
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(right: 15),
                      decoration: BoxDecoration(
                        boxShadow: [BoxShadow(color: card.cardType.color, spreadRadius: 10)],
                        borderRadius: BorderRadius.circular(16),
                        color: card.cardType.color,
                      ),
                      child: Text('${card.baseStrength}',
                          style: TextStyle(
                            color: card.cardType == game.CardType.army ? Colors.white : Colors.black,
                          )),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(card.name),
                    ),
                  )
                ],
              ),
              onTap: () {
                Navigator.pop(context, card.name);
              },
            );
          }),
    );
  }
}
