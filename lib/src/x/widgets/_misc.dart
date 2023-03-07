import 'package:lib_x/lib_x.dart';

/// constrained widget
class Constrained extends StatelessWidget {
  final BoxConstraints constraints;
  final Alignment? alignment;
  final Widget child;
  const Constrained({
    Key? key,
    required this.constraints,

    /// the BoxConstraints
    required this.child,

    /// child to be constrained
    this.alignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment ?? Alignment.center,
      child: ConstrainedBox(
        constraints: constraints,
        child: child,
      ),
    );
  }
}

/// semantic padding widget but for the sake of OCD
class Margin extends StatelessWidget {
  /// default margin is 10 all directions
  final EdgeInsets margin;

  /// a required child widget
  final Widget child;

  const Margin({
    super.key,
    this.margin = const EdgeInsets.all(10),
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: child,
    );
  }
}

/// line widget to use as a separator
class LineWidget extends StatelessWidget {
  /// default line height is 0
  final double? height;

  /// default thikness is 1
  final double? thikness;

  /// default line color is black transparent 20%
  final Color? color;

  /// Default margin is all 10
  final EdgeInsets margin;

  const LineWidget({
    super.key,
    this.height,
    this.thikness,
    this.color,
    this.margin = const EdgeInsets.all(10),
  });

  @override
  Widget build(BuildContext context) {
    return Margin(
      margin: margin,
      child: Divider(
        height: height ?? 0,
        thickness: thikness ?? 1,
        color: color ?? black.withOpacity(.2),
      ),
    );
  }
}
