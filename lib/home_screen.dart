import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_is_good/audioplayers/common.dart';
import 'package:study_is_good/main.dart';
import 'package:study_is_good/models/allUserPoints.dart';
import 'package:study_is_good/models/sessions.dart';
import 'package:study_is_good/otherProfile.dart';


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

  List dataBanner = [];
  String backgroundURLDefault = "https://firebasestorage.googleapis.com/v0/b/chat-app-91a9d.appspot.com/o/StudyIsGood%2FDeep%20Sea%20Water.jpg?alt=media&token=62eabcd7-0b24-4d74-93ae-5c5d9dc9e8de";

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
    //ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body:Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(backgroundURLDefault),
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
                            stream: allUserPointsRef.orderBy("points",descending: true).snapshots(),
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
                              final List userIds = [];
                              for (final doc in data) {
                                final documentId = doc.id;
                                userIds.add(documentId);
                              }
                              return FutureBuilder(
                                  future: getUsersInfo(userIds),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    if (snapshot.hasError) {
                                      return Center(
                                        child: Text(snapshot.error.toString()),
                                      );
                                    }
                                    final List<DocumentSnapshot> userIds = snapshot.data!;
                                    return ListView.builder(
                                        itemCount: data.length,
                                        itemBuilder: (context,index) {
                                          final userId = userIds[index].data() as Map<String, dynamic>;
                                          return GestureDetector(
                                            onTap: (){
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => OtherProfilePage(
                                                    userInfo: userId,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: ListTile(
                                              title: Text(userId["username"]),
                                              subtitle: Text(data[index].data().points.toString()),
                                            ),
                                          );
                                        }
                                    );
                                  }
                              );
                            },
                          ),
                        )
                    ),
                  ),
                  const Divider(
                    thickness: 10,
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
      floatingActionButton: FutureBuilder(
        future: FirebaseFirestore
          .instance
          .collection("StudyIsGood")
          .doc("Players")
          .collection("All Users")
          .doc(auth.currentUser!.uid)
          .get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.requireData.data()!["banner"] != null ) {
            // setState(() {
            //   dataBanner = [];
            // });
            dataBanner = snapshot.requireData.data()!["banner"];
          }
          return FloatingActionButton(
            child: const Icon(Icons.adjust),
              onPressed: (){
                showDialog(context: context, builder: (context) {
                      return FutureBuilder(
                        future: getBannerInfo(dataBanner),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Text(snapshot.error.toString()),
                            );
                          }
                          final List<DocumentSnapshot> bannerIds = snapshot.data!;
                          return AlertDialog(
                            title: const Text("Choose your banner!"),
                            content: SizedBox(
                              height: 200,
                              width: 200,
                                child: ListView.builder(
                            itemCount: bannerIds.length,
                                itemBuilder: (context,index) {
                          final bannerId = bannerIds[index].data() as Map<String, dynamic>;
                          return GestureDetector(
                            onTap: () async {
                              setState(() {
                                 backgroundURLDefault = bannerId["pictureURL"];
                                 Navigator.of(context).pop();
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                leading: Image.network(bannerId["pictureURL"]),
                                title: Text(bannerId["title"]),
                              ),
                            ),
                          );
                          }
                          )
                            )
                          );
                        }
                      );
                });
              }
          );
        }
      ),
    );

  }

  Future<List<DocumentSnapshot>> getBannerInfo(List bannerIds) async {
    final List<Future<DocumentSnapshot>> futures = bannerIds
        .map((bannerId) => FirebaseFirestore
        .instance
        .collection("StudyIsGood")
        .doc("Achievements")
        .collection("YourBanners")
        .doc(bannerId)
        .get())
        .toList();

    final List<DocumentSnapshot> bannerInfo = await Future.wait(futures);
    return bannerInfo;
  }


  Future<List<DocumentSnapshot>> getUsersInfo(List userIds) async {
    final List<Future<DocumentSnapshot>> futures = userIds
        .map((userId) => FirebaseFirestore
        .instance
        .collection("StudyIsGood")
        .doc("Players")
        .collection("All Users")
        .doc(userId)
        .get())
        .toList();

    final List<DocumentSnapshot> userInfo = await Future.wait(futures);
    return userInfo;
  }

}