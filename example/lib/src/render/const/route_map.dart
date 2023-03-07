// ignore_for_file: constant_identifier_names
import 'package:example/src/src.dart';

const String StoryPath = '/story/:id';

// functional path string
String storyPath(String id) => '/story/$id';

final RouteMap routeMap = RouteMap(
  routes: {
    Root: (RouteData info) => const MaterialPage(child: HomePage()),
    StoryPath: (RouteData info) =>
        MaterialPage(child: StoryPage(id: info.pathParameters['id']!)),
  },
  onUnknownRoute: (_) => const MaterialPage(child: NotFoundPage()),
);
