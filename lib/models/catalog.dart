import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CatalogModel {

  static List firestoreItems = [];

  Future getItemsFromFirestore() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("StudyIsGood")
        .doc("Achievements")
        .collection("YourBanners")
        .get();

    firestoreItems = [];
    for (var doc in snapshot.docs) {
      final data = doc.data();
      //final name = data['title'].toString(); // Assuming "name" field for item names
      firestoreItems.add(data);
    }
    return firestoreItems;
  }

  /// Get item by [id].
  ///
  /// In this sample, the catalog is infinite, looping over [itemNames].
  Item getById(int id) {
    if (id >= firestoreItems.length) {
      throw Exception('Invalid item ID');
    }
    //return firestoreItems[id];
    return Item(id, firestoreItems[id]['title'],firestoreItems[id]['pictureURL'],firestoreItems[id]['points']);
  }


  /// Get item by its position in the catalog.
  Item getByPosition(int position) {
    return getById(position);
  }
}


@immutable
class Item {
  final int id;
  final String name;
  final String pictureURL;
  final int price;

  Item(this.id, this.name, this.pictureURL, this.price);

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is Item && other.id == id;
}