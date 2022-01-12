import 'package:flutter/material.dart';

import 'card.dart';

class TypeSelector extends StatelessWidget {
  const TypeSelector({Key? key, this.selector}) : super(key: key);
  final bool Function(CardType)? selector;
  @override
  Widget build(BuildContext context) {
    var list = CardType.values;
    if (selector != null) {
      list = list.where(selector!).toList();
    }
    return Scaffold(
      body: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            var elementAt = list.elementAt(index);
            return ListTile(
              title: Row(children: [
                const Spacer(),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [BoxShadow(color: elementAt.color, spreadRadius: 10)],
                      borderRadius: BorderRadius.circular(16),
                      color: elementAt.color,
                    ),
                    child: Center(
                      child: Text(
                        elementAt.name,
                        style: TextStyle(color: elementAt.textColor),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
              ]),
              onTap: () {
                Navigator.pop(context, elementAt);
              },
            );
          }),
    );
  }
}
