import 'package:example/src/src.dart';

class NewsList extends StatefulData {
  NewsList._constructor();

  static final NewsList _this = NewsList._constructor();

  // create a public getter that returns the same final object everytime
  static NewsList get instance => _this;

  final List<NewsStory> newsList = [];
  final List<NewsStory> readLaterList = [];

  static late TabController tabController;

  void loadNewsStories() async {
    final List<NewsStory> stories = await Api.fetchStories();
    newsList.addAll(stories);
    update();
  }

  void updateReadLater() async {
    readLaterList.clear();
    final List<NewsStory> stories = await Future.value(
      newsList.where((story) => story.readLater).toList(),
    );
    readLaterList.addAll(stories);
    update();
  }

  NewsStory getById(String id) =>
      newsList.singleWhere((story) => story.id == id);
}
