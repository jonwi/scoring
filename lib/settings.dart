import 'package:flutter/material.dart';

class Settings {
  static Settings? instance;

  // TODO: Bei Änderung muss die Liste mit Karten eventuell erneuert werden.
  bool isExpansion;

  Settings._(this.isExpansion);

  static Settings getInstance() {
    instance ??= Settings._(true);
    return instance!;
  }
}

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SettingsState();
  }
}

class SettingsState extends State<SettingsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Einstellungen'),
      ),
      body: CheckboxListTile(
        value: Settings.getInstance().isExpansion,
        onChanged: (val) => {
          setState(() => {Settings.getInstance().isExpansion = !Settings.getInstance().isExpansion})
        },
        title: const Text('Erweiterung'),
      ),
    );
  }
}
