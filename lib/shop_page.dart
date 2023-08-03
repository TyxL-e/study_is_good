import 'package:flutter/material.dart';

class _ArticleDescription extends StatelessWidget {
  const _ArticleDescription({
    required this.title,
    required this.subtitle,
    required this.author,
    required this.publishDate,
    required this.readDuration,
  });
  final String title;

  final String subtitle;
  final String author;
  final String publishDate;
  final String readDuration;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 2.0)),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                author,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black87,
                ),
              ),
              Text(
                '$publishDate - $readDuration',
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomListItemTwo extends StatelessWidget {
  const CustomListItemTwo({
    super.key,
    required this.thumbnail,
    required this.title,
    required this.subtitle,
    required this.author,
    required this.publishDate,
    required this.readDuration,
  });

  final Widget thumbnail;
  final String title;
  final String subtitle;
  final String author;
  final String publishDate;
  final String readDuration;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.0,
              child: thumbnail,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                child: _ArticleDescription(
                  title: title,
                  subtitle: subtitle,
                  author: author,
                  publishDate: publishDate,
                  readDuration: readDuration,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: <Widget>[
          CustomListItemTwo(
            thumbnail: Image.network("https://preview.redd.it/wallpaper-edit-i-made-that-some-of-you-might-like-v0-qpgq2eua4fva1.png?width=640&crop=smart&auto=webp&s=179228d4b58056adc1ae9c0662c968bebb57582c"),
            title: 'Oshi No Ko banner',
            subtitle: 'Flutter continues to improve and expand its horizons. '
                'This text should max out at two lines and clip',
            author: 'Unknown',
            publishDate: 'Dec 28',
            readDuration: '5 mins',
          ),
          CustomListItemTwo(
            thumbnail: Image.network("https://i.pinimg.com/736x/b9/25/8b/b9258b10d1ab4ccbfbec08e3612b3e03.jpg"),
            title: 'Minecraft cave',
            subtitle: 'Flutter once again improves and makes updates.',
            author: 'Flutter',
            publishDate: 'Feb 26',
            readDuration: '12 mins',
          ),
          CustomListItemTwo(
            thumbnail: Image.network("https://i.pinimg.com/originals/8b/2d/d6/8b2dd6a677a63bb34d2d5e21857116ce.jpg"),
            title: 'm',
            subtitle: 'Flutter once again improves and makes updates.',
            author: 'Flutter',
            publishDate: 'Feb 26',
            readDuration: '12 mins',
          ),
          CustomListItemTwo(
            thumbnail: Image.network("https://w0.peakpx.com/wallpaper/380/205/HD-wallpaper-deep-sea-water.jpg"),
            title: 'Flutter 1.2 Release - Continual updates to the framework',
            subtitle: 'Flutter once again improves and makes updates.',
            author: 'Flutter',
            publishDate: 'Feb 26',
            readDuration: '12 mins',
          ),
          CustomListItemTwo(
            thumbnail: Image.network("https://img.freepik.com/premium-photo/gradient-phone-wallpaper-oil-bubble-water-background_780593-11594.jpg"),
            title: 'Flutter 1.2 Release - Continual updates to the framework',
            subtitle: 'Flutter once again improves and makes updates.',
            author: 'Flutter',
            publishDate: 'Feb 26',
            readDuration: '12 mins',
          ),
        ],
      ),
    );
  }
}
