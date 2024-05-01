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

class _FeedState extends State<Feed> with SingleTickerProviderStateMixin {
  late Future<List<FeedItem>> futureFeedItems;
  late TabController _tabController;

  String category = 'All';

  @override
  void initState() {
    super.initState();
    futureFeedItems = fetchFeedItems(category);
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    updateCategory(_tabController.index == 0
        ? 'All'
        : _tabController.index == 1
            ? 'offer'
            : 'general');
  }

  void updateCategory(String newCategory) {
    setState(() {
      category = newCategory;
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
        toolbarHeight: 35,
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
        bottom: TabBar(
          controller: _tabController,
          indicator: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  color: Color.fromARGB(255, 126, 156, 252), width: 3.0),
            ),
          ),
          tabs: const [
            Tab(child: SizedBox(width: 80, child: Center(child: Text('All')))),
            Tab(
                child:
                    SizedBox(width: 80, child: Center(child: Text('Offers')))),
            Tab(
                child:
                    SizedBox(width: 80, child: Center(child: Text('General')))),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 10.0),
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
                    return FeedItemWidget(feedItem: snapshot.data![index]);
                  },
                );
              }
            } else if (snapshot.hasError) {
              // Error occurred
              return const Center(
                  child: Text('An error occurred. Please try again later.'));
            }

            // By default, show a loading
            return const Loading();
          },
        ),
      ),
    );
  }
}
