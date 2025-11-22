import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:tv/domain/usecases/get_popular_tvs.dart';
import 'package:tv/presentation/bloc/popular_tvs_bloc.dart';
import 'package:tv/presentation/bloc/popular_tvs_event.dart';
import 'package:tv/presentation/bloc/popular_tvs_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/tv/dummy_tv_objects.dart';
import 'popular_tvs_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTvs])
void main() {
  late PopularTvsBloc bloc;
  late MockGetPopularTvs mockGetPopularTvs;

  setUp(() {
    mockGetPopularTvs = MockGetPopularTvs();
    bloc = PopularTvsBloc(getPopularTvs: mockGetPopularTvs);
  });

  test('initial state should be empty', () {
    expect(bloc.state, const PopularTvsState());
    expect(bloc.state.state, RequestState.Empty);
  });

  blocTest<PopularTvsBloc, PopularTvsState>(
    'should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(
        mockGetPopularTvs.execute(),
      ).thenAnswer((_) async => Right(testTvList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchPopularTvsEvent()),
    expect:
        () => [
          const PopularTvsState(state: RequestState.Loading),
          PopularTvsState(state: RequestState.Loaded, tvs: testTvList),
        ],
    verify: (_) {
      verify(mockGetPopularTvs.execute());
    },
  );

  blocTest<PopularTvsBloc, PopularTvsState>(
    'should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(
        mockGetPopularTvs.execute(),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchPopularTvsEvent()),
    expect:
        () => [
          const PopularTvsState(state: RequestState.Loading),
          const PopularTvsState(
            state: RequestState.Error,
            message: 'Server Failure',
          ),
        ],
    verify: (_) {
      verify(mockGetPopularTvs.execute());
    },
  );
}
