import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:study_is_good/test_clock.dart';
import 'package:study_is_good/timer/countdown_timer.dart';

class CountDownTimerPage extends StatefulWidget {

   const CountDownTimerPage(
      {required this.controller,
      Key? key}) : super(key: key);

  final AnimationController controller;

  @override
  State<CountDownTimerPage> createState() => _CountDownTimerPageState();
}

class _CountDownTimerPageState extends State<CountDownTimerPage> {
  int countdownSeconds = 5; //total timer limit in seconds
  late CountdownTimer countdownTimer;
  bool isTimerRunning = false;

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
      countdownSeconds = 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                              animation: widget.controller,
                              backgroundColor: Colors.white,
                              color: themeData.indicatorColor,
                            )
                        ),
                      ),
                      Align(
                        alignment: FractionalOffset.center,
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Count Down Timer",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  //color: Colors.white
                                ),
                            ),
                            Text(
                              countdownSeconds.toString(),
                              style: TextStyle(
                                  fontSize: 112.0,
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
            const SizedBox(
              height: 32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  color: Colors.tealAccent,
                  onPressed: () {
                    initTimerOperation();
                  },
                  child: const Text("Start Timer"),
                ),
                MaterialButton(
                  color: Colors.orangeAccent,
                  onPressed: () {
                    stopTimer();
                  },
                  child: const Text("Stop Timer"),
                ),
                MaterialButton(
                  color: Colors.redAccent,
                  onPressed: () {
                    resetTimer();
                  },
                  child: const Text("Reset Timer"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}