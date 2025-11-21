import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/bloc/popular_tvs_bloc.dart';
import 'package:tv/presentation/bloc/popular_tvs_event.dart';
import 'package:tv/presentation/bloc/popular_tvs_state.dart';
import 'package:tv/presentation/pages/popular_tvs_page.dart';

import '../../dummy_data/dummy_tv_objects.dart';

class MockPopularTvsBloc extends MockBloc<PopularTvsEvent, PopularTvsState>
    implements PopularTvsBloc {}

void main() {
  late MockPopularTvsBloc mockBloc;

  setUp(() {
    mockBloc = MockPopularTvsBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularTvsBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      PopularTvsState(state: RequestState.Loading, tvs: [], message: ''),
    );

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(PopularTvsPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      PopularTvsState(state: RequestState.Loaded, tvs: [testTv], message: ''),
    );

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(PopularTvsPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      PopularTvsState(
        state: RequestState.Error,
        tvs: [],
        message: 'Error message',
      ),
    );

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(PopularTvsPage()));

    expect(textFinder, findsOneWidget);
  });
}
