import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

import 'card.dart';

class CameraScan extends StatefulWidget {
  const CameraScan({Key? key, required this.camera}) : super(key: key);

  final CameraDescription camera;

  @override
  State<StatefulWidget> createState() {
    return TakePictureScreenState();
  }
}

class TakePictureScreenState extends State<CameraScan> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final Map<Cards, int> _cards = {};
  final _textDetector = GoogleMlKit.vision.textDetector();

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.max,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    _textDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text('Scanner'), Text('Anzahl: ${_cards.length}')]),
      ),
      body: Stack(alignment: Alignment.center, children: [
        FutureBuilder(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CameraPreview(_controller);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        ListView.builder(
            itemCount: _cards.length,
            itemBuilder: (context, index) {
              var list = _cards.entries.toList();
              list.sort((e1, e2) => e1.value.compareTo(e2.value));
              var name = list.elementAt(index).key.cardName;
              return ListTile(
                title: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: Text(
                        name,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ]),
                trailing: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 70,
                      icon: const Icon(
                        Icons.remove_circle_outline_sharp,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        setState(() {
                          _cards.remove(name);
                        });
                      },
                    ),
                  ),
                ),
              );
            }),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Expanded(
          flex: 1,
          child: FloatingActionButton(
            heroTag: 'btn2',
            onPressed: () async {
              await _scan();
            },
            child: const Icon(Icons.camera_alt),
          ),
        ),
        Expanded(
          flex: 1,
          child: FloatingActionButton(
              heroTag: 'btn1',
              backgroundColor: _cards.isNotEmpty ? Colors.green : Colors.grey,
              child: const Icon(Icons.check),
              onPressed: () {
                Navigator.of(context).pop(_cards.keys.toSet());
              }),
        ),
      ]),
    );
  }

  Future<void> _scan() async {
    try {
      await _initializeControllerFuture;
      final cameraImage = await _controller.takePicture();
      final inputImage = InputImage.fromFilePath(cameraImage.path);

      final RecognisedText recognisedText = await _textDetector.processImage(inputImage);
      List<String> foundCards = [];
      print(recognisedText.text);
      for (TextBlock block in recognisedText.blocks) {
        for (TextLine line in block.lines) {
          var list = Deck().cards.map((card) => card.name).where((name) {
            var a = line.text.replaceAll(RegExp('[MTHhbtä]'), '').toLowerCase();
            var b = name.replaceAll(RegExp('[MTHhbtä]'), '').toLowerCase();
            return a.contains(b);
          });
          if (list.isNotEmpty) {
            if (list.length == 1) {
              foundCards.add(list.first);
            } else {
              // Königin contains König
              if (list.first == 'König' || list.first == 'Königin') {
                foundCards.add('Königin');
              }
              if (list.first == 'Blizzard' || list.first == 'Blitz') {
                foundCards.add('Blizzard');
              }
            }
          }
        }
      }
      int c = 0;
      for (var name in foundCards) {
        _cards.putIfAbsent(Deck().cards.firstWhere((element) => element.name == name).id, () => c++);
      }
      setState(() {});
    } catch (e) {
      // If an error occurs, log the error to the console.
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
