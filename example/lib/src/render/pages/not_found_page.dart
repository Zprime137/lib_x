import 'package:example/src/src.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScaffoldX(
      body: Center(child: Text('Page Not Found!')),
    );
  }
}
