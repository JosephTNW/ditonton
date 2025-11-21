import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/state_enum.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/bloc/watchlist_tvs_bloc.dart';
import 'package:tv/presentation/bloc/watchlist_tvs_event.dart';
import 'package:tv/presentation/bloc/watchlist_tvs_state.dart';
import 'package:tv/presentation/pages/watchlist_tvs_page.dart';

import '../../dummy_data/dummy_tv_objects.dart';

class MockWatchlistTvsBloc
    extends MockBloc<WatchlistTvsEvent, WatchlistTvsState>
    implements WatchlistTvsBloc {}

class FakeRoute extends Fake implements Route<dynamic> {}

void main() {
  late MockWatchlistTvsBloc mockBloc;

  setUp(() {
    mockBloc = MockWatchlistTvsBloc();
  });

  setUpAll(() {
    registerFallbackValue(FakeRoute());
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistTvsBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body, navigatorObservers: [routeObserver]),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      WatchlistTvsState(state: RequestState.Loading, tvs: [], message: ''),
    );

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(WatchlistTvsPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      WatchlistTvsState(state: RequestState.Loaded, tvs: [testTv], message: ''),
    );

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(WatchlistTvsPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      WatchlistTvsState(
        state: RequestState.Error,
        tvs: [],
        message: 'Error message',
      ),
    );

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(WatchlistTvsPage()));

    expect(textFinder, findsOneWidget);
  });
}
