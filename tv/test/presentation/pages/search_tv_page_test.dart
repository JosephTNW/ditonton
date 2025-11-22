import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/bloc/tv_search_bloc.dart';
import 'package:tv/presentation/bloc/tv_search_event.dart';
import 'package:tv/presentation/bloc/tv_search_state.dart';
import 'package:tv/presentation/pages/search_tv_page.dart';

import '../../dummy_data/tv/dummy_tv_objects.dart';

class MockTvSearchBloc extends MockBloc<TvSearchEvent, TvSearchState>
    implements TvSearchBloc {}

void main() {
  late MockTvSearchBloc mockBloc;

  setUp(() {
    mockBloc = MockTvSearchBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TvSearchBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      TvSearchState(state: RequestState.Loading, searchResult: [], message: ''),
    );

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(SearchTvPage()));

    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      TvSearchState(
        state: RequestState.Loaded,
        searchResult: [testTv],
        message: '',
      ),
    );

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(SearchTvPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display empty container when Error', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      TvSearchState(
        state: RequestState.Error,
        searchResult: [],
        message: 'Error message',
      ),
    );

    final containerFinder = find.byType(Container);

    await tester.pumpWidget(_makeTestableWidget(SearchTvPage()));

    expect(containerFinder, findsWidgets);
  });

  testWidgets('Page should display empty container when empty', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      TvSearchState(state: RequestState.Empty, searchResult: [], message: ''),
    );

    final containerFinder = find.byType(Container);

    await tester.pumpWidget(_makeTestableWidget(SearchTvPage()));

    expect(containerFinder, findsWidgets);
  });

  testWidgets('TextField should be found', (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(
      TvSearchState(state: RequestState.Empty, searchResult: [], message: ''),
    );

    final textFieldFinder = find.byType(TextField);

    await tester.pumpWidget(_makeTestableWidget(SearchTvPage()));

    expect(textFieldFinder, findsOneWidget);
  });

  testWidgets('TextField should trigger search when text is entered', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      TvSearchState(state: RequestState.Empty, searchResult: [], message: ''),
    );

    await tester.pumpWidget(_makeTestableWidget(SearchTvPage()));

    final textFieldFinder = find.byType(TextField);
    expect(textFieldFinder, findsOneWidget);

    // Enter text into the TextField
    await tester.enterText(textFieldFinder, 'Game of Thrones');
    await tester.pump();

    // Verify that the OnTvQueryChanged event is added
    verify(() => mockBloc.add(OnTvQueryChanged('Game of Thrones'))).called(1);
  });

  testWidgets('TextField should have correct hint text and icon', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      TvSearchState(state: RequestState.Empty, searchResult: [], message: ''),
    );

    await tester.pumpWidget(_makeTestableWidget(SearchTvPage()));

    expect(find.text('Search TV series title'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });
}
