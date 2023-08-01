import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    this.color = const Color(0xFF2DBD3A),
    this.child,
  });

  final Color color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          children: [
            Text(
              'This is the profile page',
            ),
            Text(
              'I am Tyler and trying to create an app',
            ),
            Text(
              'Thank you for using this app to help your study',
            ),
            Image.network("https://as1.ftcdn.net/v2/jpg/00/49/22/40/1000_F_49224094_FJ1XuQg4ctxoPeaS5VpiUUzwNnI3xJH3.jpg")
        ],
      ),
    );
  }}