import 'package:cloud_firestore/cloud_firestore.dart';

class AllUserPoints {
  final int? points;

  AllUserPoints({
    this.points,
  });

  factory AllUserPoints.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return AllUserPoints(
      points: data?['points'] ?? 0,);
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (points != null) "points": points,
    };
  }
}