import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:study_is_good/authentication/auth.dart';
import 'package:study_is_good/firebase/db.dart';
import 'package:study_is_good/firebase/db2.dart';
import 'package:study_is_good/main.dart';
import 'package:study_is_good/session_screen.dart';
import 'package:study_is_good/test_everything_screen.dart';


/// Displayed as a profile image if the user doesn't have one.
const placeholderImage =
    'https://upload.wikimedia.org/wikipedia/commons/c/cd/Portrait_Placeholder_Square.png';

/// Profile page shows after sign in or registerationg
class ProfilePage extends StatefulWidget {
  // ignore: public_member_api_docs
  const ProfilePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User user;
  late TextEditingController controller;
  final phoneController = TextEditingController();
  final db = FirebaseFirestore.instance;
  String love = "";
  final modelsRef =
  FirebaseFirestore.instance.collection('StudyIsGood').doc("Novice Learner Level 1").withConverter<Achieve>(
    fromFirestore: Achieve.fromFirestore,
    toFirestore: (Achieve achieve, options) => achieve.toFirestore(),
  );
  String image1 = "";

  String? photoURL;

  bool showSaveButton = false;
  bool isLoading = false;

  @override
  void initState() {
    user = auth.currentUser!;
    controller = TextEditingController(text: user.displayName);
    controller.addListener(_onNameChanged);
    //getMedals();
    auth.userChanges().listen((event) {
      if (event != null && mounted) {
        setState(() {
          user = event;
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(_onNameChanged);
    super.dispose();
  }

  void setIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  void _onNameChanged() {
    setState(() {
      if (controller.text == user.displayName || controller.text.isEmpty) {
        showSaveButton = false;
      } else {
        showSaveButton = true;
      }
    });
  }

  // Future getMedals() async {
  //   image1 = await FirebaseStorage.instance.ref().child("/StudyIsGood").child().getDownloadURL();
  //   print(image1);
  // }

  /// Map User provider data into a list of Provider Ids.
  List get userProviders => user.providerData.map((e) => e.providerId).toList();

  Future updateDisplayName() async {
    await user.updateDisplayName(controller.text);

    setState(() {
      showSaveButton = false;
    });

    // ignore: use_build_context_synchronously
    ScaffoldSnackbar.of(context).show('Name updated');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
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
                              user.photoURL ?? placeholderImage,
                            ),
                          ),
                          Positioned.directional(
                            textDirection: Directionality.of(context),
                            end: 0,
                            bottom: 0,
                            child: Material(
                              clipBehavior: Clip.antiAlias,
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(40),
                              child: InkWell(
                                onTap: () async {
                                  final photoURL = await getPhotoURLFromUser();

                                  if (photoURL != null) {
                                    await user.updatePhotoURL(photoURL);
                                  }
                                },
                                radius: 50,
                                child: const SizedBox(
                                  width: 35,
                                  height: 35,
                                  child: Icon(Icons.edit),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        textAlign: TextAlign.center,
                        controller: controller,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          alignLabelWithHint: true,
                          label: Center(
                            child: Text(
                              'Click to add a display name',
                            ),
                          ),
                        ),
                      ),
                      Text(user.email ?? user.phoneNumber ?? 'User'),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (userProviders.contains('phone'))
                            const Icon(Icons.phone),
                          if (userProviders.contains('password'))
                            const Icon(Icons.mail),
                          if (userProviders.contains('google.com'))
                            SizedBox(
                              width: 24,
                              child: Image.network(
                                'https://upload.wikimedia.org/wikipedia/commons/0/09/IOS_Google_icon.png',
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                              height: 50,
                              width: 70,
                              child: Image(
                                  image: NetworkImage("https://firebasestorage.googleapis.com/v0/b/chat-app-91a9d.appspot.com/o/StudyIsGood%2FBronze_learner_1.jpg?alt=media&token=ead75805-ba7b-4e62-b64d-d31afdf00c22"),
                              )
                          ),
                          SizedBox(
                              height: 50,
                              width: 70,
                              child: Image(
                                image: NetworkImage("https://firebasestorage.googleapis.com/v0/b/chat-app-91a9d.appspot.com/o/StudyIsGood%2FBronze_learner_1.jpg?alt=media&token=ead75805-ba7b-4e62-b64d-d31afdf00c22"),
                              )
                          ),
                          SizedBox(
                              height: 50,
                              width: 70,
                              child: Image(
                                image: NetworkImage("https://firebasestorage.googleapis.com/v0/b/chat-app-91a9d.appspot.com/o/StudyIsGood%2FBronze_learner_1.jpg?alt=media&token=ead75805-ba7b-4e62-b64d-d31afdf00c22"),
                              )
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      TextButton(
                        onPressed: _signOut,
                        child: const Text('Sign out'),
                      ),
                      const Divider(),
                      ElevatedButton(
                        onPressed: () async{
                          final player = Player(
                            uid: user.uid,
                            points: 100,
                            achievements: ["Bronze_learner_1", "novice_learner_level_1", "novice_learner_level_1"],
                          );
                          final docRef = db
                              .collection("StudyIsGood")
                              .doc("Players")
                              .collection("All Users")
                              .withConverter(
                            fromFirestore: Player.fromFirestore,
                            toFirestore: (Player player, options) => player.toFirestore(),
                          ).doc(user.uid);
                          await docRef.set(player);
                        },
                        child: const Text("Database"),
                      ),
                      ElevatedButton(
                        onPressed:  () async{
                          final ref = db.collection("StudyIsGood").doc("Players").collection("All Users").doc(user.uid).withConverter(
                            fromFirestore: Player.fromFirestore,
                            toFirestore: (Player player, _) => player.toFirestore(),
                          );
                          final docSnap = await ref.get();
                          final player = docSnap.data(); // Convert to City object
                          if (player != null) {
                            print(player.achievements);
                          } else {
                            print("No such document.");
                          }
                        },
                        child: const Text('read database'),
                      ),
                      const Divider(),
                      ElevatedButton(
                        onPressed: () async{
                          final achieve = Achieve(
                            name: "Novice Learner Level 1",
                            pNeeded: 0,
                            image: "https://firebasestorage.googleapis.com/v0/b/chat-app-91a9d.appspot.com/o/Novice Learner Level 1.jpg"
                          );
                          final ref = db
                              .collection("StudyIsGood")
                              .withConverter(
                            fromFirestore: Achieve.fromFirestore,
                            toFirestore: (Achieve achieve, options) => achieve.toFirestore(),
                          ).doc("Novice Learner Level 1");
                          await ref.set(achieve);
                        },
                        child: const Text("Update Trophy"),
                      ),
                      const Divider(),
                      ElevatedButton(
                        onPressed:  () async{
                          final docSnap = await modelsRef.get();
                          final player = docSnap.data(); // Convert to City object
                          if (player != null) {
                            print(player.pNeeded);
                          } else {
                            print("No such document.");
                          }
                        },
                        child: const Text('read achievements'),
                      ),
                      TextButton(
                        onPressed: _deleteUser,
                        child: const Text('Delete User'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.directional(
              textDirection: Directionality.of(context),
              end: 40,
              top: 40,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: !showSaveButton
                    ? SizedBox(key: UniqueKey())
                    : TextButton(
                  onPressed: isLoading ? null : updateDisplayName,
                  child: const Text('Save changes'),
                ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  const TestAudioPlaylist()),
              );
            },
            label: const Text("Study Challenges!"),
        ),
      ),
    );
  }

  Future<String?> getPhotoURLFromUser() async {
    String? photoURL;

    // Update the UI - wait for the user to enter the SMS code
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('New image Url:'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
            OutlinedButton(
              onPressed: () {
                photoURL = null;
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
          content: Container(
            padding: const EdgeInsets.all(20),
            child: TextField(
              onChanged: (value) {
                photoURL = value;
              },
              textAlign: TextAlign.center,
              autofocus: true,
            ),
          ),
        );
      },
    );

    return photoURL;
  }

  /// Example code for sign out.
  Future<void> _signOut() async {
    await auth.signOut();
    await GoogleSignIn().signOut();
  }

  /// Example code for sign out.
  Future<void> _deleteUser() async {
    await auth.currentUser?.delete();
    await GoogleSignIn().disconnect();
  }
}