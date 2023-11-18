import 'package:flutter/material.dart';
import 'package:study_is_good/firebase/db.dart';
import 'package:study_is_good/shared.dart';


class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {

  Map data = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() {
    getData().then((value) {
      setState(() {
        data = value;
        //print(data);
      });
    }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shop Page"),
        actions: [
          IconButton(
              onPressed: () {

              },
              icon: const Icon(Icons.add_shopping_cart))
        ],
      ),
        body: ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic> date = data.values.elementAt(index);
              //print(date["pictureURL"]);
              return GestureDetector(
                onTap: () {

                },
                child: CustomListItemTwo(
                    thumbnail: date["pictureURL"] ?? "https://firebasestorage.googleapis.com/v0/b/chat-app-91a9d.appspot.com/o/StudyIsGood%2FMoai%20Statue.jpg?alt=media&token=d3ea0a12-3060-4010-ae4f-fd63934fe0e5&_gl=1*yum4i*_ga*MTk4MDk5MTA5NC4xNjkxMTYzMzk1*_ga_CW55HF8NVT*MTY5NjAyOTIxMy4xNC4xLjE2OTYwMzM0MzguNDguMC4w",
                    title: date["title"] ?? "Love",
                    subtitle: date["subtitle"] ?? "Love",
                    author: date["title"] ?? "Love",
                    publishDate: date["level"] ?? "Hug",
                    readDuration: date["points"].toString(),
                ),
              );
            }
            )
    );
  }
}

