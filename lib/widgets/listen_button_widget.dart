import 'package:audio_manager/audio_manager.dart';
import 'package:flutter/material.dart';

class ListenButtonWidget extends StatefulWidget {
  ListenButtonWidget({this.title, this.description, this.url});
  String title;
  String description;
  String url;

  @override
  State<StatefulWidget> createState() => _ListenButtonWidgetState();
}

class _ListenButtonWidgetState extends State<ListenButtonWidget> {
  bool playing = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      FlatButton.icon(
          color: Colors.blue,
          icon: const Icon(Icons.headset),
          label: const Text('LISTEN'),
          onPressed: () {
            if (AudioManager.instance.isPlaying) {
              AudioManager.instance.stop();
            } else {
              AudioManager.instance
                  .start(widget.url, widget.title,
                      desc: widget.description,
                      cover: 'https://ctk-app.jcb3.de/icon.jpg')
                  .then((err) {
                print('Error' + err.toString());
              });
            }
            setState(() {
              playing = !playing;
            });
          })
    ]);
  }
}
