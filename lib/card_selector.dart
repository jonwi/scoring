import 'package:flutter/material.dart';

import 'card.dart' as game;
import 'deck.dart';

class CardSelector extends StatefulWidget {
  const CardSelector({Key? key, this.selector, this.multiselect = false, required this.isExpansion})
      : super(key: key);
  final bool Function(game.Card)? selector;
  final bool multiselect;
  final bool isExpansion;

  @override
  State<StatefulWidget> createState() {
    return CardSelectorState();
  }
}

class CardSelectorState extends State<CardSelector> {
  late List<game.Card> _filtered;
  late final Map<game.Card, bool> _expanded = {};
  late final Map<game.Card, bool> _selected = {};
  bool _isMultiSelectActive = false;

  @override
  void initState() {
    super.initState();
    _filtered = widget.selector != null
        ? Deck().cards(widget.isExpansion).where(widget.selector!).toList()
        : Deck().cards(widget.isExpansion).toList();
    for (var card in _filtered) {
      _expanded[card] = false;
      _selected[card] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: _filtered.map((card) {
          return ListTile(
            selected: _selected[card]!,
            selectedTileColor: Colors.grey,
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
                            color: card.cardType.textColor,
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
              if (widget.multiselect) {
                if (_isMultiSelectActive) {
                  setState(() {
                    _selected[card] = !_selected[card]!;
                  });
                } else {
                  Navigator.pop<List<game.Cards>>(context, [card.id]);
                }
              } else {
                Navigator.pop<game.Cards>(context, card.id);
              }
            },
            onLongPress: () {
              if (widget.multiselect) {
                setState(() {
                  _isMultiSelectActive = true;
                  _selected[card] = !_selected[card]!;
                });
              }
            },
          );
        }).toList(),
      ),
      floatingActionButton: widget.multiselect && _isMultiSelectActive
          ? FloatingActionButton(
              backgroundColor:
                  _selected.values.fold<bool>(false, (previousValue, element) => previousValue || element)
                      ? null
                      : Colors.grey,
              onPressed: () {
                List<game.Cards> result =
                    _selected.entries.where((element) => element.value).map((e) => e.key.id).toList();
                Navigator.pop<List<game.Cards>>(context, result);
              },
              child: const Icon(Icons.check),
            )
          : null,
    );
  }
}
