import 'dart:async';


import 'package:flutter/material.dart';


class SessionPage extends StatefulWidget {
  const SessionPage({
    super.key,
  });


  @override
  State<SessionPage> createState() => _SessionPageState();
}


class _SessionPageState extends State<SessionPage> {
  bool _visible = true;






  late Timer _timer;
  int _sec = 10;
  int _min = 10;
  int _hr = 10;


  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    const oneMin = const Duration(seconds: 60);
    const oneHr = const Duration(minutes: 60);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_sec == 0) {
        } else {
          setState(() {
            _sec--;
          });
        }
      },
    );
  }




  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Focus Mode Enabled"),
      ),
      body: Center(
        child:SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children:[
                  AnimatedOpacity(
                    opacity: _visible ? 0.8 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      width: 125,
                      height: 18,
                      color: Colors.orangeAccent,
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: _visible ? 0.8 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      width: 200,
                      height: 100,
                      child: Text(
                        "Points:",
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                  children:[
                    AnimatedOpacity(
                      opacity: _visible ? 0.2 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      child: Container(
                        width: 200,
                        height: 100,
                        color: Colors.blueGrey,
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: _visible ? 0.8 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      child: Container(
                        width: 200,
                        height: 100,
                        child: Text(
                          "This is a quote",
                        ),
                      ),
                    ),
                  ]
              ),


              IconButton(
                iconSize: 100,
                onPressed: () {


                },
                icon: Icon(Icons.play_circle),
              ),
              ElevatedButton(
                onPressed: () {
                  startTimer();
                },
                child: Text("start"),
              ),
              Text("$_sec"),
              SizedBox(
                child: TextField(
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                  onChanged: (value){
                    setState(() {
                      _sec = int.parse(value);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: () {


          setState(() {
            _visible = !_visible;
          });
        },
        tooltip: 'Toggle Opacity',
        child: const Icon(Icons.flip),
      ),
    );
  }
}

