import 'package:cloud_firestore/cloud_firestore.dart';


class Player {
  final String? uid;
  final int? points;
  final List<String>? achievements;
  final String? username;
  final String? picURL;


  Player({
    this.uid,
    this.points,
    this.achievements,
    this.username,
    this.picURL
  });


  factory Player.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Player(
      uid: data?['uid'],
      points: data?['points'],
      achievements:
      data?['achievements'] is Iterable ? List.from(data?['achievements']) : null,
      username: data?['username'],
      picURL: data?['picURL'],
    );
  }


  Map<String, dynamic> toFirestore() {
    return {
      if (uid != null) "uid": uid,
      if (points != null) "points": points,
      if (achievements != null) "achievements": achievements,
      if (username != null) "username": username,
      if (picURL != null) "picURL": picURL,
    };
  }
}

String collection = 'News';

Future<Map> getData() async {
  var data = {};
  await FirebaseFirestore.instance
      .collection("StudyIsGood")
      .doc("Achievements")
      .collection("YourBanners")
      .get()
      .then((querySnapshot) {
    for (var docSnapshot in querySnapshot.docs) {
      // print('${docSnapshot.id} => ${docSnapshot.data()}');
      if (docSnapshot.id != 'users') data[docSnapshot.id] = docSnapshot.data();
    }
  });
  return data;
}


