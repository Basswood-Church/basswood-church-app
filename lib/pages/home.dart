import '../util.dart';
import 'giving_page.dart';
import 'package:audio_manager/audio_manager.dart';
import 'package:flutter/material.dart';

import 'bible_reading_plan.dart';
import 'bulletin_page.dart';
import 'sermons_page.dart';
import '../utils/color_scheme.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  int _numRefocuses = 0;
  List<Widget> _children = [];

  bool isPlaying = false;
  bool showPlayer = false;
  Duration _duration;
  Duration _position;
  double _slider;
  double _sliderVolume;
  num curIndex = 0;
  PlayMode playMode = AudioManager.instance.playMode;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    setupAudio();
  }

  // Initializing the Music Player and adding a single [PlaylistItem]
  Future<void> initPlatformState() async {
    // final AudioSession session = await AudioSession.instance;
    // await session.configure(const AudioSessionConfiguration.speech());

    _children = [
      null,
      SermonsPageWidget(),
      GivingPageWidget(),
      BulletinPageWidget(),
    ];
  }

  void setupAudio() {
    AudioManager.instance.intercepter = true;

    // events callback
    AudioManager.instance.onEvents((events, dynamic args) {
      print("$events, $args");
      switch (events) {
        case AudioManagerEvents.start:
          showPlayer = true;
          print(
              "start load data callback, curIndex is ${AudioManager.instance.curIndex}");
          _position = AudioManager.instance.position;
          _duration = AudioManager.instance.duration;
          _slider = 0;
          setState(() {});
          break;
        case AudioManagerEvents.ready:
          print("ready to play");
          _sliderVolume = AudioManager.instance.volume;
          _position = AudioManager.instance.position;
          _duration = AudioManager.instance.duration;
          setState(() {});
          // if you need to seek times, must after AudioManagerEvents.ready event invoked
          // AudioManager.instance.seekTo(Duration(seconds: 10));
          break;
        case AudioManagerEvents.seekComplete:
          _position = AudioManager.instance.position;
          _slider = _position.inMilliseconds / _duration.inMilliseconds;
          setState(() {});
          print("seek event is completed. position is [$args]/ms");
          break;
        case AudioManagerEvents.buffering:
          print("buffering $args");
          break;
        case AudioManagerEvents.playstatus:
          isPlaying = AudioManager.instance.isPlaying;
          setState(() {});
          break;
        case AudioManagerEvents.timeupdate:
          _position = AudioManager.instance.position;
          _slider = _position.inMilliseconds / _duration.inMilliseconds;
          setState(() {});
          // AudioManager.instance.updateLrc(args["position"].toString());
          break;
        case AudioManagerEvents.error:
          setState(() {});
          break;
        case AudioManagerEvents.ended:
          AudioManager.instance.next();
          break;
        case AudioManagerEvents.volumeChange:
          _sliderVolume = AudioManager.instance.volume;
          setState(() {});
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Christ the King Church',
            style: GoogleFonts.barlow(
                color: GREY3, fontSize: 22, fontWeight: FontWeight.w500),
          ),
          actions: _getAppBarActions(),
          backgroundColor: MAIN1,
        ),
        body: Column(children: <Widget>[
          Expanded(
              child: Container(
                  child: _currentIndex == 0
                      ? BibleReadingPlan(numRefocuses: _numRefocuses)
                      : _children[_currentIndex],
                  alignment: Alignment.center)),
          Container(
            height: showPlayer ? 120 : 0,
            width: double.maxFinite,
            child: showPlayer ? bottomPanel() : Container(),
          )
        ]),
        bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 0.02,
                ),
              ],
            ),
            child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                onTap: onTabTapped,
                currentIndex: _currentIndex,
                backgroundColor: MAIN1,
                selectedItemColor: SECOND1,
                unselectedItemColor: SECOND2,
                unselectedLabelStyle: GoogleFonts.josefinSans(
                    color: GREY3, fontWeight: FontWeight.w500),
                selectedLabelStyle: GoogleFonts.josefinSans(
                    color: GREY3, fontWeight: FontWeight.w500),
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.book),
                    backgroundColor: MAIN1,
                    label: 'Reading',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.headset),
                    label: 'Sermons',
                  ),
                  // BottomNavigationBarItem(
                  //   icon: Icon(Icons.attach_money),
                  //   title: Text('Giving'),
                  // ),
                  // BottomNavigationBarItem(
                  //   icon: Icon(Icons.picture_as_pdf),
                  //   title: Text('Bulletin'),
                  // ),
                ])));
  }

  Widget bottomPanel() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 1),
        child: Column(children: <Widget>[
          //////////
          Container(
              color: MAIN1,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                child: songProgress(context),
              )),
          Container(
            decoration: new BoxDecoration(color: MAIN1),
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                    icon: getPlayModeIcon(playMode),
                    onPressed: () {
                      playMode = AudioManager.instance.nextMode();
                      setState(() {});
                    }),
                IconButton(
                    iconSize: 36,
                    icon: Icon(
                      Icons.skip_previous,
                      color: GREY3,
                    ),
                    onPressed: () => AudioManager.instance.previous()),
                IconButton(
                  onPressed: () async {
                    bool playing = await AudioManager.instance.playOrPause();
                    print("await -- $playing");
                  },
                  padding: const EdgeInsets.all(0.0),
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 48.0,
                    color: GREY3,
                  ),
                ),
                IconButton(
                    iconSize: 36,
                    icon: Icon(
                      Icons.skip_next,
                      color: GREY3,
                    ),
                    onPressed: () => AudioManager.instance.next()),
                IconButton(
                    icon: Icon(
                      Icons.stop,
                      color: GREY3,
                    ),
                    onPressed: () {
                      setState(() {
                        showPlayer = false;
                        AudioManager.instance.stop();
                      });
                    }),
              ],
            ),
          ),
        ]));
  }

  Widget getPlayModeIcon(PlayMode playMode) {
    switch (playMode) {
      case PlayMode.sequence:
        return Icon(
          Icons.repeat,
          color: GREY3,
        );
      case PlayMode.shuffle:
        return Icon(
          Icons.shuffle,
          color: GREY3,
        );
      case PlayMode.single:
        return Icon(
          Icons.repeat_one,
          color: GREY3,
        );
    }
    return Container();
  }

  Widget songProgress(BuildContext context) {
    var style = TextStyle(color: GREY3);
    return Container(
        color: MAIN1,
        child: Row(
          children: <Widget>[
            Text(
              _formatDuration(_position),
              style: style,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 2,
                      thumbColor: SECOND1,
                      overlayColor: SECOND1,
                      thumbShape: RoundSliderThumbShape(
                        disabledThumbRadius: 5,
                        enabledThumbRadius: 5,
                      ),
                      overlayShape: RoundSliderOverlayShape(
                        overlayRadius: 10,
                      ),
                      activeTrackColor: SECOND1,
                      inactiveTrackColor: GREY3,
                    ),
                    child: Slider(
                      value: _slider ?? 0,
                      onChanged: (value) {
                        setState(() {
                          _slider = value;
                        });
                      },
                      onChangeEnd: (value) {
                        if (_duration != null) {
                          Duration msec = Duration(
                              milliseconds:
                                  (_duration.inMilliseconds * value).round());
                          AudioManager.instance.seekTo(msec);
                        }
                      },
                    )),
              ),
            ),
            Text(
              _formatDuration(_duration),
              style: style,
            ),
          ],
        ));
  }

  String _formatDuration(Duration d) {
    if (d == null) return "--:--";
    int minute = d.inMinutes;
    int second = (d.inSeconds > 60) ? (d.inSeconds % 60) : d.inSeconds;
    String format = ((minute < 10) ? "0$minute" : "$minute") +
        ":" +
        ((second < 10) ? "0$second" : "$second");
    return format;
  }

  Widget volumeFrame() {
    return Row(children: <Widget>[
      IconButton(
          padding: EdgeInsets.all(0),
          icon: Icon(
            Icons.audiotrack,
            color: Colors.black,
          ),
          onPressed: () {
            AudioManager.instance.setVolume(0);
          }),
      Expanded(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Slider(
                value: _sliderVolume ?? 0,
                onChanged: (value) {
                  setState(() {
                    _sliderVolume = value;
                    AudioManager.instance.setVolume(value, showVolume: true);
                  });
                },
              )))
    ]);
  }

  void onTabTapped(int index) {
    if (index == 0) {
      setState(() {
        _currentIndex = index;
      });
    } else if (index == 1) {
      launchURL('https://ctkchurch.info/sermons');
    } else if (index == 2) {
      launchURL('https://www.basswoodchurch.net/give');
    } else if (index == 3) {
      launchURL('https://www.basswoodchurch.net/bulletin');
    }
    // setState(() {
    //   _currentIndex = index;
    // });
  }

  List<Widget> _getAppBarActions() {
    final List<Widget> retVal = <Widget>[];
    if (_currentIndex == 0) {
      if (isPlaying) {
        retVal.add(IconButton(
          iconSize: 24,
          icon: const Icon(
            Icons.stop,
            color: GREY3,
          ),
          onPressed: () {
            setState(() {
              showPlayer = false;
              AudioManager.instance.stop();
            });
          },
        ));
      }

      retVal.add(IconButton(
        iconSize: 24,
        icon: const Icon(
          Icons.today,
          color: GREY3,
        ),
        onPressed: () {
          setState(() {
            _numRefocuses++;
          });
        },
      ));
    }

    return retVal;
  }
}
