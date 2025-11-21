import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:tv/domain/usecases/search_tvs.dart';
import 'package:tv/presentation/bloc/tv_search_bloc.dart';
import 'package:tv/presentation/bloc/tv_search_event.dart';
import 'package:tv/presentation/bloc/tv_search_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_tv_objects.dart';
import 'tv_search_bloc_test.mocks.dart';

@GenerateMocks([SearchTvs])
void main() {
  late TvSearchBloc bloc;
  late MockSearchTvs mockSearchTvs;

  setUp(() {
    mockSearchTvs = MockSearchTvs();
    bloc = TvSearchBloc(searchTvs: mockSearchTvs);
  });

  const tQuery = 'Breaking Bad';

  test('initial state should be empty', () {
    expect(bloc.state, const TvSearchState());
    expect(bloc.state.state, RequestState.Empty);
  });

  blocTest<TvSearchBloc, TvSearchState>(
    'should emit [Empty] when query is empty',
    build: () => bloc,
    act: (bloc) => bloc.add(const OnTvQueryChanged('')),
    wait: const Duration(milliseconds: 500),
    expect:
        () => [
          const TvSearchState(searchResult: [], state: RequestState.Empty),
        ],
  );

  blocTest<TvSearchBloc, TvSearchState>(
    'should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(
        mockSearchTvs.execute(tQuery),
      ).thenAnswer((_) async => Right(testTvList));
      return bloc;
    },
    act: (bloc) => bloc.add(const OnTvQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect:
        () => [
          const TvSearchState(state: RequestState.Loading),
          TvSearchState(state: RequestState.Loaded, searchResult: testTvList),
        ],
    verify: (_) {
      verify(mockSearchTvs.execute(tQuery));
    },
  );

  blocTest<TvSearchBloc, TvSearchState>(
    'should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(
        mockSearchTvs.execute(tQuery),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(const OnTvQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect:
        () => [
          const TvSearchState(state: RequestState.Loading),
          const TvSearchState(
            state: RequestState.Error,
            message: 'Server Failure',
          ),
        ],
    verify: (_) {
      verify(mockSearchTvs.execute(tQuery));
    },
  );
}
