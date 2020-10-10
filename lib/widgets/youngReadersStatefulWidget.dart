import 'package:BasswoodChurch/widgets/labeledSwitch.dart';
import 'package:flutter/material.dart';

/// This is the stateful widget that the main application instantiates.
class YoungReadersStatefulWidget extends StatefulWidget {
  const YoungReadersStatefulWidget({Key key}) : super(key: key);

  @override
  _YoungReadersStatefulWidgetState createState() => _YoungReadersStatefulWidgetState();
}

/// This is the private State class that goes with YoungReadersStatefulWidget.
class _YoungReadersStatefulWidgetState extends State<YoungReadersStatefulWidget> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return LabeledSwitch(
      label: 'Young Readers',
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      value: _isSelected,
      onChanged: (bool newValue) {
        setState(() {
          _isSelected = newValue;
        });
      },
    );
  }
}