import 'package:cloud_firestore/cloud_firestore.dart';


class Player {
  final String? uid;
  final int? points;
  final List<String>? achievements;


  Player({
    this.uid,
    this.points,
    this.achievements,
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
    );
  }


  Map<String, dynamic> toFirestore() {
    return {
      if (uid != null) "uid": uid,
      if (points != null) "points": points,
      if (achievements != null) "achievements": achievements,
    };
  }
}
