import 'package:core/utils/state_enum.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/presentation/bloc/now_playing_movies_bloc.dart';
import 'package:movies/presentation/bloc/now_playing_movies_state.dart';
import 'package:movies/presentation/pages/now_playing_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'now_playing_movies_page_test.mocks.dart';

@GenerateMocks([NowPlayingMoviesBloc])
void main() {
  late MockNowPlayingMoviesBloc mockBloc;

  setUp(() {
    mockBloc = MockNowPlayingMoviesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<NowPlayingMoviesBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(
      mockBloc.state,
    ).thenReturn(const NowPlayingMoviesState(state: RequestState.Loading));
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(const NowPlayingMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(
      const NowPlayingMoviesState(
        state: RequestState.Loaded,
        movies: <Movie>[],
      ),
    );
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const NowPlayingMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(
      const NowPlayingMoviesState(
        state: RequestState.Error,
        message: 'Error message',
      ),
    );
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(const NowPlayingMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}
