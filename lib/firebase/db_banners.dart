import 'package:cloud_firestore/cloud_firestore.dart';

class Banner {
  final String? level;
  final String? pictureURL;
  final String? subtitle;
  final int? points;
  final String? title;


  Banner({
    this.level,
    this.pictureURL,
    this.points,
    this.title,
    this.subtitle
  });


  factory Banner.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Banner(
      level: data?['level'] ?? "Novice Learner Level 1",
      pictureURL: data?['pictureURL'] ?? "https://firebasestorage.googleapis.com/v0/b/chat-app-91a9d.appspot.com/o/StudyIsGood%2FAdventure%20Time.jpg?alt=media&token=54746f33-560a-4e80-885d-311cf129a12b&_gl=1*jjjjlq*_ga*MTk4MDk5MTA5NC4xNjkxMTYzMzk1*_ga_CW55HF8NVT*MTY5NjAyOTIxMy4xNC4xLjE2OTYwMzMwODEuNTUuMC4w",
      points: data?['points'] ?? 0,
      title: data?['image'] ?? "Adventure Time",
      subtitle: data?['image'] ?? "Super Adventure Background"
    );
  }


  Map<String, dynamic> toFirestore() {
    return {
      if (level != null) "achievements": level,
      if (pictureURL != null) "pictureURL": pictureURL,
      if (points != null) "points": points,
      if (title != null) "title": title,
      if (subtitle != null) "subtitle": subtitle,
    };
  }
}




