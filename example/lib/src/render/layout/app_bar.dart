import 'package:example/src/src.dart';

class HomePageAppBar extends StatelessWidget {
  const HomePageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueController<int> indexController =
        ValueController<int>(NewsList.tabController.index);

    NewsList.tabController.addListener(() {
      indexController.update(NewsList.tabController.index);
    });

    return ReactiveBuilder(
      controller: indexController,
      builder: (index) {
        return ReactiveBuilder(
          controller: X.themeMode,
          builder: (themeMode) {
            return AppBar(
              backgroundColor: themeMode == ThemeMode.dark ? darkC1 : lightC1,
              bottom: TabBar(
                controller: NewsList.tabController,
                indicatorColor: primaryC,
                tabs: [
                  Tab(
                    icon: Icon(
                      Icons.menu_rounded,
                      color: index == 0 ? primaryC : black,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.schedule,
                      color: index == 1 ? primaryC : black,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class StoryPageAppBar extends StatelessWidget {
  const StoryPageAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ReactiveBuilder(
      controller: X.themeMode,
      builder: (themeMode) {
        return AppBar(
          backgroundColor: themeMode == ThemeMode.dark ? darkC1 : lightC1,
          leading: const BackButton(color: primaryC),
        );
      },
    );
  }
}
