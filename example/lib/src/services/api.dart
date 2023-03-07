import 'package:example/src/src.dart';

abstract class Api {
  static Future<List<NewsStory>> fetchStories() async {
    // load from db logic
    final List<NewsStory> results = [];
    // fake it till you make it
    final List<Map<String, dynamic>> snapshot = List.generate(
      10,
      (index) => {
        'id': XUtils.genId(),
        'title': 'Title: ${index + 1}',
        'content': 'Content of ${index + 1}',
      },
    );
    for (var value in snapshot) {
      results.add(NewsStory.fromMap(value));
    }
    return results;
  }
}
