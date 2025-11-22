import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:tv/domain/usecases/get_tv_watchlist_status.dart';
import 'package:tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:tv/domain/usecases/save_watchlist_tv.dart';
import 'package:tv/presentation/bloc/tv_detail_bloc.dart';
import 'package:tv/presentation/bloc/tv_detail_event.dart';
import 'package:tv/presentation/bloc/tv_detail_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/tv/dummy_tv_objects.dart';
import 'tv_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvDetail,
  GetTvRecommendations,
  GetTvWatchListStatus,
  SaveWatchlistTv,
  RemoveWatchlistTv,
])
void main() {
  late TvDetailBloc bloc;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;
  late MockGetTvWatchListStatus mockGetTvWatchListStatus;
  late MockSaveWatchlistTv mockSaveWatchlistTv;
  late MockRemoveWatchlistTv mockRemoveWatchlistTv;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendations = MockGetTvRecommendations();
    mockGetTvWatchListStatus = MockGetTvWatchListStatus();
    mockSaveWatchlistTv = MockSaveWatchlistTv();
    mockRemoveWatchlistTv = MockRemoveWatchlistTv();
    bloc = TvDetailBloc(
      getTvDetail: mockGetTvDetail,
      getTvRecommendations: mockGetTvRecommendations,
      getWatchListStatus: mockGetTvWatchListStatus,
      saveWatchlist: mockSaveWatchlistTv,
      removeWatchlist: mockRemoveWatchlistTv,
    );
  });

  const tId = 1;

  group('FetchTvDetail', () {
    test('initial state should be empty', () {
      expect(bloc.state, const TvDetailState());
    });

    blocTest<TvDetailBloc, TvDetailState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(
          mockGetTvDetail.execute(tId),
        ).thenAnswer((_) async => Right(testTvDetail));
        when(
          mockGetTvRecommendations.execute(tId),
        ).thenAnswer((_) async => Right(testTvList));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchTvDetail(tId)),
      expect:
          () => [
            const TvDetailState(tvState: RequestState.Loading),
            TvDetailState(
              tvState: RequestState.Loaded,
              tv: testTvDetail,
              recommendationState: RequestState.Loading,
            ),
            TvDetailState(
              tvState: RequestState.Loaded,
              tv: testTvDetail,
              recommendationState: RequestState.Loaded,
              tvRecommendations: testTvList,
            ),
          ],
      verify: (_) {
        verify(mockGetTvDetail.execute(tId));
        verify(mockGetTvRecommendations.execute(tId));
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'should emit [Loading, Error] when get detail is unsuccessful',
      build: () {
        when(
          mockGetTvDetail.execute(tId),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        when(
          mockGetTvRecommendations.execute(tId),
        ).thenAnswer((_) async => Right(testTvList));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchTvDetail(tId)),
      expect:
          () => [
            const TvDetailState(tvState: RequestState.Loading),
            const TvDetailState(
              tvState: RequestState.Error,
              message: 'Server Failure',
            ),
          ],
      verify: (_) {
        verify(mockGetTvDetail.execute(tId));
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'should emit [Loading, Loaded, Error] when get recommendations is unsuccessful',
      build: () {
        when(
          mockGetTvDetail.execute(tId),
        ).thenAnswer((_) async => Right(testTvDetail));
        when(
          mockGetTvRecommendations.execute(tId),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchTvDetail(tId)),
      expect:
          () => [
            const TvDetailState(tvState: RequestState.Loading),
            TvDetailState(
              tv: testTvDetail,
              tvState: RequestState.Loaded,
              recommendationState: RequestState.Loading,
            ),
            TvDetailState(
              tv: testTvDetail,
              tvState: RequestState.Loaded,
              recommendationState: RequestState.Error,
              message: 'Server Failure',
            ),
          ],
      verify: (_) {
        verify(mockGetTvDetail.execute(tId));
        verify(mockGetTvRecommendations.execute(tId));
      },
    );
  });

  group('LoadTvWatchlistStatus', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'should emit watchlist status true when tv is in watchlist',
      build: () {
        when(
          mockGetTvWatchListStatus.execute(tId),
        ).thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadTvWatchlistStatus(tId)),
      expect: () => [const TvDetailState(isAddedToWatchlist: true)],
      verify: (_) {
        verify(mockGetTvWatchListStatus.execute(tId));
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'should emit watchlist status false when tv is not in watchlist',
      build: () {
        when(
          mockGetTvWatchListStatus.execute(tId),
        ).thenAnswer((_) async => false);
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadTvWatchlistStatus(tId)),
      expect: () => [const TvDetailState(isAddedToWatchlist: false)],
      verify: (_) {
        verify(mockGetTvWatchListStatus.execute(tId));
      },
    );
  });

  group('AddTvToWatchlist', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'should emit success message when tv is added to watchlist',
      build: () {
        when(
          mockSaveWatchlistTv.execute(testTvDetail),
        ).thenAnswer((_) async => const Right('Added to Watchlist'));
        when(
          mockGetTvWatchListStatus.execute(testTvDetail.id),
        ).thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(AddTvToWatchlist(testTvDetail)),
      expect:
          () => [
            const TvDetailState(watchlistMessage: 'Added to Watchlist'),
            const TvDetailState(
              watchlistMessage: 'Added to Watchlist',
              isAddedToWatchlist: true,
            ),
          ],
      verify: (_) {
        verify(mockSaveWatchlistTv.execute(testTvDetail));
        verify(mockGetTvWatchListStatus.execute(testTvDetail.id));
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'should emit failure message when add to watchlist fails',
      build: () {
        when(
          mockSaveWatchlistTv.execute(testTvDetail),
        ).thenAnswer((_) async => const Left(DatabaseFailure('Failed to add')));
        when(
          mockGetTvWatchListStatus.execute(testTvDetail.id),
        ).thenAnswer((_) async => false);
        return bloc;
      },
      act: (bloc) => bloc.add(AddTvToWatchlist(testTvDetail)),
      expect:
          () => [
            const TvDetailState(
              watchlistMessage: 'Failed to add',
              isAddedToWatchlist: false,
            ),
          ],
      verify: (_) {
        verify(mockSaveWatchlistTv.execute(testTvDetail));
        verify(mockGetTvWatchListStatus.execute(testTvDetail.id));
      },
    );
  });

  group('RemoveTvFromWatchlist', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'should emit success message when tv is removed from watchlist',
      build: () {
        when(
          mockRemoveWatchlistTv.execute(testTvDetail),
        ).thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(
          mockGetTvWatchListStatus.execute(testTvDetail.id),
        ).thenAnswer((_) async => false);
        return bloc;
      },
      act: (bloc) => bloc.add(RemoveTvFromWatchlist(testTvDetail)),
      expect:
          () => [
            const TvDetailState(
              watchlistMessage: 'Removed from Watchlist',
              isAddedToWatchlist: false,
            ),
          ],
      verify: (_) {
        verify(mockRemoveWatchlistTv.execute(testTvDetail));
        verify(mockGetTvWatchListStatus.execute(testTvDetail.id));
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'should emit failure message when remove from watchlist fails',
      build: () {
        when(mockRemoveWatchlistTv.execute(testTvDetail)).thenAnswer(
          (_) async => const Left(DatabaseFailure('Failed to remove')),
        );
        when(
          mockGetTvWatchListStatus.execute(testTvDetail.id),
        ).thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(RemoveTvFromWatchlist(testTvDetail)),
      expect:
          () => [
            const TvDetailState(watchlistMessage: 'Failed to remove'),
            const TvDetailState(
              watchlistMessage: 'Failed to remove',
              isAddedToWatchlist: true,
            ),
          ],
      verify: (_) {
        verify(mockRemoveWatchlistTv.execute(testTvDetail));
        verify(mockGetTvWatchListStatus.execute(testTvDetail.id));
      },
    );
  });

  group('Event Props', () {
    test('FetchTvDetail props should contain id', () {
      const event = FetchTvDetail(1);
      expect(event.props, [1]);
    });

    test('AddTvToWatchlist props should contain tv', () {
      final event = AddTvToWatchlist(testTvDetail);
      expect(event.props, [testTvDetail]);
    });

    test('RemoveTvFromWatchlist props should contain tv', () {
      final event = RemoveTvFromWatchlist(testTvDetail);
      expect(event.props, [testTvDetail]);
    });

    test('LoadTvWatchlistStatus props should contain id', () {
      const event = LoadTvWatchlistStatus(1);
      expect(event.props, [1]);
    });
  });
}
