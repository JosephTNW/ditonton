import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:tv/presentation/bloc/top_rated_tvs_bloc.dart';
import 'package:tv/presentation/bloc/top_rated_tvs_event.dart';
import 'package:tv/presentation/bloc/top_rated_tvs_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_tv_objects.dart';
import 'top_rated_tvs_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTvs])
void main() {
  late TopRatedTvsBloc bloc;
  late MockGetTopRatedTvs mockGetTopRatedTvs;

  setUp(() {
    mockGetTopRatedTvs = MockGetTopRatedTvs();
    bloc = TopRatedTvsBloc(getTopRatedTvs: mockGetTopRatedTvs);
  });

  test('initial state should be empty', () {
    expect(bloc.state, const TopRatedTvsState());
    expect(bloc.state.state, RequestState.Empty);
  });

  blocTest<TopRatedTvsBloc, TopRatedTvsState>(
    'should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(
        mockGetTopRatedTvs.execute(),
      ).thenAnswer((_) async => Right(testTvList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTvsEvent()),
    expect:
        () => [
          const TopRatedTvsState(state: RequestState.Loading),
          TopRatedTvsState(state: RequestState.Loaded, tvs: testTvList),
        ],
    verify: (_) {
      verify(mockGetTopRatedTvs.execute());
    },
  );

  blocTest<TopRatedTvsBloc, TopRatedTvsState>(
    'should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(
        mockGetTopRatedTvs.execute(),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTvsEvent()),
    expect:
        () => [
          const TopRatedTvsState(state: RequestState.Loading),
          const TopRatedTvsState(
            state: RequestState.Error,
            message: 'Server Failure',
          ),
        ],
    verify: (_) {
      verify(mockGetTopRatedTvs.execute());
    },
  );
}
