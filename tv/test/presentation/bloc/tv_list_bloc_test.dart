import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:tv/domain/usecases/get_on_the_air_tvs.dart';
import 'package:tv/domain/usecases/get_popular_tvs.dart';
import 'package:tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:tv/presentation/bloc/tv_list_bloc.dart';
import 'package:tv/presentation/bloc/tv_list_event.dart';
import 'package:tv/presentation/bloc/tv_list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/tv/dummy_tv_objects.dart';
import 'tv_list_bloc_test.mocks.dart';

@GenerateMocks([GetOnTheAirTvs, GetPopularTvs, GetTopRatedTvs])
void main() {
  late TvListBloc bloc;
  late MockGetOnTheAirTvs mockGetOnTheAirTvs;
  late MockGetPopularTvs mockGetPopularTvs;
  late MockGetTopRatedTvs mockGetTopRatedTvs;

  setUp(() {
    mockGetOnTheAirTvs = MockGetOnTheAirTvs();
    mockGetPopularTvs = MockGetPopularTvs();
    mockGetTopRatedTvs = MockGetTopRatedTvs();
    bloc = TvListBloc(
      getOnTheAirTvs: mockGetOnTheAirTvs,
      getPopularTvs: mockGetPopularTvs,
      getTopRatedTvs: mockGetTopRatedTvs,
    );
  });

  test('initial state should be empty', () {
    expect(bloc.state, const TvListState());
    expect(bloc.state.onTheAirState, RequestState.Empty);
    expect(bloc.state.popularTvsState, RequestState.Empty);
    expect(bloc.state.topRatedTvsState, RequestState.Empty);
  });

  group('FetchOnTheAirTvs', () {
    blocTest<TvListBloc, TvListState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(
          mockGetOnTheAirTvs.execute(),
        ).thenAnswer((_) async => Right(testTvList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchOnTheAirTvs()),
      expect:
          () => [
            const TvListState(onTheAirState: RequestState.Loading),
            TvListState(
              onTheAirState: RequestState.Loaded,
              onTheAirTvs: testTvList,
            ),
          ],
      verify: (_) {
        verify(mockGetOnTheAirTvs.execute());
      },
    );

    blocTest<TvListBloc, TvListState>(
      'should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(
          mockGetOnTheAirTvs.execute(),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchOnTheAirTvs()),
      expect:
          () => [
            const TvListState(onTheAirState: RequestState.Loading),
            const TvListState(
              onTheAirState: RequestState.Error,
              message: 'Server Failure',
            ),
          ],
      verify: (_) {
        verify(mockGetOnTheAirTvs.execute());
      },
    );
  });

  group('FetchPopularTvs', () {
    blocTest<TvListBloc, TvListState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(
          mockGetPopularTvs.execute(),
        ).thenAnswer((_) async => Right(testTvList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchPopularTvs()),
      expect:
          () => [
            const TvListState(popularTvsState: RequestState.Loading),
            TvListState(
              popularTvsState: RequestState.Loaded,
              popularTvs: testTvList,
            ),
          ],
      verify: (_) {
        verify(mockGetPopularTvs.execute());
      },
    );

    blocTest<TvListBloc, TvListState>(
      'should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(
          mockGetPopularTvs.execute(),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchPopularTvs()),
      expect:
          () => [
            const TvListState(popularTvsState: RequestState.Loading),
            const TvListState(
              popularTvsState: RequestState.Error,
              message: 'Server Failure',
            ),
          ],
      verify: (_) {
        verify(mockGetPopularTvs.execute());
      },
    );
  });

  group('FetchTopRatedTvs', () {
    blocTest<TvListBloc, TvListState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(
          mockGetTopRatedTvs.execute(),
        ).thenAnswer((_) async => Right(testTvList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTvs()),
      expect:
          () => [
            const TvListState(topRatedTvsState: RequestState.Loading),
            TvListState(
              topRatedTvsState: RequestState.Loaded,
              topRatedTvs: testTvList,
            ),
          ],
      verify: (_) {
        verify(mockGetTopRatedTvs.execute());
      },
    );

    blocTest<TvListBloc, TvListState>(
      'should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(
          mockGetTopRatedTvs.execute(),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTvs()),
      expect:
          () => [
            const TvListState(topRatedTvsState: RequestState.Loading),
            const TvListState(
              topRatedTvsState: RequestState.Error,
              message: 'Server Failure',
            ),
          ],
      verify: (_) {
        verify(mockGetTopRatedTvs.execute());
      },
    );
  });
}
