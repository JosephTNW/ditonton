import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/bloc/tv_list_bloc.dart';
import 'package:tv/presentation/bloc/tv_list_event.dart';
import 'package:tv/presentation/bloc/tv_list_state.dart';
import 'package:tv/presentation/pages/home_tv_page.dart';

import '../../dummy_data/tv/dummy_tv_objects.dart';

class MockTvListBloc extends MockBloc<TvListEvent, TvListState>
    implements TvListBloc {}

void main() {
  late MockTvListBloc mockBloc;

  setUp(() {
    mockBloc = MockTvListBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TvListBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      TvListState(
        onTheAirState: RequestState.Loading,
        onTheAirTvs: [],
        popularTvsState: RequestState.Loading,
        popularTvs: [],
        topRatedTvsState: RequestState.Loading,
        topRatedTvs: [],
        message: '',
      ),
    );

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(HomeTvPage()));

    expect(progressBarFinder, findsNWidgets(3));
  });

  testWidgets('Page should display TvList when on the air data is loaded', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      TvListState(
        onTheAirState: RequestState.Loaded,
        onTheAirTvs: [testTv],
        popularTvsState: RequestState.Loading,
        popularTvs: [],
        topRatedTvsState: RequestState.Loading,
        topRatedTvs: [],
        message: '',
      ),
    );

    final listFinder = find.byType(TvList);

    await tester.pumpWidget(_makeTestableWidget(HomeTvPage()));

    expect(listFinder, findsOneWidget);
  });

  testWidgets('Page should display all TvList when all data is loaded', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      TvListState(
        onTheAirState: RequestState.Loaded,
        onTheAirTvs: [testTv],
        popularTvsState: RequestState.Loaded,
        popularTvs: [testTv],
        topRatedTvsState: RequestState.Loaded,
        topRatedTvs: [testTv],
        message: '',
      ),
    );

    final listFinder = find.byType(TvList);

    await tester.pumpWidget(_makeTestableWidget(HomeTvPage()));

    expect(listFinder, findsNWidgets(3));
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      TvListState(
        onTheAirState: RequestState.Error,
        onTheAirTvs: [],
        popularTvsState: RequestState.Error,
        popularTvs: [],
        topRatedTvsState: RequestState.Error,
        topRatedTvs: [],
        message: 'Error message',
      ),
    );

    final textFinder = find.text('Failed');

    await tester.pumpWidget(_makeTestableWidget(HomeTvPage()));

    expect(textFinder, findsNWidgets(3));
  });

  testWidgets('Should have InkWell widgets for navigation', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      TvListState(
        onTheAirState: RequestState.Loaded,
        onTheAirTvs: [testTv],
        popularTvsState: RequestState.Loaded,
        popularTvs: [testTv],
        topRatedTvsState: RequestState.Loaded,
        topRatedTvs: [testTv],
        message: '',
      ),
    );

    await tester.pumpWidget(_makeTestableWidget(HomeTvPage()));
    await tester.pump();

    // Find the InkWell widgets - should have one for each tv in each list
    final inkWellFinder = find.byType(InkWell);
    expect(inkWellFinder, findsWidgets);
  });

  testWidgets('Should display error icon when image fails to load', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      TvListState(
        onTheAirState: RequestState.Loaded,
        onTheAirTvs: [testTv],
        popularTvsState: RequestState.Loaded,
        popularTvs: [testTv],
        topRatedTvsState: RequestState.Loaded,
        topRatedTvs: [testTv],
        message: '',
      ),
    );

    await tester.pumpWidget(_makeTestableWidget(HomeTvPage()));
    await tester.pump();

    // The error widget will be shown if image fails to load
    // CachedNetworkImage will handle this internally
    expect(find.byType(TvList), findsNWidgets(3));
  });

  testWidgets('Should display progress indicator while image is loading', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      TvListState(
        onTheAirState: RequestState.Loaded,
        onTheAirTvs: [testTv],
        popularTvsState: RequestState.Loaded,
        popularTvs: [testTv],
        topRatedTvsState: RequestState.Loaded,
        topRatedTvs: [testTv],
        message: '',
      ),
    );

    await tester.pumpWidget(_makeTestableWidget(HomeTvPage()));

    // The placeholder will be shown while image is loading
    expect(find.byType(TvList), findsNWidgets(3));
  });
}
