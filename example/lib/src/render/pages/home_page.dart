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
    NewsList.tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldX(
      appBar: const HomePageAppBar(), // ToDo: declare
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
