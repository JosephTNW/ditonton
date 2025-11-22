import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/bloc/on_the_air_tvs_bloc.dart';
import 'package:tv/presentation/bloc/on_the_air_tvs_event.dart';
import 'package:tv/presentation/bloc/on_the_air_tvs_state.dart';
import 'package:tv/presentation/pages/on_the_air_tvs_page.dart';

import '../../dummy_data/tv/dummy_tv_objects.dart';

class MockOnTheAirTvsBloc extends MockBloc<OnTheAirTvsEvent, OnTheAirTvsState>
    implements OnTheAirTvsBloc {}

void main() {
  late MockOnTheAirTvsBloc mockBloc;

  setUp(() {
    mockBloc = MockOnTheAirTvsBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<OnTheAirTvsBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      OnTheAirTvsState(state: RequestState.Loading, tvs: [], message: ''),
    );

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(OnTheAirTvsPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      OnTheAirTvsState(state: RequestState.Loaded, tvs: [testTv], message: ''),
    );

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(OnTheAirTvsPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      OnTheAirTvsState(
        state: RequestState.Error,
        tvs: [],
        message: 'Error message',
      ),
    );

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(OnTheAirTvsPage()));

    expect(textFinder, findsOneWidget);
  });
}
