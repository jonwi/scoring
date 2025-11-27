import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scoring/camera_scan.dart';
import 'package:scoring/settings.dart';

import 'ablage.dart';
import 'card.dart' as game;
import 'card.dart';
import 'card_selector.dart';
import 'game.dart';
import 'hand.dart';

class FantastischeReiche extends StatefulWidget {
  const FantastischeReiche({Key? key, this.handID, required this.game}) : super(key: key);
  final int? handID;
  final Game game;

  @override
  State<StatefulWidget> createState() {
    return HandWidget();
  }
}

class HandWidget extends State<FantastischeReiche> {
  late Game _game;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _game = widget.game;
    _pageController = PageController(initialPage: 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        final int page = _pageController.hasClients && _pageController.page != null
            ? _pageController.page!.round()
            : _pageController.initialPage;

        final bool isHand = page == 1;

        return Scaffold(
          appBar: AppBar(
            title: page == 0
                ? const Text('Historie')
                : isHand
                    ? const Text('Hand')
                    : const Text('Ablage'),
            actions: [
              IconButton(
                  onPressed: () async {
                    bool? result = await Navigator.push<bool>(context, MaterialPageRoute(builder: (context) {
                      return const SettingsWidget();
                    }));
                    if (result != null && Settings.getInstance().isExpansion != result) {
                      setState(() {
                        _pageController.jumpToPage(1);
                        Settings.getInstance().isExpansion = result;
                        _game = Game(Hand(), Ablage(), Settings.getInstance().isExpansion);
                      });
                    }
                  },
                  icon: const Icon(Icons.settings))
            ],
          ),
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: page,
            items: [
              const BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Historie'),
              BottomNavigationBarItem(
                label: 'Hand',
                icon: SvgPicture.asset(
                  'assets/handBorderless.svg',
                  semanticsLabel: 'Hand',
                  height: 25,
                  colorFilter: ColorFilter.mode(
                      isHand ? Theme.of(context).primaryColor : Theme.of(context).bottomAppBarTheme.color ?? Colors.grey,
                      BlendMode.srcIn),
                ),
              ),
              if (_game.isExpansion)
                BottomNavigationBarItem(
                  label: 'Ablage',
                  icon: SvgPicture.asset(
                    'assets/ablagenorm.svg',
                    semanticsLabel: 'Ablage',
                    height: 25,
                    colorFilter: ColorFilter.mode(
                        page == 2
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).bottomAppBarTheme.color ?? Colors.grey,
                        BlendMode.srcIn),
                  ),
                )
            ],
            onTap: (index) => _pageController.animateToPage(index,
                duration: const Duration(milliseconds: 500), curve: Curves.easeOut),
          ),
          floatingActionButton: page == 2 || isHand
              ? Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  _buildScanButton(context),
                  const SizedBox(height: 16),
                  _buildAddButton(context),
                  const SizedBox(height: 25 + 16),
                ])
              : null,
        );
      },
      child: PageView(
        controller: _pageController,
        children: [
          _buildHistory(context),
          _buildHand(),
          if (_game.isExpansion) _buildAblage(),
        ],
      ),
    );
  }

  Widget _buildHand() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          color: Theme.of(context).secondaryHeaderColor,
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Punkte: ${_game.sum}',
                  style: TextStyle(fontSize: 22, color: Theme.of(context).primaryColor),
                ),
                Row(children: [
                  Text(
                    '${_game.lengthHand}',
                    style: TextStyle(
                        color: _game.lengthHand > _game.maxCardsHand()
                            ? Colors.red
                            : Theme.of(context).primaryColor,
                        fontSize: 22),
                  ),
                  Text('/${_game.maxCardsHand()}',
                      style: TextStyle(fontSize: 22, color: Theme.of(context).primaryColor)),
                ])
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _game.cardsHand.length,
            itemBuilder: (context, index) {
              final card = _game.cardsHand.elementAt(index);
              return Dismissible(
                key: Key(card.id.name),
                onDismissed: (direction) {
                  setState(() {
                    _game.removeCardHand(card);
                  });
                },
                background: Container(
                    alignment: AlignmentDirectional.centerEnd,
                    color: Colors.red,
                    child: const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Padding(
                          padding: EdgeInsets.only(left: 10), child: Icon(Icons.delete, color: Colors.white)),
                      Padding(
                          padding: EdgeInsets.only(right: 10), child: Icon(Icons.delete, color: Colors.white))
                    ])),
                child: ExpansionTile(
                  key: PageStorageKey(card.id.name),
                  title: _buildStats(card),
                  initiallyExpanded: _game.isVisibleHand(card),
                  onExpansionChanged: (isExpanded) {
                    setState(() {
                      _game.setVisibleHand(card, isExpanded);
                    });
                  },
                  children: <Widget>[_buildDescription(card)],
                ),
              );
            },
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          const Spacer(),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  _game.resetHand();
                });
              },
              child: const Text('Aktionen rückgängig')),
          const Spacer(),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  _game = Game(Hand(), Ablage(), Settings.getInstance().isExpansion);
                });
              },
              child: const Text('Neue Hand')),
          const Spacer(
            flex: 3,
          ),
        ])
      ],
    );
  }

  ListView _buildHistory(BuildContext context) {
    return ListView(
        children: Game.games()
            .map((game) => ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: Row(children: [
                    Expanded(flex: 5, child: _getName(game)),
                    Expanded(
                      child: IconButton(
                        iconSize: 30,
                        onPressed: () {
                          setState(() {
                            game.delete();
                          });
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ]),
                  onTap: () {
                    setState(() {
                      _game = Game.load(game.id!);
                    });
                    _pageController.animateToPage(1,
                        duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
                  },
                ))
            .toList()
            .reversed
            .toList());
  }

  /// floating button to go to scanner
  FloatingActionButton _buildScanButton(BuildContext context) {
    return FloatingActionButton(
        heroTag: 'btn1',
        child: const Icon(Icons.camera_alt),
        onPressed: () async {
          WidgetsFlutterBinding.ensureInitialized();
          final cameras = await availableCameras();
          log('length ${cameras.length}');
          log(cameras[0].toString());
          final firstCamera = cameras[0];
          var result = await Navigator.push<Set<game.Cards>>(context, MaterialPageRoute(builder: (context) {
            return CameraScan(
              camera: firstCamera,
              isExpansion: _game.isExpansion,
            );
          }));
          if (result != null) {
            setState(() {
              if (_pageController.page!.round() == 1) {
                _game.addCardsHandByID(result.toList());
              } else {
                _game.addCardsAblageByID(result.toList());
              }
            });
          }
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
          MaterialPageRoute<List<game.Cards>>(builder: (context) {
            return CardSelector(
              selector: _pageController.page!.round() == 1
                  ? (card) => !_game.cardsHand.map((card) => card.id).contains(card.id)
                  : (card) => !_game.cardsAblage.map((e) => e.id).contains(card.id),
              multiselect: true,
              isExpansion: _game.isExpansion,
            );
          }),
        );
        if (result != null && _game.lengthHand <= 8) {
          setState(() {
            if (_pageController.page!.round() == 1) {
              _game.addCardsHandByID(result);
            } else {
              _game.addCardsAblageByID(result);
            }
          });
        }
      },
    );
  }

  /// description of given card
  Widget _buildDescription(game.Card card) {
    return Row(children: [
      const Spacer(),
      Expanded(flex: 5, child: Wrap(children: [Center(child: card.description)])),
      const Spacer(),
    ]);
  }

  /// Stats containing base strength, name, actionButton, bonus and penalty, and overall total
  Row _buildStats(game.Card card) {
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
              width: 35,
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
                  decoration: _game.isActiveHand(card) ? TextDecoration.none : TextDecoration.lineThrough)),
        ),
        card.hasAction // actionButton
            ? Expanded(
                flex: 1,
                child: IconButton(
                  padding: const EdgeInsets.all(0),
                  iconSize: 20,
                  onPressed: card.hasAction
                      ? () async {
                          await _game.executeAction(context, card);
                          setState(() {
                            // _game changed possibly
                          });
                        }
                      : () {},
                  color: Colors.white,
                  icon: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: const [BoxShadow(color: Colors.green, spreadRadius: 10)],
                        borderRadius: BorderRadius.circular(300),
                      ),
                      child: const Icon(
                        Icons.edit,
                      ),
                    ),
                  ),
                ),
              )
            : const Spacer(
                flex: 1,
              ),
        Expanded(
          // bonus - penalty
          flex: 1,
          child: Center(
            child: Text('${_game.isActiveHand(card) ? _game.bonus(card) - _game.penalty(card) : 0}',
                style: TextStyle(
                    color: _game.bonus(card) - _game.penalty(card) >= 0
                        ? _game.bonus(card) - _game.penalty(card) == 0
                            ? Colors.black
                            : Colors.green
                        : Colors.red)),
          ),
        ),
        Expanded(
          // total
          flex: 1,
          child: Center(
            child: Text('${_game.isActiveHand(card) ? _game.strength(card) : 0}',
                style: TextStyle(
                    color: _game.strength(card) >= 0
                        ? _game.strength(card) == 0
                            ? Colors.black
                            : Colors.green
                        : Colors.red)),
          ),
        ),
        FittedBox(
          child: IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              setState(() {
                _game.removeCardHand(card);
              });
            },
          ),
        ),
      ],
    );
  }

  /// gets the name of a saved Hand
  Widget _getName(Game game) {
    Map<CardType, int> map =
        game.cardsHand.map((card) => card.cardType).fold<Map<CardType, int>>({}, (map, type) {
      if (map[type] != null) {
        map[type] = map[type]! + 1;
      } else {
        map[type] = 1;
      }
      return map;
    });
    List<Widget> typeWidgets = map.entries
        .map((entry) => Expanded(
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: entry.key.color, spreadRadius: 10)],
                  borderRadius: BorderRadius.circular(16),
                  color: entry.key.color,
                ),
                child: Center(
                  child: Text(
                    '${entry.value}',
                    style: TextStyle(color: entry.key.textColor),
                  ),
                ),
              ),
            ))
        .toList();
    return Container(
        padding: const EdgeInsets.only(left: 5, right: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.brown,
        ),
        child: Row(children: [
          Expanded(
            flex: 5,
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Center(
                child: Text(
                  '${game.maxSum}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 13,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: typeWidgets,
            ),
          ),
        ]));
  }

  Widget _buildAblage() {
    return ListView.builder(
      itemCount: _game.cardsAblage.length,
      itemBuilder: (context, index) {
        final card = _game.cardsAblage.elementAt(index);
        return Dismissible(
          key: Key(card.id.name),
          onDismissed: (direction) {
            setState(() {
              _game.removeCardAblage(card);
            });
          },
          background: Container(
              alignment: AlignmentDirectional.centerEnd,
              color: Colors.red,
              child: const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Padding(padding: EdgeInsets.only(left: 10), child: Icon(Icons.delete, color: Colors.white)),
                Padding(padding: EdgeInsets.only(right: 10), child: Icon(Icons.delete, color: Colors.white))
              ])),
          child: ExpansionTile(
            key: PageStorageKey(card.id.name),
            title: Row(
              children: [
                Container(
                    margin: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      boxShadow: [BoxShadow(color: card.cardType.color, spreadRadius: 10)],
                      borderRadius: BorderRadius.circular(16),
                      color: card.cardType.color,
                    ),
                    child: SizedBox(
                      width: 35,
                      child: Center(
                        child: Text(
                          '${card.baseStrength}',
                          style: TextStyle(
                            color: card.cardType.textColor,
                          ),
                        ),
                      ),
                    )),
                Expanded(flex: 5, child: Text(card.name)),
                FittedBox(
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _game.removeCardAblage(card);
                      });
                    },
                  ),
                ),
              ],
            ),
            initiallyExpanded: _game.isVisibleAblage(card),
            onExpansionChanged: (isExpanded) {
              setState(() {
                _game.setVisibleAblage(card, isExpanded);
              });
            },
            children: <Widget>[_buildDescription(card)],
          ),
        );
      },
    );
  }
}
