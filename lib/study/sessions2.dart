import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:audio_session/audio_session.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:study_is_good/audioplayers/common.dart';
import 'package:rxdart/rxdart.dart';
import 'package:study_is_good/main.dart';
import 'package:study_is_good/navigation.dart';
import 'package:study_is_good/session_screen.dart';
import 'package:study_is_good/timer/countdown_timer.dart';


class TestCountDownTimer extends StatefulWidget {
  const TestCountDownTimer({
    super.key,
    required this.time,
    required this.points,
  });

  final int time;
  final int points;
  @override
  _TestCountDownTimerState createState() => _TestCountDownTimerState();
}


class _TestCountDownTimerState extends State<TestCountDownTimer> with TickerProviderStateMixin, WidgetsBindingObserver {
  late int countdownSeconds = widget.time; //total timer limit in seconds
  late AudioPlayer _player;
  late CountdownTimer countdownTimer;
  bool isTimerRunning = false;
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
  late AnimationController controller;
  bool isPressed = false;
  late User user;


  @override
  void initState() {
    super.initState();
    user = auth.currentUser!;
    ambiguate(WidgetsBinding.instance)!.addObserver(this);
    _player = AudioPlayer();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: countdownSeconds),
    );
  }

  void initTimerOperation() {
    //timer callbacks
    countdownTimer = CountdownTimer(
      seconds: countdownSeconds,
      onTick: (seconds) {
        isTimerRunning = true;
        setState(() {
          countdownSeconds = seconds; //this will return the timer values
        });
      },
      onFinished: () {
        stopTimer();
        // Handle countdown finished
      },
    );

    //native app life cycle
    SystemChannels.lifecycle.setMessageHandler((msg) {
      // On AppLifecycleState: paused
      if (msg == AppLifecycleState.paused.toString()) {
        if (isTimerRunning) {
          countdownTimer.pause(countdownSeconds); //setting end time on pause
        }
      }

      // On AppLifecycleState: resumed
      if (msg == AppLifecycleState.resumed.toString()) {
        if (isTimerRunning) {
          countdownTimer.resume();
        }
      }
      return Future(() => null);
    });

    //starting timer
    isTimerRunning = true;
    countdownTimer.start();
  }

  void stopTimer() {
    isTimerRunning = false;
    countdownTimer.stop();
  }

  void resetTimer() {
    stopTimer();
    setState(() {
      countdownSeconds = 30;
    });
  }


  String get timerString {
    Duration duration = controller.duration! * controller.value;
    return '${duration.inHours}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  String get sessionTime {
    Duration duration = controller.duration!;
    return '${duration.inHours}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
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
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    _player.dispose();
    controller.dispose();
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

  /// Collects the data useful for displaying in a seek bar, using a handy
  /// feature of rx_dart to combine the 3 streams of interest into one.
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
              (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));


  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) {
                    return Stack(
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Align(
                                alignment: FractionalOffset.center,
                                child: AspectRatio(
                                  aspectRatio: 1.0,
                                  child: Stack(
                                    children: <Widget>[
                                      Positioned.fill(
                                        child: CustomPaint(
                                            painter: CustomTimerPainter(
                                              animation: controller,
                                              backgroundColor: Colors.white,
                                              color: themeData.indicatorColor,
                                            )),
                                      ),
                                      Align(
                                        alignment: FractionalOffset.center,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            const Text(
                                              "Count Down Timer",
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  //color: Colors.white
                                              ),
                                            ),
                                            Text(
                                              timerString,
                                              style: const TextStyle(
                                                  fontSize: 50.0,
                                                  //color: Colors.white
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AnimatedBuilder(
                                  animation: controller,
                                  builder: (context, child) {
                                    return FloatingActionButton.extended(
                                        onPressed: () {
                                          if (controller.isAnimating) {
                                            controller.stop();

                                          } else {
                                            setState(() {
                                              isPressed = true;
                                            });
                                            controller.reverse(
                                                from: controller.value == 0.0
                                                    ? 1.0
                                                    : controller.value);
                                          }
                                        },
                                        icon: Icon(controller.isAnimating
                                            ? Icons.pause
                                            : Icons.play_arrow),
                                        label: Text(
                                            controller.isAnimating ? "Pause" : "Play")
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
            ),
          ),
          Expanded(
            flex: 5,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
              )
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return ElevatedButton(
                    onPressed: (controller.value != 0.0 || isPressed == false ) ? null : () async {
                      await FirebaseFirestore.instance
                          .collection("StudyIsGood")
                          .doc("Players")
                          .collection("All Users")
                          .doc(user.uid).collection("All Sessions")
                          .add({
                              "time": sessionTime,
                              "points": widget.points
                            }
                            );
                      await FirebaseFirestore.instance
                          .collection("StudyIsGood")
                          .doc("Players")
                          .collection("All User Points")
                          .doc(user.uid)
                          .update(
                        {"points": FieldValue.increment(widget.points)},
                      );
                      await FirebaseFirestore.instance
                          .collection("StudyIsGood")
                          .doc("Players")
                          .collection("All Users")
                          .doc(user.uid)
                          .update(
                        {"points": FieldValue.increment(widget.points)},
                      );
                      if (mounted) {
                        Navigator.of(context).pop(); // Pop the current route (TestCountDownTimer)
                      }
                    },
                    child: const Text("Claim Reward when Done"),
                  );
                },
                //child:
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    required this.animation,
    required this.backgroundColor,
    required this.color,
  }) : super(repaint: animation);


  final Animation<double> animation;
  final Color backgroundColor, color;


  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;


    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }


  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}

/// Displays the play/pause button and volume/speed sliders.
class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Opens volume slider dialog
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

        /// This StreamBuilder rebuilds whenever the player state changes, which
        /// includes the playing/paused state and also the
        /// loading/buffering/ready state. Depending on the state we show the
        /// appropriate button or loading indicator.
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
                onPressed:  player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon:  const Icon(Icons.pause),
                iconSize: 64.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.replay),
                iconSize: 64.0,
                onPressed: () => player.seek(Duration.zero),
              );
            }
          },
        ),
        // Opens speed slider dialog
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







