const String loremIpsum = '''
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
''';

class NewsArticle {
  final String title;
  final String description;
  final String? articleText;

  NewsArticle({
    required this.title,
    required this.description,
    this.articleText = loremIpsum,
  });
}

List<NewsArticle> getNewsStories() {
  return [
    NewsArticle(
      title: 'Flutter Widgets are Awesome',
      description: 'Learn how to build beautiful UIs with Flutter',
    ),
    NewsArticle(
      title: 'Home Screen Widgets',
      description: 'Add widgets to your home screen with Flutter',
    ),
    NewsArticle(
      title: 'State Management',
      description: 'Manage state efficiently in your Flutter apps',
    ),
  ];
}