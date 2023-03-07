import 'package:example/src/src.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    NewsList.instance.loadNewsStories();

    return MaterialX(
      materialApp: materialApp,
      routeMap: routeMap,
    );
  }
}
