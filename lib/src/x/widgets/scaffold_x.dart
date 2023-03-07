import 'package:lib_x/lib_x.dart';

/// for a quick scaffolding
class ScaffoldX extends StatefulWidget {
  /// required: scaffold body
  final Widget body;

  /// optional: appBar
  final Widget? appBar;

  /// appBar height default height is 60
  final double? appBarHeight;

  /// optional: drawer
  final Widget? drawer;

  /// optional: NavigationBar
  final Widget? bottomNavigationBar;

  /// optional: BottomSheet
  final Widget? bottomSheet;

  /// optional: FloatingActionButton
  final Widget? fab;

  /// optional: fab location
  final FloatingActionButtonLocation? fabLocation;

  /// optional: scaffold constrains
  final BoxConstraints? constraints;

  /// optional: backgroundColor
  final Color? bgColor;

  ///optional: bg decoration
  final DecorationImage? bgDecorationImage;

  /// default textStyle: TextStyle(color: black, fontSize: 16),
  final TextStyle textStyle;

  /// safearea is true by default
  final bool safeArea;

  /// optional: if true, the body will be wrapped by SingleChildScrollView
  final bool scrollView;

  ///optional: on init function
  final VoidCallback? onInit;

  const ScaffoldX({
    Key? key,
    required this.body,
    this.appBar,
    this.drawer,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.fab,
    this.fabLocation,
    this.bgColor,
    this.constraints,
    this.textStyle = const TextStyle(color: black, fontSize: 16),
    this.appBarHeight = 60,
    this.bgDecorationImage,
    this.onInit,
    this.safeArea = true,
    this.scrollView = false,
  }) : super(key: key);

  @override
  State<ScaffoldX> createState() => _ScaffoldXState();
}

class _ScaffoldXState extends State<ScaffoldX> {
  @override
  void initState() {
    if (widget.onInit != null) widget.onInit!();
    BackButtonInterceptor.add(myInterceptor);
    super.initState();
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  FutureOr<bool> myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    X.back();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    PreferredSize preferredSize() => PreferredSize(
          preferredSize: Size.fromHeight(widget.appBarHeight!),
          child: widget.appBar!,
        );

    Widget scrollableBody() => widget.scrollView
        ? SingleChildScrollView(child: widget.body)
        : widget.body;

    Widget safeBody() =>
        widget.safeArea ? SafeArea(child: scrollableBody()) : scrollableBody();

    LayoutBuilder layoutBuilder() => LayoutBuilder(
          builder: (
            BuildContext context,
            BoxConstraints constraints,
          ) {
            return DefaultTextStyle(
              style: widget.textStyle,
              child: Constrained(
                constraints: widget.constraints ?? constraints,
                child: Container(
                  decoration: BoxDecoration(
                    image: widget.bgDecorationImage,
                  ),
                  child: safeBody(),
                ),
              ),
            );
          },
        );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: widget.drawer,
      bottomNavigationBar: widget.bottomNavigationBar,
      bottomSheet: widget.bottomSheet,
      floatingActionButton: widget.fab,
      floatingActionButtonLocation: widget.fabLocation,
      backgroundColor: widget.bgColor,
      appBar: widget.appBar != null ? preferredSize() : null,
      body: layoutBuilder(),
    );
  }
}
