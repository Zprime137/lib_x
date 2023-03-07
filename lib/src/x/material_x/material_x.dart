import 'package:lib_x/lib_x.dart';

class MaterialX extends StatelessWidget {
  /// materialApp without routing configurations
  final MaterialApp materialApp;

  /// RouteMap that contains the routing map
  final RouteMap routeMap;

  const MaterialX({
    super.key,
    required this.materialApp,
    required this.routeMap,
  });

  Widget _materialBuilder(ThemeMode? mode) {
    /// these values will be taken from the materialApp arguement
    return OverlaySupport.global(
      child: MaterialApp.router(
        title: materialApp.title,

        /// String app title
        color: materialApp.color,

        /// Color? the app's primary color
        theme: materialApp.theme,

        /// ThemeData? default ThemeData
        darkTheme: materialApp.darkTheme,

        /// ThemeData? dark ThemeData
        highContrastTheme: materialApp.highContrastTheme,

        /// ThemeData? high Contrast ThemeData
        highContrastDarkTheme: materialApp.highContrastDarkTheme,

        /// ThemeData? high Contrast dark ThemeData
        themeMode: mode,

        /// ThemeMode? the active themeMode - reactive property
        locale: materialApp.locale,

        /// Locale? the default locale
        localeListResolutionCallback: materialApp.localeListResolutionCallback,

        /// Locale? localeListResolutionCallback
        localeResolutionCallback: materialApp.localeResolutionCallback,

        /// Locale? localeResolutionCallback
        localizationsDelegates: materialApp.localizationsDelegates,

        /// iterable localizationsDelegates
        supportedLocales: materialApp.supportedLocales,

        /// iterable supportedLocales list
        debugShowMaterialGrid: materialApp.debugShowMaterialGrid,

        /// bool debugShowMaterialGrid
        showPerformanceOverlay: materialApp.showPerformanceOverlay,

        /// bool showPerformanceOverlay
        checkerboardRasterCacheImages:
            materialApp.checkerboardRasterCacheImages,

        /// bool checkerboardRasterCacheImages
        checkerboardOffscreenLayers: materialApp.checkerboardOffscreenLayers,

        /// bool checkerboardOffscreenLayers
        showSemanticsDebugger: materialApp.showSemanticsDebugger,

        /// bool showSemanticsDebugger
        debugShowCheckedModeBanner: materialApp.debugShowCheckedModeBanner,

        /// bool debugShowCheckedModeBanner
        shortcuts: materialApp.shortcuts,

        /// Map of shortcuts
        actions: materialApp.actions,

        /// <ap of actions
        restorationScopeId: materialApp.restorationScopeId,

        /// String? restorationScopeId
        scrollBehavior: materialApp.scrollBehavior,

        /// ScrollBehavior? scrollBehavior
        useInheritedMediaQuery: materialApp.useInheritedMediaQuery,

        /// bool useInheritedMediaQuery
        routeInformationParser: X.routeParser,

        /// RoutemasterParser routeInformationParser
        routerDelegate: X.router,

        /// RoutemasterDelegate routerDelegate
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    X.config(
      window: WidgetsBinding.instance.window,
      app: materialApp,
      routeMap: routeMap,
    );

    /// if there's both light and dark ThemeData, ReactiveBuilder will be used to switch between themes
    return materialApp.theme != null && materialApp.darkTheme != null
        ? ReactiveBuilder<ThemeMode>(
            controller: X.themeMode,
            builder: _materialBuilder,
          )
        : _materialBuilder(materialApp.themeMode);
  }
}
