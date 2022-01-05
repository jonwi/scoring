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
  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.ultraHigh,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fill this out in the next steps.
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
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pop(_cards);
              }),
          FloatingActionButton(
            heroTag: 'btn2',
            // Provide an onPressed callback.
            onPressed: () async {
              // Take the Picture in a try / catch block. If anything goes wrong,
              // catch the error.
              try {
                // Ensure that the camera is initialized.
                await _initializeControllerFuture;

                // Attempt to take a picture and then get the location
                // where the image file is saved.
                final cameraImage = await _controller.takePicture();

                final inputImage = InputImage.fromFilePath(cameraImage.path);

                final textDetector = GoogleMlKit.vision.textDetector();

                final RecognisedText recognisedText = await textDetector.processImage(inputImage);
                List<String> foundCards = [];
                for (TextBlock block in recognisedText.blocks) {
                  for (TextLine line in block.lines) {
                    if (Deck()
                        .cards
                        .map((card) => card.name)
                        .where((element) => element == line.text)
                        .isNotEmpty) {
                      foundCards.add(line.text);
                    }
                  }
                }
                print(foundCards);
                setState(() {
                  _cards.addAll(foundCards);
                });
                textDetector.close();
              } catch (e) {
                // If an error occurs, log the error to the console.
                if (kDebugMode) {
                  print(e);
                }
              }
            },
            child: const Icon(Icons.camera_alt),
          ),
        ],
      ),
    );
  }
}
