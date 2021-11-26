class News {
  String title;
  String imageUrl;
  String publishTime;
  String author;
  String newsUrl;

  News({
    this.author = '',
    this.imageUrl = '',
    this.publishTime = '',
    this.title = '',
    this.newsUrl = '',
  });

  String get getConvertTime {
    final dateTime = DateTime.parse(publishTime);
    final difference = DateTime.now().difference(dateTime);
    if (difference.inHours == 0) {
      if (difference.inMinutes == 0) {
        return 'now';
      } else {
        return '${difference.inMinutes}m';
      }
    }
    if (difference.inHours > 24) {
      return '${difference.inDays}d';
    }
    return '${difference.inHours}h';
  }
}

List<News> convertNews(Map data) {
  final List<News> results = [];
  data['results'].forEach((news) {
    results.add(
      News(
        author: news['author'],
        imageUrl: news['image_url'],
        title: news['title'],
        publishTime: news['published_utc'],
        newsUrl: news['article_url'],
      ),
    );
  });
  return results;
}
