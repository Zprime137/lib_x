import 'package:example/src/src.dart';

class StoryCard extends StatelessWidget {
  const StoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final NewsStory story = StoryProvider.of(context).story;
    return GestureDetector(
      onTap: () => X.to(path: storyPath(story.id)),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: darkC1,
          boxShadow: myShadow,
          borderRadius: semiRounded,
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(story.title),
            ReBuilder(
              controller: story,
              builder: () {
                final bool added = story.readLater;
                return TextButton(
                  onPressed: () => story.toggleReadLater(),
                  child: Text(
                      added ? 'Remove from read later' : 'Add to read later'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
