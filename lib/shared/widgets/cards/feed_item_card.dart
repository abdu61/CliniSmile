import 'package:dental_clinic/models/feed.dart';
import 'package:flutter/material.dart';

class FeedItemWidget extends StatelessWidget {
  final FeedItem feedItem;

  FeedItemWidget({required this.feedItem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FeedItemDetails(feedItem: feedItem),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 3,
                offset: const Offset(2, 6), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10.0)),
                child: Image.network(feedItem.imageUrl),
              ),
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                title: Text(
                  feedItem.title,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                subtitle: feedItem.type == 'blog'
                    ? Text('${feedItem.content.substring(0, 50)}...')
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeedItemDetails extends StatelessWidget {
  final FeedItem feedItem;

  FeedItemDetails({required this.feedItem});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          feedItem.type == 'photo' ? feedItem.title : 'Blog',
          style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 220, 227, 255),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (feedItem.type == 'blog') BlogItem(feedItem: feedItem),
            if (feedItem.type == 'photo') PhotoItem(feedItem: feedItem),
          ],
        ),
      ),
    );
  }
}

class BlogItem extends StatelessWidget {
  final FeedItem feedItem;

  BlogItem({required this.feedItem});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            feedItem.title,
            style:
                textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                feedItem.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            feedItem.content,
            style: const TextStyle(
              fontSize: 16,
              letterSpacing: 0.8,
              height: 1.8,
            ),
          ),
        ),
      ],
    );
  }
}

class PhotoItem extends StatelessWidget {
  final FeedItem feedItem;

  PhotoItem({required this.feedItem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 0.0),
      child: Center(
        child: Image.network(feedItem.imageUrl, fit: BoxFit.contain),
      ),
    );
  }
}
