import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    this.color = const Color(0xFF2DBD3A),
    this.child,
  });

  final Color color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Text(
            'Hello my name is Tyler and I am currently making a app',
          ),
          Text(
            'This is a picture of Shrek and ketchup, enjoy',
          ),
          Image.network('https://pbs.twimg.com/media/DrjT156XQAAF9uk.jpg'),
          Image.network('https://todaysparent.mblycdn.com/uploads/tp/2019/09/sorry-heinz-your-new-veggie-ketchup-is-just-slick-marketing-1280x960.jpg'),
        ]
    );
  }}