import 'package:core/presentation/pages/about_page.dart';
import 'package:tv/presentation/pages/home_tv_page.dart';
import 'package:movies/presentation/pages/watchlist_movies_page.dart';
import 'package:tv/presentation/pages/watchlist_tvs_page.dart';
import 'package:core/presentation/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget makeTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(body: body),
      routes: {
        '/home': (context) => Scaffold(body: Text('Home')),
        HomeTvPage.ROUTE_NAME: (context) => Scaffold(body: Text('TV Page')),
        WatchlistTvsPage.ROUTE_NAME:
            (context) => Scaffold(body: Text('TV Watchlist')),
        WatchlistMoviesPage.ROUTE_NAME:
            (context) => Scaffold(body: Text('Movie Watchlist')),
        AboutPage.ROUTE_NAME: (context) => Scaffold(body: Text('About')),
      },
    );
  }

  testWidgets('AppDrawer should display all menu items when on movie page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(makeTestableWidget(AppDrawer(isOnMoviePage: true)));

    expect(find.text('Ditonton'), findsOneWidget);
    expect(find.text('ditonton@dicoding.com'), findsOneWidget);
    expect(find.text('TV Series'), findsOneWidget);
    expect(find.text('Movies'), findsOneWidget);
    expect(find.text('TV Watchlist'), findsOneWidget);
    expect(find.text('Movie Watchlist'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
  });

  testWidgets('AppDrawer should display all menu items when on TV page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      makeTestableWidget(AppDrawer(isOnMoviePage: false)),
    );

    expect(find.text('Ditonton'), findsOneWidget);
    expect(find.text('ditonton@dicoding.com'), findsOneWidget);
    expect(find.text('TV Series'), findsOneWidget);
    expect(find.text('Movies'), findsOneWidget);
    expect(find.text('TV Watchlist'), findsOneWidget);
    expect(find.text('Movie Watchlist'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
  });

  testWidgets('AppDrawer should have drawer widget', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(makeTestableWidget(AppDrawer(isOnMoviePage: true)));

    expect(find.byType(Drawer), findsOneWidget);
  });

  testWidgets('AppDrawer should have UserAccountsDrawerHeader', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(makeTestableWidget(AppDrawer(isOnMoviePage: true)));

    expect(find.byType(UserAccountsDrawerHeader), findsOneWidget);
  });

  testWidgets('AppDrawer should have CircleAvatar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(makeTestableWidget(AppDrawer(isOnMoviePage: true)));

    expect(find.byType(CircleAvatar), findsOneWidget);
  });

  testWidgets('AppDrawer should navigate to TV page when on movie page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(makeTestableWidget(AppDrawer(isOnMoviePage: true)));

    await tester.tap(find.text('TV Series'));
    await tester.pumpAndSettle();

    expect(find.text('TV Page'), findsOneWidget);
  });

  testWidgets(
    'AppDrawer should close drawer when TV Series tapped on TV page',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(AppDrawer(isOnMoviePage: false)),
      );

      await tester.tap(find.text('TV Series'));
      await tester.pumpAndSettle();

      expect(find.text('TV Page'), findsNothing);
    },
  );

  testWidgets(
    'AppDrawer should close drawer when Movies tapped on movie page',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(AppDrawer(isOnMoviePage: true)),
      );

      await tester.tap(find.text('Movies'));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsNothing);
    },
  );

  testWidgets(
    'AppDrawer should navigate to home when Movies tapped on TV page',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(AppDrawer(isOnMoviePage: false)),
      );

      await tester.tap(find.text('Movies'));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
    },
  );

  testWidgets('AppDrawer should navigate to TV Watchlist', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(makeTestableWidget(AppDrawer(isOnMoviePage: true)));

    await tester.tap(find.text('TV Watchlist'));
    await tester.pumpAndSettle();

    expect(find.text('TV Watchlist'), findsWidgets);
  });

  testWidgets('AppDrawer should navigate to Movie Watchlist', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(makeTestableWidget(AppDrawer(isOnMoviePage: true)));

    await tester.tap(find.text('Movie Watchlist'));
    await tester.pumpAndSettle();

    expect(find.text('Movie Watchlist'), findsWidgets);
  });

  testWidgets('AppDrawer should navigate to About page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(makeTestableWidget(AppDrawer(isOnMoviePage: true)));

    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();

    expect(find.text('About'), findsWidgets);
  });

  testWidgets('AppDrawer should display correct icons', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(makeTestableWidget(AppDrawer(isOnMoviePage: true)));

    expect(find.byIcon(Icons.tv), findsOneWidget);
    expect(find.byIcon(Icons.movie), findsOneWidget);
    expect(find.byIcon(Icons.live_tv), findsOneWidget);
    expect(find.byIcon(Icons.save_alt), findsOneWidget);
    expect(find.byIcon(Icons.info_outline), findsOneWidget);
  });
}
