import 'package:cloud_firestore/cloud_firestore.dart';


class Player {
  final String? uid;
  /*final String? email;
 final String? country;
 final bool? capital;*/
  final int? points;
  final List<String>? achievements;


  Player({
    this.uid,
/*   this.email,
   this.country,
   this.capital,*/
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
      /*    email: data?['state'],
     country: data?['country'],
     capital: data?['capital'],*/
      points: data?['points'],
      achievements:
      data?['achievements'] is Iterable ? List.from(data?['achievements']) : null,
    );
  }


  Map<String, dynamic> toFirestore() {
    return {
      if (uid != null) "uid": uid,
/*     if (email != null) "state": email,
     if (country != null) "country": country,
     if (capital != null) "capital": capital,*/
      if (points != null) "points": points,
      if (achievements != null) "achievements": achievements,
    };
  }
}
