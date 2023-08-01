import 'package:flutter/material.dart';

class SessionPage extends StatefulWidget {
  const SessionPage({
    super.key,
  });


  @override
  State<SessionPage> createState() => _SessionPageState();
}

// The State class is responsible for two things: holding some data you can
// update and building the UI using that data.
class _SessionPageState extends State<SessionPage> {
  // Whether the green box should be visible
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Focus Mode Enabled"),
      ),
      body: Center(
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

          ],
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