import 'package:dental_clinic/models/feed.dart';
import 'package:dental_clinic/services/database.dart';
import 'package:dental_clinic/shared/loading.dart';
import 'package:dental_clinic/shared/widgets/cards/feed_item_card.dart';
import 'package:flutter/material.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  late Future<List<FeedItem>> futureFeedItems;

  String category = 'All';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    futureFeedItems = fetchFeedItems(category);
  }

  void updateCategory(String newCategory, int index) {
    setState(() {
      category = newCategory;
      _selectedIndex = index;
      futureFeedItems = fetchFeedItems(category);
    });
  }

  Future<List<FeedItem>> fetchFeedItems(String category) async {
    if (category == 'All') {
      // Fetch all feed items
      return DatabaseService(uid: '').getFeedItems();
    } else {
      // Fetch feed items by category
      return DatabaseService(uid: '').getFeedItemsByCategory(category);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const DefaultTextStyle(
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
          child: Text('Feed'),
        ),
        backgroundColor: const Color.fromARGB(255, 220, 227, 255),
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ToggleButtons(
                  borderRadius: BorderRadius.circular(8.0),
                  selectedColor: Colors.white,
                  color: Colors.black,
                  fillColor: const Color.fromARGB(255, 126, 156, 252),
                  selectedBorderColor: const Color.fromARGB(255, 126, 156, 252),
                  onPressed: (int index) {
                    updateCategory(
                      index == 0
                          ? 'All'
                          : index == 1
                              ? 'offer'
                              : 'general',
                      index,
                    );
                  },
                  isSelected:
                      List.generate(3, (index) => index == _selectedIndex),
                  children: const <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 38.0),
                      child: Text(
                        'All',
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 38.0),
                      child: Text(
                        'Offers',
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 38.0),
                      child: Text(
                        'General',
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: FutureBuilder<List<FeedItem>>(
                future: futureFeedItems,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      // No feed items
                      return const Center(child: Text('No feed items found.'));
                    } else {
                      // Display feed items
                      return ListView.separated(
                        itemCount: snapshot.data!.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          return FeedItemWidget(
                              feedItem: snapshot.data![index]);
                        },
                      );
                    }
                  } else if (snapshot.hasError) {
                    // Error occurred
                    return const Center(
                        child:
                            Text('An error occurred. Please try again later.'));
                  }

                  // By default, show a loading
                  return const Loading();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
