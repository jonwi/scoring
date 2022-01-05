import 'package:flutter/material.dart';

import 'card.dart' as game;

class CardSelector extends StatelessWidget {
  const CardSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: game.Deck().cards.length,
          itemBuilder: (context, i) {
            return ListTile(
              title: Row(
                children: [
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(right: 15),
                      decoration: BoxDecoration(
                        boxShadow: [BoxShadow(color: game.Deck().cards[i].cardType.color, spreadRadius: 10)],
                        borderRadius: BorderRadius.circular(16),
                        color: game.Deck().cards[i].cardType.color,
                      ),
                      child: Text('${game.Deck().cards[i].baseStrength}',
                          style: TextStyle(
                            color: game.Deck().cards[i].cardType == game.CardType.Army
                                ? Colors.white
                                : Colors.black,
                          )),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(game.Deck().cards[i].name),
                    ),
                  )
                ],
              ),
              onTap: () {
                Navigator.pop(context, game.Deck().cards[i].name);
              },
            );
          }),
    );
  }
}
