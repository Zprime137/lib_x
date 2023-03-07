# Getting Started

In a real world application we need to structure our app to be maintainable, scalable, and to allow for collaboration between developers. And for that, we need a clear design pattern, and separation of concerns among other things.<br><br>

__lib_x__ was designed to help achieve these goals. So [here](https://www.figma.com/file/TgJAynEYw3LaEzLTfgkJBa/Flutter-App-OOD?node-id=0%3A1&t=swFcLDZlU9apdhCr-1) is a Figma template you can use as a starting point for your next project to help you analyze and structure your app.

Also [here](https://medium.com/@hazem.monir/dart-flutter-lib-x-object-oriented-design-ood-complete-example-a5ac7f0f8745) is a tutorial article on medium.com for a more comprehensive example demonstrating data CRUDing and State Managment using lib_x
___
<br>

Now let's create a simple application that loads news stories from some source, and see how it should be structured properly.

[Here's](https://youtube.com/shorts/EZq5HonfSfU?feature=share) a visual of the app on YouTube.

#### After ```flutter create example```
### __lib/__ <br>
let's keep it clean and make a new folder _src_ to be the container of the app and let's have a simple _main.dart_ like this: <br>
#### lib/main.dart
```dart
import 'package:example/src/src.dart';

void main() {
  runApp(const MyApp());
}
```
<br>

### __src/__: <br>
we'll create a _src.dart_ file and 3 folders.

- ```src.dart``` will serve as an index of the app's components.

#### lib/src/src.dart
```dart
export 'package:lib_x/lib_x.dart';

// Data
export 'data/news_list.dart';
export 'data/news_story.dart';
// Render
export 'render/const/material_app.dart';
export 'render/const/route_map.dart';
export 'render/const/theme_data.dart';
export 'render/my_app.dart';
export 'render/pages/home_page.dart';
export 'render/pages/not_found_page.dart';
export 'render/pages/story_page.dart';
// Services
export 'services/api.dart';

// and so on, all our declaration will be exported from here
```
<br>
  
- ## __services/__ <br>
Inside this directory, we'll handle the services the application need, e.g. if the app requires authentication, we'll create a file auth.dart that will contain our auth logic. If we're dealing with firestore db, we'll create _firestore.dart_ that deals with firestore. If dealing with firebase storage, there will be a _storage.dart_ file... etc <br>

The benefits of that: if you wanted at some point to migrate from firestore to another database service provider. All you'll need to do is making a new file for the new service that will replace firestore without touching any widgets or data models. Also it can be done by a completely different developer. they'll just see the ins and outs of the firestore service class and create the replacement to take the same inputs, and returns the expected output.<br>

#### lib/src/services/api.dart
```dart
import 'package:example/src/src.dart';

// here we're going to make use of the abstract class,
// because we don't want our api to be instantiated
// it's just an encapsulation to the behaviors we need in our app
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
```
Note: each service class should be an encapsulation for only one service. Don't make a class that does everything. So for example, don't make a class that deals with database and storage and auth, but rather a class for each service.
<br>

- ## __data/__<br>

Here will be the data concerns only. lib_x provides 2 useful types that will help with data management concerns.
  1. ```StatefulData```  will make the data model listenable by the views.
  2. ```DataProvider<T>``` will make the data accessible by context in the widget tree.

#### lib/src/data/news_story.dart
```dart
import 'package:example/src/src.dart';

// 1- create the data model
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

  // it's best practice to make all the converters [from || to] class in factory method inside the class
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

// 2- create the data model provider
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

// or you can do the provider like this
class StoryProvider extends DataProvider<NewsStory> {
  // Declare the desired data as data
  final NewsStory data;

  const StoryProvider({
    super.key,
    required super.data, // first argument: require & pass the data object to the super class
    required super.child, // second argument: require & pass child to the super class
  });

  // Declare a static method that returns the provider instance of(context)
  static StoryProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<StoryProvider>()!;
}

```
#### lib/src/data/news_list.dart
```dart
import 'package:example/src/src.dart';

// here instead of doing a provider class, 
// we're goona explore a useful technique "singleton class", 
// because we don't want NewsList to be instantiated more than once.
class NewsList extends StatefulData {
  // declare a private constructor
  NewsList._constructor();

  // assign it to a static final private variable
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

  NewsStory getById(String id) => newsList.singleWhere((story) => story.id == id);
}

```
<br>
Notes: <br>

- It's best to declare the provider of a type in the same file with its declaration. So, all the concerns of that type are in the same file. Single Source Of Truth files.
- If there's a lot of data types, it best to group related types in sub-directories.. and so on.
<br><br>

- ## __render/__
Here will be all the rendering concerns, separated from the data management, and services implementations. And again, we'll group and classify the views elements into sub-directories. So let's plan our steps to implement the views components.

### 1. First step: Define MyApp and its dependencies.
### __my_app.dart__ 
which will contain ```MaterialApp```, the entery point and first concern for rendering the app.<br>

#### lib/src/render/my_app.dart
```dart
import 'package:example/src/src.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // here we'll load the stories data when app starts building
    NewsList.instance.loadNewsStories();

    return MaterialX(
      materialApp: materialApp,
      routeMap: routeMap,
    );
  }
}
```
### __render/const/__ 
in this directory will have the constant definitions the app need. And for a minimal app, it'll be something like this:<br>

#### lib/src/render/const/theme_data.dart
```dart
// themes and color scheme of the app.

const Color lightC = Color.fromARGB(255, 230, 226, 247);
const Color lightC1 = Color.fromARGB(255, 241, 239, 253);
const Color darkC = Color.fromARGB(255, 39, 37, 54);
const Color darkC1 = Color.fromARGB(255, 47, 45, 69);
const Color primaryC = Color.fromARGB(255, 255, 0, 212);

final ThemeData myLightTheme = ThemeData.light().copyWith(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryColor: primaryC,
  scaffoldBackgroundColor: lightC,
  canvasColor: transparent,
);

final ThemeData myDarkTheme = ThemeData.dark().copyWith(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryColor: primaryC,
  scaffoldBackgroundColor: darkC,
  canvasColor: transparent,
);

// some default shadow
final List<BoxShadow> myShadow = [
  BoxShadow(
    color: black.withOpacity(0.15),
    spreadRadius: 5,
    blurRadius: 8,
    offset: const Offset(2, 2),
  ),
];

// some default BorderRadius
final BorderRadius semiRounded = borderRadius(15);
final BorderRadius rounded = borderRadius(200);
```

#### lib/src/render/const/route_map.dart
```dart
// routes consts & map
import 'package:example/src/src.dart';

// Root = '/'; // predefined in lib_x
// always define paths to avoid mistakes
const String StoryPath = '/story/:id'; // path pattern

// functional string path
String storyPath(String id) => '/story/$id';

final RouteMap routeMap = RouteMap(
  routes: {
    Root: (RouteData info) => const MaterialPage(child: HomePage()),  // ToDo: declare
    StoryPath: (RouteData info) =>
        MaterialPage(child: StoryPage(id: info.pathParameters['id']!)),  // ToDo: declare
  },
  onUnknownRoute: (_) => const MaterialPage(child: NotFoundPage()),
);
```

#### lib/src/render/const/material_app.dart
```dart
import 'package:example/src/src.dart';

final MaterialApp materialApp = MaterialApp(
  title: 'Example App',
  debugShowCheckedModeBanner: false,
  theme: myLightTheme,
  darkTheme: myDarkTheme,
);
```

### 2. Second step: Defining the pages we promised in the route_map.

#### lib/src/render/pages/home_page.dart
```dart
import 'package:example/src/src.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    // we need to asign the tabController in order to use it
    NewsList.tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldX(
      appBar: const HomeAppBar(), // ToDo: declare
      body: TabBarView(
        controller: NewsList.tabController,
        children: const [
          StoriesListView(), // ToDo: declare
          ReadLaterListView(), // ToDo: declare
        ],
      ),
    );
  }
}
```

#### lib/src/render/layout/app_bar.dart - add to _src.dart_
```dart
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
```
#### lib/src/render/lists/stories_list.dart - add to _src.dart_
```dart
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
```

#### lib/src/render/lists/read_later_list.dart - add to _src.dart_
```dart
import 'package:example/src/src.dart';

class ReadLaterListView extends StatelessWidget {
  const ReadLaterListView({super.key});

  @override
  Widget build(BuildContext context) {
    final NewsList newsController = NewsList.instance;

    return ReBuilder(
      controller: newsController,
      builder: () {
        return ListView.separated(
          padding: const EdgeInsets.all(10),
          separatorBuilder: (_, i) => const SizedBox(height: 10),
          itemCount: newsController.readLaterList.length,
          itemBuilder: (context, index) {
            return StoryProvider(
              story: newsController.readLaterList[index],
              child: const StoryCard(),
            );
          },
        );
      },
    );
  }
}
```

#### lib/src/render/cards/story_card.dart - add to _src.dart_
```dart
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
```
#### lib/src/render/pages/story_page.dart
```dart
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
```
I just realized I passed the 500 line, which is ironic cause no one will read this.
### P.S.
- Structure does matter.
- Try as possible to make your files describable as A Single Source Of Truth.
- Naming should be semantic and self-explanatory, even if you're working solo. It'll save you a lot of time when you want to debug or update something later.

## #HappyCoding