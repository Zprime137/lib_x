import 'package:example/src/src.dart';

class StoriesListView extends StatelessWidget {
  const StoriesListView({super.key});

  @override
  Widget build(BuildContext context) {
    final NewsList newsController = NewsList.instance;

    return ReBuilder(
      controller: newsController,
      builder: () {
        return ListView.separated(
          padding: const EdgeInsets.all(10),
          separatorBuilder: (_, i) => const SizedBox(height: 10),
          itemCount: newsController.newsList.length,
          itemBuilder: (context, index) {
            return StoryProvider(
              story: newsController.newsList[index],
              child: const StoryCard(),
            );
          },
        );
      },
    );
  }
}
