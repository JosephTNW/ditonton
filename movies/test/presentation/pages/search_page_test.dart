import 'package:core/utils/state_enum.dart';
import 'package:movies/domain/entities/movie.dart';
import 'package:movies/presentation/bloc/movie_search_bloc.dart';
import 'package:movies/presentation/bloc/movie_search_event.dart';
import 'package:movies/presentation/bloc/movie_search_state.dart';
import 'package:movies/presentation/pages/search_page.dart';
import 'package:movies/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'search_page_test.mocks.dart';

@GenerateMocks([MovieSearchBloc])
void main() {
  late MockMovieSearchBloc mockBloc;

  setUp(() {
    mockBloc = MockMovieSearchBloc();
  });

  final tMovie = Movie(
    adult: false,
    backdropPath: '/backdropPath.jpg',
    genreIds: const [1, 2, 3],
    id: 1,
    originalTitle: 'Original Title',
    overview: 'Overview',
    popularity: 7.8,
    posterPath: '/posterPath.jpg',
    releaseDate: '2020-01-01',
    title: 'Test Movie',
    video: false,
    voteAverage: 8.5,
    voteCount: 100,
  );

  final tMovieList = [tMovie];

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<MovieSearchBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(
      mockBloc.state,
    ).thenReturn(const MovieSearchState(state: RequestState.Loading));
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const SearchPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(
      MovieSearchState(state: RequestState.Loaded, searchResult: tMovieList),
    );
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const SearchPage()));

    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(MovieCard), findsOneWidget);
  });

  testWidgets('Page should display empty container when error', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(
      const MovieSearchState(
        state: RequestState.Error,
        message: 'Error message',
      ),
    );
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const SearchPage()));

    expect(find.byType(Container), findsWidgets);
  });

  testWidgets('Page should have app bar with title', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(const MovieSearchState());
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const SearchPage()));

    expect(find.text('Search'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });

  testWidgets('Page should have search text field', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(const MovieSearchState());
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const SearchPage()));

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Search Result'), findsOneWidget);
  });

  testWidgets('Page should trigger search event when text changed', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(const MovieSearchState());
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const SearchPage()));

    const query = 'test';
    await tester.enterText(find.byType(TextField), query);

    verify(mockBloc.add(const OnQueryChanged(query))).called(1);
  });

  testWidgets('Page should display search hint', (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(const MovieSearchState());
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(makeTestableWidget(const SearchPage()));

    expect(find.text('Search title'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });
}
