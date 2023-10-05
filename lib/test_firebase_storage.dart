// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
//
// class FireStorageService extends ChangeNotifier {
//   FireStorageService();
//   static Future<dynamic> loadImage(BuildContext context, String Image) async {
//     return await FirebaseStorage.instance.ref().child(Image).getDownloadURL();
//   }
// }
//
// Future<Widget> _getImage(BuildContext context, String imageName) async {
//   Image image = Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT1cHJ-VgGh9t686MqHvbO0ZQiREiEveXe-98z9aOI&s");
//   await FireStorageService.loadImage(context, imageName).then((value) {
//     image = Image.network(value.toString(), fit: BoxFit.scaleDown);
//   });
//   return image;
// }
//
// class YellowBird extends StatefulWidget {
//   const YellowBird({ super.key });
//
//   @override
//   State<YellowBird> createState() => _YellowBirdState();
// }
//
// class _YellowBirdState extends State<YellowBird> {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: _getImage(context, "Adventure Time.jpg"),
//         builder: (context, snapshot){
//           if(snapshot.connectionState == ConnectionState.done){
//             return Container(
//               width: MediaQuery.of(context).size.width / 1.2,
//               height: MediaQuery.of(context).size.width / 1.2,
//               child: snapshot.data,
//             );
//           }
//           if(snapshot.connectionState == ConnectionState.waiting){
//             return Container(
//               width: MediaQuery.of(context).size.width / 1.2,
//               height: MediaQuery.of(context).size.width / 1.2,
//               child: CircularProgressIndicator(),
//             );
//           }
//           return Container();
//         }
//     );
//   }
// }
//
