import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:study_is_good/audioplayers/common.dart';
import 'package:study_is_good/main.dart';
import 'package:study_is_good/models/allUserPoints.dart';
import 'package:study_is_good/models/sessions.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin, WidgetsBindingObserver {
  late User user;
  late final CollectionReference<Sessions> sessionsRef;
  late final CollectionReference<AllUserPoints> allUserPointsRef;



  @override
  void initState() {
    super.initState();
    user = auth.currentUser!;
    sessionsRef = FirebaseFirestore.instance
        .collection("StudyIsGood")
        .doc("Players")
        .collection("All Users")
        .doc(user.uid)
        .collection("All Sessions")
        .withConverter(
      fromFirestore: Sessions.fromFirestore,
      toFirestore: (Sessions session, options) => session.toFirestore(),
    );
    allUserPointsRef = FirebaseFirestore.instance
        .collection("StudyIsGood")
        .doc("Players")
        .collection("All User Points")
        .withConverter(
      fromFirestore: AllUserPoints.fromFirestore,
      toFirestore: (AllUserPoints allUserPoints, options) => allUserPoints.toFirestore(),
    );
  }

  @override
  void dispose() {
    ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    String backgroundURL = "https://firebasestorage.googleapis.com/v0/b/chat-app-91a9d.appspot.com/o/StudyIsGood%2FDeep%20Sea%20Water.jpg?alt=media&token=62eabcd7-0b24-4d74-93ae-5c5d9dc9e8de";
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
          Column(
            children: [
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                    child: SafeArea(
                      child: StreamBuilder(
                        stream: allUserPointsRef.orderBy("points",descending: true).snapshots(), //.orderBy("date",descending: true)
                        builder: (context,snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(snapshot.error.toString()),
                            );
                          }
                          if (!snapshot.hasData) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          final data = snapshot.requireData.docs.toList();
                          return ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context,index) {
                                return ListTile(
                                  title: Text(data[index].data().toString()),
                                  subtitle: Text(data[index].data().points.toString()),
                                );
                              }
                          );
                        },
                      ),
                    )
                ),
              ),
              Expanded(
                  flex: 5,
                  child: SafeArea(
                    child: StreamBuilder(
                      stream: sessionsRef.snapshots(), //.orderBy("date",descending: true)
                      builder: (context,snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        }
                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final data = snapshot.requireData.docs.toList();
                        return ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context,index) {
                              return ListTile(
                                title: Text(data[index].data().time ?? "default"),
                                subtitle: Text(data[index].data().points.toString()),
                              );
                            }
                        );
                      },
                    ),
                  )
              ),

            ],
          ),
        ],

      ),
    );
  }
}








