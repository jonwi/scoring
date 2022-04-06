import 'package:flutter/material.dart';

class Settings {
  static Settings? instance;

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
  bool _isExpansion = Settings.getInstance().isExpansion;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Einstellungen'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, _isExpansion);
          },
        ),
      ),
      body: CheckboxListTile(
        value: _isExpansion,
        onChanged: (val) => {
          setState(() => {_isExpansion = !_isExpansion})
        },
        title: const Text('Erweiterung'),
      ),
    );
  }
}
