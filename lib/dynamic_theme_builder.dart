import 'package:dowcipy_xxl_foss/screens/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dowcipy_xxl_foss/theme.dart';
import 'package:window_manager/window_manager.dart';
import 'package:dowcipy_xxl_foss/screens/joke_screen.dart';
import 'package:dowcipy_xxl_foss/screens/favorites_screen.dart';
import 'package:dowcipy_xxl_foss/screens/search_screen.dart';
import 'package:dowcipy_xxl_foss/screens/settings_screen.dart';

class DynamicThemeBuilder extends StatefulWidget {
  const DynamicThemeBuilder({
    super.key,
    required this.title,
  });
  final String title;

  @override
  State<DynamicThemeBuilder> createState() => _DynamicThemeBuilderState();
}

class _DynamicThemeBuilderState extends State<DynamicThemeBuilder>
    with WidgetsBindingObserver {
  Brightness brightness = PlatformDispatcher.instance.platformBrightness;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
  }

  @override
  void didChangePlatformBrightness() {
    final Brightness brightness =
        PlatformDispatcher.instance.platformBrightness;
    setState(() {
      this.brightness = brightness;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        final ThemeData lightDynamicTheme = ThemeData(
          useMaterial3: true,
          navigationBarTheme: NavigationBarThemeData(
            labelTextStyle: WidgetStateProperty.all(
              GoogleFonts.roboto(
                color: lightColorScheme?.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: lightColorScheme?.primary ?? lightCustomColorScheme.primary, brightness: Brightness.light)
              .harmonized(),
          textTheme: GoogleFonts.robotoTextTheme(ThemeData.light().textTheme),
        );
        final ThemeData darkDynamicTheme = ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
          navigationBarTheme: NavigationBarThemeData(
            labelTextStyle: WidgetStateProperty.all(
              GoogleFonts.roboto(
                color: darkColorScheme?.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: darkColorScheme?.primary ?? darkCustomColorScheme.primary, brightness: Brightness.dark),
          textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme),
        );
        return DynamicTheme(
          themeCollection: ThemeCollection(
            themes: {
              0: brightness == Brightness.light
                  ? lightCustomTheme
                  : darkCustomTheme,
              1: brightness == Brightness.light
                  ? lightDynamicTheme
                  : darkDynamicTheme,
              2: lightCustomTheme,
              3: lightDynamicTheme,
              4: darkCustomTheme,
              5: darkDynamicTheme,
            },
            fallbackTheme:
                PlatformDispatcher.instance.platformBrightness ==
                    Brightness.light
                ? lightCustomTheme
                : darkCustomTheme,
          ),
          builder: (context, theme) => MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: widget.title,
            theme: theme,
            routeInformationParser: router.routeInformationParser,
            routerDelegate: router.routerDelegate,
            routeInformationProvider: router.routeInformationProvider,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WindowListener {
  final SearchController _searchController = SearchController();
  late final List<NavigationDestination> destinations = [
    const NavigationDestination(
      key: Key('home'),
      icon: Icon(Icons.home_outlined),
      label: 'Home',
      selectedIcon: Icon(Icons.home),
    ),
    const NavigationDestination(
      key: Key('settings'),
      icon: Icon(Icons.settings_outlined),
      label: 'Settings',
      selectedIcon: Icon(Icons.settings),
    ),
  ];

  @override
  void initState() {
    super.initState();
    
  }

  @override
  void dispose() {
    
    super.dispose();
  }
  
  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/settings');
        break;  
  }
}

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/settings')) {
      return 1;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
  title: Center(
    child: SearchBar(
      controller: _searchController,
      padding: const WidgetStatePropertyAll<EdgeInsets>(
        EdgeInsets.symmetric(horizontal: 16.0),
      ),
      onTap: () {},
      onChanged: (_) {},
      onSubmitted: (String value) {
        if (value.isNotEmpty) {
          context.push('/search/$value');
        }
      },
      leading: const Icon(Icons.search),
      hintText: 'Szukaj...',
    ),
  ),
),
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        destinations: destinations,
        onDestinationSelected: (index) => _onItemTapped(index, context),
      ),
    );
  }
}
final rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MyHomePage(
          child: child,
        );
      },
      routes: <GoRoute>[
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
        GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
      ],
    ),
    GoRoute(
      path: '/category/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        final categoryName = state.extra as String? ?? 'Kategoria';
        return JokeScreen(categoryId: id, categoryName: categoryName);
      },
    ),
    GoRoute(
      path: '/favorites',
      builder: (context, state) => const FavoritesScreen(),
    ),
    GoRoute(
      path: '/search/:query',
      builder: (context, state) {
        final query = state.pathParameters['query']!;
        return SearchScreen(query: query);
      },
    ),
  ]
);
  

