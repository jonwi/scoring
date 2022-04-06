import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class NumberPickerWidget extends StatefulWidget {
  const NumberPickerWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NumberPickerWidgetState();
  }
}

class NumberPickerWidgetState extends State<NumberPickerWidget> {
  int _players = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Wähle die Anzahl der Spieler aus:'),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: NumberPicker(
                  minValue: 2,
                  maxValue: 6,
                  value: _players,
                  onChanged: (val) {
                    setState(() {
                      _players = val;
                    });
                  }),
            ),
            CircleAvatar(
              backgroundColor: Colors.green,
              child: IconButton(
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context, _players);
                  },
                  icon: const Icon(Icons.check)),
            )
          ],
        ),
      ),
    );
  }
}
