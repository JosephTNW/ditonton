import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:tv/domain/usecases/get_watchlist_tvs.dart';
import 'package:tv/presentation/bloc/watchlist_tvs_bloc.dart';
import 'package:tv/presentation/bloc/watchlist_tvs_event.dart';
import 'package:tv/presentation/bloc/watchlist_tvs_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/tv/dummy_tv_objects.dart';
import 'watchlist_tvs_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTvs])
void main() {
  late WatchlistTvsBloc bloc;
  late MockGetWatchlistTvs mockGetWatchlistTvs;

  setUp(() {
    mockGetWatchlistTvs = MockGetWatchlistTvs();
    bloc = WatchlistTvsBloc(getWatchlistTvs: mockGetWatchlistTvs);
  });

  test('initial state should be empty', () {
    expect(bloc.state, const WatchlistTvsState());
    expect(bloc.state.state, RequestState.Empty);
  });

  blocTest<WatchlistTvsBloc, WatchlistTvsState>(
    'should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(
        mockGetWatchlistTvs.execute(),
      ).thenAnswer((_) async => Right(testTvList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTvsEvent()),
    expect:
        () => [
          const WatchlistTvsState(state: RequestState.Loading),
          WatchlistTvsState(state: RequestState.Loaded, tvs: testTvList),
        ],
    verify: (_) {
      verify(mockGetWatchlistTvs.execute());
    },
  );

  blocTest<WatchlistTvsBloc, WatchlistTvsState>(
    'should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(mockGetWatchlistTvs.execute()).thenAnswer(
        (_) async => const Left(DatabaseFailure('Database Failure')),
      );
      return bloc;
    },
    act: (bloc) => bloc.add(FetchWatchlistTvsEvent()),
    expect:
        () => [
          const WatchlistTvsState(state: RequestState.Loading),
          const WatchlistTvsState(
            state: RequestState.Error,
            message: 'Database Failure',
          ),
        ],
    verify: (_) {
      verify(mockGetWatchlistTvs.execute());
    },
  );
}
