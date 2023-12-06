import 'package:flutter/material.dart';
import 'package:study_is_good/study/sessions2.dart';

class DisclaimerPage extends StatelessWidget {
  const DisclaimerPage({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              const Text("Concentrate your minds in these sessions and receive amazing reward"),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>
                        const TestCountDownTimer(time: 5,points: 12,)));
                  },
                  child: const Text("30 mins"), //12 points
              ),
              const Divider(),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>
                  const TestCountDownTimer(time: 3600,points: 1440,)));
                },
                child: const Text("1 hour"),
              ),
              const Divider(),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>
                  const TestCountDownTimer(time: 14400,points: 5720,)));
                },
                child: const Text("3 hours"), //14400,5760
              ),
            ],
          ),

        ),
      ),

    );
  }
}