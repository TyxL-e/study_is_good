// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
//
// class SessionPage extends StatefulWidget {
//   const SessionPage({
//     super.key,
//   });
//
//
//   @override
//   State<SessionPage> createState() => _SessionPageState();
// }
//
//
// class _SessionPageState extends State<SessionPage> {
//   bool _visible = true;
//   Timer? _timer;
//   int _sec = 10;
//   IconData btnPlayStatus = Icons.play_arrow;
//   Stopwatch watch = Stopwatch();
//   bool startStop = true;
//   String elapsedTime = '';
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   updateTime(Timer timer) {
//     if (watch.isRunning) {
//       setState(() {
//         elapsedTime = transformMilliSeconds(_sec * 1000 - watch.elapsedMilliseconds);
//         _sec * 1000 - 1000;
//       });
//     }
//   }
//
//   Future<void> zonedScheduleNotification(String title, String body, int time) async {
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//         0,
//         title,
//         body,
//         tz.TZDateTime.now(tz.local).add(Duration(seconds: time)),
//         const NotificationDetails(
//             android: AndroidNotificationDetails(
//                 'your channel id', 'your channel name',
//                 channelDescription: 'your channel description')),
//         androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//         uiLocalNotificationDateInterpretation:
//         UILocalNotificationDateInterpretation.absoluteTime);
//   }
//
//   Future<void> _showNotificationWithCustomTimestamp(String title, String body) async {
//     final AndroidNotificationDetails androidNotificationDetails =
//     AndroidNotificationDetails(
//       'your channel id',
//       'your channel name',
//       channelDescription: 'your channel description',
//       importance: Importance.max,
//       priority: Priority.high,
//       when: DateTime.now().millisecondsSinceEpoch - 120 * 1000,
//       usesChronometer: true,
//       chronometerCountDown: true,
//     );
//     final NotificationDetails notificationDetails =
//     NotificationDetails(android: androidNotificationDetails);
//     await flutterLocalNotificationsPlugin.show(
//         0, title, "You have studied for: $body", notificationDetails,
//         payload: 'item x');
//   }
//
//   final Stream<int> _bids = (() {
//     late final StreamController<int> controller;
//     controller = StreamController<int>(
//       onListen: () async {
//         await Future<void>.delayed(const Duration(seconds: 5));
//         controller.add(5);
//         await Future<void>.delayed(const Duration(seconds: 5));
//         await controller.close();
//       },
//     );
//     return controller.stream;
//   })();
//
//   void startTimer() {
//     const oneSec = const Duration(seconds: 1);
//     const oneMin = const Duration(seconds: 60);
//     const oneHr = const Duration(minutes: 60);
//     _timer = Timer.periodic(
//       oneSec,
//           (Timer timer) {
//         if (_sec == 0) {
//         } else {
//           setState(() {
//             _sec--;
//           });
//         }
//       },
//     );
//   }
//
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Focus Mode Enabled"),
//       ),
//       body: Center(
//         child:SingleChildScrollView(
//           child: Column(
//             children: [
//               Stack(
//                 children:[
//                   AnimatedOpacity(
//                     opacity: _visible ? 0.8 : 0.0,
//                     duration: const Duration(milliseconds: 500),
//                     child: Container(
//                       width: 125,
//                       height: 18,
//                       color: Colors.orangeAccent,
//                     ),
//                   ),
//                   AnimatedOpacity(
//                     opacity: _visible ? 0.8 : 0.0,
//                     duration: const Duration(milliseconds: 500),
//                     child: const SizedBox(
//                       width: 200,
//                       height: 100,
//                       child: Text(
//                         "Points:",
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Stack(
//                   children:[
//                     AnimatedOpacity(
//                       opacity: _visible ? 0.2 : 0.0,
//                       duration: const Duration(milliseconds: 500),
//                       child: Container(
//                         width: 200,
//                         height: 100,
//                         color: Colors.blueGrey,
//                       ),
//                     ),
//                     AnimatedOpacity(
//                       opacity: _visible ? 0.8 : 0.0,
//                       duration: const Duration(milliseconds: 500),
//                       child: const SizedBox(
//                         width: 200,
//                         height: 100,
//                         child: Text(
//                           "This is a quote",
//                         ),
//                       ),
//                     ),
//                   ]
//               ),
//               // Container(
//               //   padding: const EdgeInsets.all(20.0),
//               //   child: Column(
//               //     children: <Widget>[
//               //       Text(elapsedTime, style: const TextStyle(fontSize: 25.0)),
//               //       const SizedBox(height: 20.0),
//               //       FloatingActionButton(
//               //           heroTag: "btn1",
//               //           backgroundColor: Colors.red,
//               //           onPressed: () => startOrStop(elapsedTime),
//               //           child: (startStop) ? const Icon(Icons.play_arrow) : const Icon(Icons.pause))
//               //     ],
//               //   ),
//               // ),
//               Text("$_sec"),
//               ElevatedButton(
//                 onPressed: () {
//                   startTimer();
//                 },
//                 child: const Text("start"),
//               ),
//
//               SizedBox(
//                 child: TextField(
//                   obscureText: false,
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: 'Input your Time',
//                   ),
//                   onChanged: (value){
//                     setState(() {
//                       _sec = int.parse(value);
//                     });
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//
//
//       floatingActionButton: FloatingActionButton(
//         heroTag: "OPACITY BUTTON",
//         onPressed: () {
//           setState(() {
//             _visible = !_visible;
//           });
//         },
//         tooltip: 'Toggle Opacity',
//         child: const Icon(Icons.flip),
//       ),
//     );
//   }
//   startOrStop(String elapsedTime) {
//     if(startStop && _sec * 1000 - watch.elapsedMilliseconds > 0) {
//       startWatch();
//     } else {
//       stopWatch();
//       _showNotificationWithCustomTimestamp("title", transformMilliSeconds(_sec * 1000 - watch.elapsedMilliseconds));
//     }
//   }
//
//   startWatch() {
//     setState(() {
//       startStop = false;
//       watch.start();
//       _timer = Timer.periodic(const Duration(milliseconds: 100), updateTime);
//     });
//   }
//
//   stopWatch() {
//     setState(() {
//       startStop = true;
//       watch.stop();
//       setTime();
//     });
//   }
//
//   setTime() {
//     var timeSoFar = _sec * 1000 - watch.elapsedMilliseconds;
//     setState(() {
//       elapsedTime = transformMilliSeconds(timeSoFar);
//     });
//   }
//
//   transformMilliSeconds(int milliseconds) {
//     int hundreds = (milliseconds / 10).truncate();
//     int seconds = (hundreds / 100).truncate();
//     int minutes = (seconds / 60).truncate();
//     int hours = (minutes / 60).truncate();
//
//     String hoursStr = (hours % 60).toString().padLeft(2, '0');
//     String minutesStr = (minutes % 60).toString().padLeft(2, '0');
//     String secondsStr = (seconds % 60).toString().padLeft(2, '0');
//
//     return "$hoursStr:$minutesStr:$secondsStr";
//   }
// }
//
//

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:study_is_good/audioplayers/common.dart';
import 'package:study_is_good/timer/count_down_timer_page.dart';


class SessionScreen extends StatefulWidget {
  const SessionScreen({Key? key}) : super(key: key);

  @override
  SessionScreenState createState() => SessionScreenState();
}

class SessionScreenState extends State<SessionScreen> with WidgetsBindingObserver,TickerProviderStateMixin{
  late AnimationController controller;
  late AudioPlayer _player;
  final _playlist = ConcatenatingAudioSource(children: [
    // Remove this audio source from the Windows and Linux version because it's not supported yet
    if (kIsWeb ||
        ![TargetPlatform.windows, TargetPlatform.linux]
            .contains(defaultTargetPlatform))
      ClippingAudioSource(
        start: const Duration(seconds: 60),
        end: const Duration(seconds: 90),
        child: AudioSource.uri(Uri.parse(
            "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3")),
        tag: AudioMetadata(
          album: "Science Friday",
          title: "A Salute To Head-Scratching Science (30 seconds)",
          artwork:
          "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
        ),
      ),
    AudioSource.uri(
      Uri.parse(
          "https://firebasestorage.googleapis.com/v0/b/chat-app-91a9d.appspot.com/o/StudyIsGood%2Fmusic%2Fmusic%201.mp3?alt=media&token=0edaa54f-94c6-486d-bb87-a6150df75d09"),
      tag: AudioMetadata(
        album: "Science Friday",
        title: "A Salute To Head-Scratching Science",
        artwork:
        "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
      ),
    ),
    AudioSource.uri(
      Uri.parse("https://firebasestorage.googleapis.com/v0/b/chat-app-91a9d.appspot.com/o/StudyIsGood%2Fmusic%2Fmusic%202.mp3?alt=media&token=084b2100-ccee-4a74-9427-5d672341ba56"),
      tag: AudioMetadata(
        album: "Science Friday",
        title: "From Cat Rheology To Operatic Incompetence",
        artwork:
        "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
      ),
    ),
  ]);
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    ambiguate(WidgetsBinding.instance)!.addObserver(this);
    _player = AudioPlayer();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
          print('A stream error occurred: $e');
        });
    try {
      // Preloading audio is not currently supported on Linux.
      await _player.setAudioSource(_playlist,
          preload: kIsWeb || defaultTargetPlatform != TargetPlatform.linux);
    } catch (e) {
      // Catch load errors: 404, invalid url...
      print("Error loading audio source: $e");
    }
    // Show a snackbar whenever reaching the end of an item in the playlist.
    _player.positionDiscontinuityStream.listen((discontinuity) {
      if (discontinuity.reason == PositionDiscontinuityReason.autoAdvance) {
        _showItemFinished(discontinuity.previousEvent.currentIndex);
      }
    });
    _player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        _showItemFinished(_player.currentIndex);
      }
    });
  }

  void _showItemFinished(int? index) {
    if (index == null) return;
    final sequence = _player.sequence;
    if (sequence == null) return;
    final source = sequence[index];
    final metadata = source.tag as AudioMetadata;
    _scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text('Finished playing ${metadata.title}'),
      duration: const Duration(seconds: 1),
    ));
  }

  @override
  void dispose() {
    ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    _player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      _player.stop();
    }
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
              (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: StreamBuilder<SequenceState?>(
                stream: _player.sequenceStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  if (state?.sequence.isEmpty ?? true) {
                    return const SizedBox();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child:
                          CountDownTimerPage(controller: controller,),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            ControlButtons(_player),
            StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return SeekBar(
                  duration: positionData?.duration ?? Duration.zero,
                  position: positionData?.position ?? Duration.zero,
                  bufferedPosition:
                  positionData?.bufferedPosition ?? Duration.zero,
                  onChangeEnd: (newPosition) {
                    _player.seek(newPosition);
                  },
                );
              },
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                StreamBuilder<LoopMode>(
                  stream: _player.loopModeStream,
                  builder: (context, snapshot) {
                    final loopMode = snapshot.data ?? LoopMode.off;
                    const icons = [
                      Icon(Icons.repeat, color: Colors.grey),
                      Icon(Icons.repeat, color: Colors.orange),
                      Icon(Icons.repeat_one, color: Colors.orange),
                    ];
                    const cycleModes = [
                      LoopMode.off,
                      LoopMode.all,
                      LoopMode.one,
                    ];
                    final index = cycleModes.indexOf(loopMode);
                    return IconButton(
                      icon: icons[index],
                      onPressed: () {
                        _player.setLoopMode(cycleModes[
                        (cycleModes.indexOf(loopMode) + 1) %
                            cycleModes.length]);
                      },
                    );
                  },
                ),
                Expanded(
                  child: Text(
                    "Playlist",
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                StreamBuilder<bool>(
                  stream: _player.shuffleModeEnabledStream,
                  builder: (context, snapshot) {
                    final shuffleModeEnabled = snapshot.data ?? false;
                    return IconButton(
                      icon: shuffleModeEnabled
                          ? const Icon(Icons.shuffle, color: Colors.orange)
                          : const Icon(Icons.shuffle, color: Colors.grey),
                      onPressed: () async {
                        final enable = !shuffleModeEnabled;
                        if (enable) {
                          await _player.shuffle();
                        }
                        await _player.setShuffleModeEnabled(enable);
                      },
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              height: 240.0,
              child: StreamBuilder<SequenceState?>(
                stream: _player.sequenceStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  final sequence = state?.sequence ?? [];
                  return ReorderableListView(
                    onReorder: (int oldIndex, int newIndex) {
                      if (oldIndex < newIndex) newIndex--;
                      _playlist.move(oldIndex, newIndex);
                    },
                    children: [
                      for (var i = 0; i < sequence.length; i++)
                        Dismissible(
                          key: ValueKey(sequence[i]),
                          background: Container(
                            color: Colors.redAccent,
                            alignment: Alignment.centerRight,
                            child: const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                          ),
                          onDismissed: (dismissDirection) {
                            _playlist.removeAt(i);
                          },
                          child: Material(
                            color: i == state!.currentIndex
                                ? Colors.grey.shade300
                                : null,
                            child: ListTile(
                              title: Text(sequence[i].tag.title as String),
                              onTap: () {
                                _player.seek(Duration.zero, index: i);
                              },
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.add),
      //   onPressed: () {
      //     _playlist.add(AudioSource.uri(
      //       Uri.parse("asset:///audio/nature.mp3"),
      //       tag: AudioMetadata(
      //         album: "Public Domain",
      //         title: "Nature Sounds ${++_addedCount}",
      //         artwork:
      //         "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
      //       ),
      //     ));
      //   },
      // ),
    );
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.volume_up),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              value: player.volume,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: const Icon(Icons.skip_previous),
            onPressed: player.hasPrevious ? player.seekToPrevious : null,
          ),
        ),
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: const CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                icon: const Icon(Icons.play_arrow),
                iconSize: 64.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(Icons.pause),
                iconSize: 64.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.replay),
                iconSize: 64.0,
                onPressed: () => player.seek(Duration.zero,
                    index: player.effectiveIndices!.first),
              );
            }
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: const Icon(Icons.skip_next),
            onPressed: player.hasNext ? player.seekToNext : null,
          ),
        ),
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              showSliderDialog(
                context: context,
                title: "Adjust speed",
                divisions: 10,
                min: 0.5,
                max: 1.5,
                value: player.speed,
                stream: player.speedStream,
                onChanged: player.setSpeed,
              );
            },
          ),
        ),
      ],
    );
  }
}

class AudioMetadata {
  final String album;
  final String title;
  final String artwork;

  AudioMetadata({
    required this.album,
    required this.title,
    required this.artwork,
  });
}
