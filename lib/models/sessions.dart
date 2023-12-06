import 'package:cloud_firestore/cloud_firestore.dart';

class Sessions {
  final int? points;
  final String? time;

  Sessions({
    this.points,
    this.time,
  });

  factory Sessions.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Sessions(
      points: data?['points'] ?? 0,
      time: data?['time'] ?? "default",
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (time != null) "time": time,
      if (points != null) "points": points,
    };
  }
}