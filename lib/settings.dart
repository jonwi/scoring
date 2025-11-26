import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Settings {
  static Settings? instance;

  bool _isExpansion;

  bool get isExpansion => _isExpansion;

  set isExpansion(bool isExpansion) {
    _isExpansion = isExpansion;
    _save();
  }

  Settings._(this._isExpansion);

  static Settings getInstance() {
    instance ??= _load();
    return instance!;
  }

  void _save() {
    Map<dynamic, dynamic> result = {'isExpansion': isExpansion};
    Hive.box<Map<dynamic, dynamic>>('settings').put('settings', result);
  }

  static Settings _load() {
    var set = Hive.box<Map<dynamic, dynamic>>('settings').get('settings');
    if (set == null) {
      return Settings._(false);
    }
    return Settings._(set['isExpansion']!);
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
          setState(() {_isExpansion = !_isExpansion;})
        },
        title: const Text('Erweiterung'),
      ),
    );
  }
}
