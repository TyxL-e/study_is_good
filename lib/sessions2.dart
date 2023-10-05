// import 'package:flutter/material.dart';
// import 'dart:async';
//
//
// class MyWidget extends StatefulWidget {
//   State createState() => new _MyWidgetState();
// }
//
// class _MyWidgetState extends State<MyWidget> {
//   Timer _timer;
//   int _start = 10;
//
//   void startTimer() {
//     if (_timer != null) {
//       _timer.cancel();
//       _timer = null;
//     } else {
//       _timer = new Timer.periodic(
//         const Duration(seconds: 1),
//             (Timer timer) => setState(
//               () {
//             if (_start < 1) {
//               timer.cancel();
//             } else {
//               _start = _start - 1;
//             }
//           },
//         ),
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }
//
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       appBar: AppBar(title: Text("Timer test")),
//       body: Column(
//         children: <Widget>[
//           RaisedButton(
//             onPressed: () {
//               startTimer();
//             },
//             child: Text("start"),
//           ),
//           Text("$_start")
//         ],
//       ),
//     );
//   }
// }
