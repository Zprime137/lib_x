// ignore_for_file: constant_identifier_names

import 'package:lib_x/lib_x.dart';

const String Root = '/';
final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

/// X short for MaterialX Controller
abstract class X {
  /// private: used to set [onPlatformBrightnessChanged]
  static late SingletonFlutterWindow _window;

  /// private: used to config the [MaterialApp.router]
  static late MaterialApp _materialApp;

  /// [RoutemasterDelegate]: from routemaster package
  static late RoutemasterDelegate router;

  /// RoutemasterParser: from routemaster package
  static const RoutemasterParser routeParser = RoutemasterParser();

  /// getter: for the current context
  static BuildContext get currentContext => _navigatorKey.currentContext!;

  /// getter: to MediaQueryData
  static MediaQueryData get mediaQuery => MediaQuery.of(currentContext);

  /// getter: for the current active theme
  static ThemeData get theme => Theme.of(currentContext);

  /// ValueController: for a ReactiveBuilder to change the ThemeMode
  static final ValueController<ThemeMode> themeMode =
      ValueController<ThemeMode>(XUtils.sysThemeMode);

  ///Getter: check if modal is open
  static bool isOpenModal = false;

  /// current path
  static String currentPath = Root;

  /// Map: current path parameters
  static late Map<String, String>? currentPathParameters;

  /// Map: current path queries paramaters
  static late Map<String, String>? currentQueryParameters;

  /// used to config MaterialX widget
  static void config({
    /// the window attatched when app starts
    required SingletonFlutterWindow window,

    /// RouteMap: the paths and their corresponding scaffolds
    required RouteMap routeMap,

    /// MaterialApp: contains themes and locales configs
    required MaterialApp app,
  }) {
    setPathUrlStrategy();
    router = RoutemasterDelegate(
      routesBuilder: (BuildContext context) => routeMap,
      navigatorKey: _navigatorKey,
    );

    _window = window;
    _materialApp = app;
    _configThemeMode();
  }

  /// private: config theme mode options
  static void _configThemeMode() {
    final bool isAuto = _materialApp.theme != null &&
        _materialApp.darkTheme != null &&
        (_materialApp.themeMode == null ||
            _materialApp.themeMode == ThemeMode.system);

    if (isAuto) {
      _window.onPlatformBrightnessChanged = _updateThemeMode;
      themeMode.onChange = _updateStatusBar;
      Future.delayed(const Duration(seconds: 1), () {
        themeMode.update(XUtils.sysThemeMode);
        _updateStatusBar();
      });
    }
  }

  /// private: to update theme mode and the statusbar color & brightness accordingly
  static void _updateThemeMode() {
    themeMode.update(XUtils.sysThemeMode);
    _updateStatusBar();
  }

  /// private: to update the statusBar [color] & [brightness]
  static void _updateStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: transparent,
        statusBarIconBrightness: theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
      ),
    );
  }

  /// to switch [ThemeMode] programmatically
  static void switchTheme({ThemeMode? to}) {
    late ThemeMode value;
    late VoidCallback? sysOnChange;

    if (to != ThemeMode.system) {
      sysOnChange = null;
      value = to ??
          (theme.brightness == Brightness.dark
              ? ThemeMode.light
              : ThemeMode.dark);
    } else {
      sysOnChange = _updateThemeMode;
      value = XUtils.sysThemeMode;
    }

    _window.onPlatformBrightnessChanged = sysOnChange;
    themeMode.update(value);
  }

  /// to force portrait orientation
  static void forcePortrait() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  /// to force landscape orientation
  static void forceLandscape() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  /// to allow all orientations
  static void allowAutoOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  /// private: to set current path paramaters and quries
  static void _setCurrentPath() {
    currentPath = router.currentConfiguration!.path;
    currentPathParameters = router.currentConfiguration!.pathParameters;
    currentQueryParameters = router.currentConfiguration!.queryParameters;
    debugPrint('Current path: $currentPath');
  }

  static bool _enabledBack = true;

  /// back to previous route chronologically
  static void back() {
    if (isOpenModal) {
      pop();
    } else if (_enabledBack && router.history.canGoBack) {
      router.history.back();
      _enabledBack = false;
      _setCurrentPath();
      Timer(const Duration(seconds: 1), () => _enabledBack = true);
    }
  }

  /// to a defined path in the RouteMap
  static void to({required String path}) {
    router.push(path);
    _setCurrentPath();
  }

  /// to path and prevent back
  static void offTo({required String path}) {
    router.replace(path);
    _setCurrentPath();
  }

  /// back to any previous route in the material route stack
  static void backTo({required String path}) {
    router.popUntil(((routeData) => routeData.path != path));
    _setCurrentPath();
  }

  /// open drawer programmatically
  static void openDrawer() => Scaffold.of(currentContext).openDrawer();

  /// dismiss keyboard programmatically
  static void dissmissKeyboard() => FocusScope.of(currentContext).unfocus();

  /// show snackBar
  static void showSnackBar({required SnackBar snackBar}) {
    ScaffoldMessenger.of(currentContext).hideCurrentSnackBar();
    ScaffoldMessenger.of(currentContext).showSnackBar(snackBar);
  }

  /// show notification widget in overlay
  static void showNotification({
    /// the notification widget
    required Widget widget,

    /// if notification widget is dismissable
    bool dismissable = true,

    /// callback on dismiss
    VoidCallback? onDismiss,

    /// callback onTap
    VoidCallback? onTap,

    /// the duration before dismissing the notification widget
    Duration duration = const Duration(seconds: 5),

    /// position of notification widget
    NotificationPosition position = NotificationPosition.top,
  }) {
    if (onTap != null) {
      widget = GestureDetector(
        onTap: onTap,
        child: widget,
      );
    }
    if (dismissable) {
      widget = Dismissible(
        key: Key(XUtils.genId()),
        onDismissed: (direction) => onDismiss,
        child: widget,
      );
    }

    showOverlayNotification(
      (BuildContext context) => widget,
      duration: duration,
      position: position,
    );
  }

  /// show widget in bottomSheet
  static void showBottomSheet({required Widget widget}) => showModalBottomSheet(
        context: currentContext,
        isScrollControlled: true,
        builder: (BuildContext context) => widget,
      );

  /// show dialog widget in a material modal
  static void showModal({
    /// dialog widget
    required Widget widget,

    /// bool: is wrapped with safeArea
    bool safeArea = true,

    /// bool: is dialog dismissable when tapped outside
    bool dismissable = true,

    /// Color: the barrier background color
    Color? barrierColor,
  }) {
    isOpenModal = true;
    showDialog(
      /// barrierDismissible: true, /// doesn't work
      useSafeArea: safeArea,
      barrierColor: barrierColor ?? black.withOpacity(.33),
      context: currentContext,
      builder: (BuildContext context) => Material(
        child: dismissable ? DismissableModal(child: widget) : widget,
      ),
    );
  }

  /// to pop modal, bottomSheet, drawer, or keyboard
  static void pop() {
    isOpenModal = false;
    Navigator.of(currentContext, rootNavigator: true).pop();
  }
}
