class FeedItem {
  final String imageUrl;
  final String title;
  final String content;
  final String type; // 'photo' or 'blog'
  final String category; // 'offer' or 'general'

  FeedItem({
    required this.imageUrl,
    required this.title,
    required this.content,
    required this.type,
    required this.category,
  });
}
