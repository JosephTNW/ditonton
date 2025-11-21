import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/bloc/tv_detail_bloc.dart';
import 'package:tv/presentation/bloc/tv_detail_event.dart';
import 'package:tv/presentation/bloc/tv_detail_state.dart';
import 'package:tv/presentation/pages/tv_detail_page.dart';

import '../../dummy_data/dummy_tv_objects.dart';

class MockTvDetailBloc extends MockBloc<TvDetailEvent, TvDetailState>
    implements TvDetailBloc {}

void main() {
  late MockTvDetailBloc mockBloc;

  setUp(() {
    mockBloc = MockTvDetailBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TvDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(
      () => mockBloc.state,
    ).thenReturn(TvDetailState(tvState: RequestState.Loading));

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display DetailContent when data is loaded', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      TvDetailState(
        tvState: RequestState.Loaded,
        tv: testTvDetail,
        recommendationState: RequestState.Loaded,
        tvRecommendations: [testTv],
        isAddedToWatchlist: false,
      ),
    );

    final detailContentFinder = find.byType(DetailContent);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(detailContentFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      TvDetailState(tvState: RequestState.Error, message: 'Error message'),
    );

    final textFinder = find.text('Error message');

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(textFinder, findsOneWidget);
  });

  testWidgets(
    'Watchlist button should display add icon when tv not added to watchlist',
    (WidgetTester tester) async {
      when(() => mockBloc.state).thenReturn(
        TvDetailState(
          tvState: RequestState.Loaded,
          tv: testTvDetail,
          recommendationState: RequestState.Loaded,
          tvRecommendations: [testTv],
          isAddedToWatchlist: false,
        ),
      );

      final watchlistButtonIcon = find.byIcon(Icons.add);

      await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display check icon when tv is added to watchlist',
    (WidgetTester tester) async {
      when(() => mockBloc.state).thenReturn(
        TvDetailState(
          tvState: RequestState.Loaded,
          tv: testTvDetail,
          recommendationState: RequestState.Loaded,
          tvRecommendations: [testTv],
          isAddedToWatchlist: true,
        ),
      );

      final watchlistButtonIcon = find.byIcon(Icons.check);

      await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should call AddTvToWatchlist when tapped and not yet added',
    (WidgetTester tester) async {
      when(() => mockBloc.state).thenReturn(
        TvDetailState(
          tvState: RequestState.Loaded,
          tv: testTvDetail,
          recommendationState: RequestState.Loaded,
          tvRecommendations: [testTv],
          isAddedToWatchlist: false,
        ),
      );

      await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

      final watchlistButton = find.byType(FilledButton);
      await tester.tap(watchlistButton);

      verify(() => mockBloc.add(AddTvToWatchlist(testTvDetail))).called(1);
    },
  );

  testWidgets(
    'Watchlist button should call RemoveTvFromWatchlist when tapped and already added',
    (WidgetTester tester) async {
      when(() => mockBloc.state).thenReturn(
        TvDetailState(
          tvState: RequestState.Loaded,
          tv: testTvDetail,
          recommendationState: RequestState.Loaded,
          tvRecommendations: [testTv],
          isAddedToWatchlist: true,
        ),
      );

      await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

      final watchlistButton = find.byType(FilledButton);
      await tester.tap(watchlistButton);

      verify(() => mockBloc.add(RemoveTvFromWatchlist(testTvDetail))).called(1);
    },
  );

  testWidgets('Page should display recommendations when loaded', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      TvDetailState(
        tvState: RequestState.Loaded,
        tv: testTvDetail,
        recommendationState: RequestState.Loaded,
        tvRecommendations: [testTv],
        isAddedToWatchlist: false,
      ),
    );

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    final recommendationListFinder = find.byType(ListView);

    expect(recommendationListFinder, findsOneWidget);
  });

  testWidgets(
    'Page should display progress bar when recommendations are loading',
    (WidgetTester tester) async {
      when(() => mockBloc.state).thenReturn(
        TvDetailState(
          tvState: RequestState.Loaded,
          tv: testTvDetail,
          recommendationState: RequestState.Loading,
          tvRecommendations: [],
          isAddedToWatchlist: false,
        ),
      );

      await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));
      await tester.pump();

      final progressBarFinder = find.byType(CircularProgressIndicator);

      expect(progressBarFinder, findsWidgets);
    },
  );

  testWidgets('Page should display error message when recommendations fail', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      TvDetailState(
        tvState: RequestState.Loaded,
        tv: testTvDetail,
        recommendationState: RequestState.Error,
        tvRecommendations: [],
        message: 'Failed to load recommendations',
        isAddedToWatchlist: false,
      ),
    );

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));
    await tester.pump();

    final errorFinder = find.text('Failed to load recommendations');

    expect(errorFinder, findsOneWidget);
  });
}
