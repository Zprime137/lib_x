import 'package:example/src/src.dart';

class StoryProvider extends DataProvider<NewsStory> {
  // Declare the desired data you want the provider to provide
  final NewsStory story;

  const StoryProvider({
    super.key,
    required this.story, // first argument: require the declared data object
    required super.child, // second argument: require & pass child to the super class
  }) : super(data: story); // pass the data to the super class

  // Declare a static method that returns the provider instance of(context)
  static StoryProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<StoryProvider>()!;
}

class NewsStory extends StatefulData {
  final String id;
  final String title;
  final String content;
  bool readLater;

  NewsStory({
    required this.id,
    required this.title,
    required this.content,
    this.readLater = false,
  });

  factory NewsStory.fromMap(Map<String, dynamic> map) {
    return NewsStory(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      readLater: map['readLater'] ?? false,
    );
  }

  void toggleReadLater() {
    readLater = !readLater;
    NewsList.instance.updateReadLater();
    update();
  }
}
