import 'package:example/src/src.dart';

class StoryPage extends StatelessWidget {
  final String id;
  const StoryPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final NewsStory story = NewsList.instance.getById(id);

    return StoryProvider(
      story: story,
      child: ScaffoldX(
        appBar: const StoryPageAppBar(),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: darkC1,
              boxShadow: myShadow,
              borderRadius: semiRounded,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('id: $id'),

                /// notice we're not passing any data, because we have a provider
                const StoryTitle(),
                const StoryContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StoryTitle extends StatelessWidget {
  const StoryTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final NewsStory story = StoryProvider.of(context).story;
    return Text(story.title);
  }
}

class StoryContent extends StatelessWidget {
  const StoryContent({super.key});

  @override
  Widget build(BuildContext context) {
    final NewsStory story = StoryProvider.of(context).story;
    return Text(story.content);
  }
}
