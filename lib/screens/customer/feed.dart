import 'package:dental_clinic/navigation/customer_nav.dart';
import 'package:dental_clinic/shared/loading.dart';
import 'package:dental_clinic/shared/widgets/cards/feed_item_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final CustomerNavigationController controller =
      Get.find<CustomerNavigationController>();
  int _categorySelectedIndex = 0; // Local state for category selection

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
                    setState(() {
                      _categorySelectedIndex = index;
                    });
                    String category = index == 0
                        ? 'All'
                        : index == 1
                            ? 'offer'
                            : 'general';
                    controller.preloadFeedData(category);
                  },
                  isSelected: List.generate(
                      3, (index) => index == _categorySelectedIndex),
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
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Loading();
                }
                if (controller.feedItems.isEmpty) {
                  return const Center(child: Text('No feed items found.'));
                }
                return ListView.separated(
                  itemCount: controller.feedItems.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    return FeedItemWidget(
                        feedItem: controller.feedItems[index]);
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
