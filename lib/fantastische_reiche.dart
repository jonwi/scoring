import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
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
  @override
  void initState() {
    _game = widget.game;
    _pageController = PageController(initialPage: _page);
    super.initState();
  }

  /// Card and Active State where true means the card counts towards total and false means its deactivated and visibility
  late Game _game;

  late PageController _pageController;

  int _page = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _page == 0
            ? const Text('Historie')
            : _page == 1
                ? const Text('Hand')
                : const Text('Ablage'),
        actions: [
          IconButton(
              onPressed: () async {
                var result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const SettingsWidget();
                }));
                setState(() {
                  // Global Settings have to be applied
                });
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: PageView(
        clipBehavior: Clip.none,
        controller: _pageController,
        onPageChanged: (newPage) {
          setState(() {
            _page = newPage;
          });
        },
        children: [
          _buildHistory(context),
          _buildHand(),
          if (Settings.getInstance().isExpansion) _buildAblage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Historie'),
          BottomNavigationBarItem(
            label: 'Hand',
            icon: SvgPicture.asset(
              'assets/handBorderless.svg',
              semanticsLabel: 'Hand',
              height: 25,
              color: _page == 1 ? Theme.of(context).primaryColor : Theme.of(context).bottomAppBarTheme.color,
            ),
          ),
          if (Settings.getInstance().isExpansion)
            BottomNavigationBarItem(
              label: 'Ablage',
              icon: SvgPicture.asset(
                'assets/ablagenorm.svg',
                semanticsLabel: 'Ablage',
                height: 25,
                color:
                    _page == 2 ? Theme.of(context).primaryColor : Theme.of(context).bottomAppBarTheme.color,
              ),
            )
        ],
        onTap: (index) => {
          _pageController.animateToPage(index,
              duration: const Duration(milliseconds: 500), curve: Curves.easeOut)
        },
      ),
      floatingActionButton: _page == 2 || _page == 1
          ? Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              _buildScanButton(context),
              _buildAddButton(context),
            ])
          : null,
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
          child: SingleChildScrollView(
            child: ExpansionPanelList(
              key: Key('${_game.lengthHand}'),
              children: _game.cardsHand.map<ExpansionPanel>((card) => cardHandPanel(card)).toList(),
              expansionCallback: (index, isActive) {
                setState(() {
                  _game.setVisibleHand(_game.cardsHand.elementAt(index), !isActive);
                });
              },
            ),
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          const Spacer(),
          ElevatedButton(onPressed: () => _game.resetHand(), child: const Text('Aktionen rückgängig')),
          const Spacer(),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  _game = Game(Hand(), Ablage());
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

  ExpansionPanel cardHandPanel(game.Card card) {
    return ExpansionPanel(
        headerBuilder: (BuildContext context, bool isExpanded) {
          return Dismissible(
              key: Key(card.id.name),
              child: _buildStats(card),
              onDismissed: (direction) {
                setState(() {
                  _game.removeCardHand(card);
                });
              },
              background: Container(
                  alignment: AlignmentDirectional.centerEnd,
                  color: Colors.red,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
                    Padding(
                        padding: EdgeInsets.only(left: 10), child: Icon(Icons.delete, color: Colors.white)),
                    Padding(
                        padding: EdgeInsets.only(right: 10), child: Icon(Icons.delete, color: Colors.white))
                  ])));
        },
        body: _buildDescription(card),
        canTapOnHeader: true,
        isExpanded: _game.isVisibleHand(card));
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

  Box<Map<int, List<game.Cards>>> _getHandsBox() => Hive.box<Map<int, List<game.Cards>>>('hands');

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
          if (result != null) {
            setState(() {
              if (_page == 1) {
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
              selector: (card) => !_game.cardsHand.map((card) => card.id).contains(card.id),
              multiselect: true,
            );
          }),
        );
        if (result != null && _game.lengthHand <= 8) {
          setState(() {
            if (_page == 1) {
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
  AnimatedOpacity _buildDescription(game.Card card) {
    return AnimatedOpacity(
        opacity: _game.isVisibleHand(card) ? 1.0 : 0,
        duration: const Duration(milliseconds: 500),
        child: Visibility(
            visible: _game.isVisibleHand(card),
            child: Row(children: [
              const Spacer(),
              Expanded(flex: 5, child: Wrap(children: [Center(child: card.description)])),
              const Spacer(),
            ])));
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
                  decoration: _game.isActiveHand(card) ? TextDecoration.none : TextDecoration.lineThrough)),
        ),
        card.hasAction // actionButton
            ? Expanded(
                flex: 1,
                child: IconButton(
                  padding: const EdgeInsets.all(0),
                  iconSize: 20,
                  onPressed: card.hasAction
                      ? () {
                          _game.executeAction(context, card);
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
            child: Text('${_game.isVisibleHand(card) ? _game.bonus(card) - _game.penalty(card) : 0}',
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
    return SingleChildScrollView(
      child: ExpansionPanelList(
        children: _game.cardsAblage
            .map((card) => ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return Dismissible(
                      key: Key(card.id.name),
                      child: Row(
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
                              child: Text(
                                card.name,
                              )),
                          FittedBox(
                            child: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                setState(() {
                                  _game.removeCardAblage(card);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      onDismissed: (direction) {
                        setState(() {
                          _game.removeCardAblage(card);
                        });
                      },
                      background: Container(
                          alignment: AlignmentDirectional.centerEnd,
                          color: Colors.red,
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
                            Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Icon(Icons.delete, color: Colors.white)),
                            Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(Icons.delete, color: Colors.white))
                          ])));
                },
                body: _buildDescription(card),
                canTapOnHeader: true,
                isExpanded: _game.isVisibleAblage(card)))
            .toList(),
        expansionCallback: (index, isActive) {
          setState(() {
            _game.setVisibleAblage(_game.cardsHand.elementAt(index), !isActive);
          });
        },
      ),
    );
  }
}
