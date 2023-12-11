import 'package:flutter/material.dart';


/// Displayed as a profile image if the user doesn't have one.
const placeholderImage =
    'https://upload.wikimedia.org/wikipedia/commons/c/cd/Portrait_Placeholder_Square.png';

/// Profile page shows after sign in or registerationg
class OtherProfilePage extends StatefulWidget {
  // ignore: public_member_api_docs
  final Map<String, dynamic> userInfo;
  OtherProfilePage({Key? key, required this.userInfo}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _OtherProfilePageState createState() => _OtherProfilePageState();
}

class _OtherProfilePageState extends State<OtherProfilePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: 400,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          maxRadius: 60,
                          backgroundImage: NetworkImage(
                            widget.userInfo["picURL"] ?? placeholderImage,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(widget.userInfo["username"]),
                    const SizedBox(height: 10),
                    const SizedBox(height: 20),
                    // StreamBuilder<Object>(
                    //     stream: null,
                    //     builder: (context, snapshot) {
                    //       return Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //         children: [
                    //           SizedBox(
                    //               height: 50,
                    //               width: 70,
                    //               child: Image(
                    //                 image: NetworkImage("https://firebasestorage.googleapis.com/v0/b/chat-app-91a9d.appspot.com/o/StudyIsGood%2FBronze_learner_1.jpg?alt=media&token=ead75805-ba7b-4e62-b64d-d31afdf00c22"),
                    //               )
                    //           ),
                    //           SizedBox(
                    //               height: 50,
                    //               width: 70,
                    //               child: Image(
                    //                 image: NetworkImage("https://firebasestorage.googleapis.com/v0/b/chat-app-91a9d.appspot.com/o/StudyIsGood%2FBronze_learner_1.jpg?alt=media&token=ead75805-ba7b-4e62-b64d-d31afdf00c22"),
                    //               )
                    //           ),
                    //           SizedBox(
                    //               height: 50,
                    //               width: 70,
                    //               child: Image(
                    //                 image: NetworkImage("https://firebasestorage.googleapis.com/v0/b/chat-app-91a9d.appspot.com/o/StudyIsGood%2FBronze_learner_1.jpg?alt=media&token=ead75805-ba7b-4e62-b64d-d31afdf00c22"),
                    //               )
                    //           )
                    //         ],
                    //       );
                    //     }
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}