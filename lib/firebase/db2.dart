import 'package:cloud_firestore/cloud_firestore.dart';

class Achieve {
  final String? name;
  final int? pNeeded;
  final String? image;


  Achieve({
    this.name,
    this.pNeeded,
    this.image,
  });


  factory Achieve.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Achieve(
      name: data?['achievement'],
      pNeeded: data?['points'],
      image: data?['image'],
    );
  }


  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "achievements": name,
      if (pNeeded != null) "points": pNeeded,
      if (image != null) "image": image,
    };
  }
}




