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
  final Set<String> _cards = {};
  final _textDetector = GoogleMlKit.vision.textDetector();
  bool _scanning = false;

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
              return ListTile(
                title: Text(
                  _cards.elementAt(index),
                  textAlign: TextAlign.right,
                ),
              );
            }),
      ]),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
              heroTag: 'btn1',
              backgroundColor: _cards.isNotEmpty ? Colors.green : Colors.grey,
              child: const Icon(Icons.check),
              onPressed: () {
                Navigator.of(context).pop(_cards);
              }),
          FloatingActionButton(
            heroTag: 'btn2',
            onPressed: () async {
              if (_scanning) {
                setState(() {
                  _scanning = false;
                });
              } else {
                setState(() {
                  _scanning = true;
                });
                while (_scanning) {
                  await _scann();
                }
              }
            },
            child: Icon(_scanning ? Icons.close : Icons.camera_alt),
          ),
        ],
      ),
    );
  }

  Future<void> _scann() async {
    try {
      await _initializeControllerFuture;
      final cameraImage = await _controller.takePicture();
      final inputImage = InputImage.fromFilePath(cameraImage.path);

      final RecognisedText recognisedText = await _textDetector.processImage(inputImage);
      List<String> foundCards = [];
      for (TextBlock block in recognisedText.blocks) {
        for (TextLine line in block.lines) {
          if (Deck().cards.map((card) => card.name).where((element) => element == line.text).isNotEmpty) {
            foundCards.add(line.text);
          }
        }
      }
      setState(() {
        _cards.addAll(foundCards);
      });
    } catch (e) {
      // If an error occurs, log the error to the console.
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
