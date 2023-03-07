import 'package:lib_x/lib_x.dart';

/// ValueListenableBuilder abstracted from context
class ReactiveBuilder<T> extends StatelessWidget {
  /// an instance of ValueController of any type
  final ValueController<T> controller;

  /// (value) => widget: a function with reactive value of ValueController that returns a widget
  final Function builder;

  const ReactiveBuilder({
    super.key,
    required this.controller,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller.listenable,
      builder: (_, value, __) => builder(value),
    );
  }
}
