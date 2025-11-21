import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:tv/domain/usecases/get_on_the_air_tvs.dart';
import 'package:tv/presentation/bloc/on_the_air_tvs_bloc.dart';
import 'package:tv/presentation/bloc/on_the_air_tvs_event.dart';
import 'package:tv/presentation/bloc/on_the_air_tvs_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_tv_objects.dart';
import 'on_the_air_tvs_bloc_test.mocks.dart';

@GenerateMocks([GetOnTheAirTvs])
void main() {
  late OnTheAirTvsBloc bloc;
  late MockGetOnTheAirTvs mockGetOnTheAirTvs;

  setUp(() {
    mockGetOnTheAirTvs = MockGetOnTheAirTvs();
    bloc = OnTheAirTvsBloc(getOnTheAirTvs: mockGetOnTheAirTvs);
  });

  test('initial state should be empty', () {
    expect(bloc.state, const OnTheAirTvsState());
    expect(bloc.state.state, RequestState.Empty);
  });

  blocTest<OnTheAirTvsBloc, OnTheAirTvsState>(
    'should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(
        mockGetOnTheAirTvs.execute(),
      ).thenAnswer((_) async => Right(testTvList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchOnTheAirTvsEvent()),
    expect:
        () => [
          const OnTheAirTvsState(state: RequestState.Loading),
          OnTheAirTvsState(state: RequestState.Loaded, tvs: testTvList),
        ],
    verify: (_) {
      verify(mockGetOnTheAirTvs.execute());
    },
  );

  blocTest<OnTheAirTvsBloc, OnTheAirTvsState>(
    'should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(
        mockGetOnTheAirTvs.execute(),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchOnTheAirTvsEvent()),
    expect:
        () => [
          const OnTheAirTvsState(state: RequestState.Loading),
          const OnTheAirTvsState(
            state: RequestState.Error,
            message: 'Server Failure',
          ),
        ],
    verify: (_) {
      verify(mockGetOnTheAirTvs.execute());
    },
  );
}
