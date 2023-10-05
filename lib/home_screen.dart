import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_is_good/firebase/db.dart';
import 'package:study_is_good/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User user;
  String backgroundURL = "https://firebasestorage.googleapis.com/v0/b/chat-app-91a9d.appspot.com/o/StudyIsGood%2FDeep%20Sea%20Water.jpg?alt=media&token=62eabcd7-0b24-4d74-93ae-5c5d9dc9e8de";
  final db = FirebaseFirestore.instance;

  @override
  void initState() {
    user = auth.currentUser!;
    auth.userChanges().listen((event) {
      if (event != null && mounted) {
        setState(() {
          user = event;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Stack(
        children: [
            Container(
            decoration:  BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(backgroundURL),
                fit: BoxFit.fill,
                opacity: 0.250,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async{
                    final ref = db.collection("Players").doc(user.uid).withConverter(
                    fromFirestore: Player.fromFirestore,
                    toFirestore: (Player player, _) => player.toFirestore(),
                    );
                    final docSnap = await ref.get();
                    final player = docSnap.data();
                    ref.update({
                    "points":player!.points! - 50,
                    });
                    },
                  child: const Text("data"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
