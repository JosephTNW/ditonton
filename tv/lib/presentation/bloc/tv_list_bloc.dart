import 'package:core/utils/state_enum.dart';
import 'package:tv/domain/usecases/get_on_the_air_tvs.dart';
import 'package:tv/domain/usecases/get_popular_tvs.dart';
import 'package:tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:tv/presentation/bloc/tv_list_event.dart';
import 'package:tv/presentation/bloc/tv_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TvListBloc extends Bloc<TvListEvent, TvListState> {
  final GetOnTheAirTvs getOnTheAirTvs;
  final GetPopularTvs getPopularTvs;
  final GetTopRatedTvs getTopRatedTvs;

  TvListBloc({
    required this.getOnTheAirTvs,
    required this.getPopularTvs,
    required this.getTopRatedTvs,
  }) : super(const TvListState()) {
    on<FetchOnTheAirTvs>(_onFetchOnTheAirTvs);
    on<FetchPopularTvs>(_onFetchPopularTvs);
    on<FetchTopRatedTvs>(_onFetchTopRatedTvs);
  }

  Future<void> _onFetchOnTheAirTvs(
    FetchOnTheAirTvs event,
    Emitter<TvListState> emit,
  ) async {
    emit(state.copyWith(onTheAirState: RequestState.Loading));

    final result = await getOnTheAirTvs.execute();
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            onTheAirState: RequestState.Error,
            message: failure.message,
          ),
        );
      },
      (tvsData) {
        emit(
          state.copyWith(
            onTheAirState: RequestState.Loaded,
            onTheAirTvs: tvsData,
          ),
        );
      },
    );
  }

  Future<void> _onFetchPopularTvs(
    FetchPopularTvs event,
    Emitter<TvListState> emit,
  ) async {
    emit(state.copyWith(popularTvsState: RequestState.Loading));

    final result = await getPopularTvs.execute();
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            popularTvsState: RequestState.Error,
            message: failure.message,
          ),
        );
      },
      (tvsData) {
        emit(
          state.copyWith(
            popularTvsState: RequestState.Loaded,
            popularTvs: tvsData,
          ),
        );
      },
    );
  }

  Future<void> _onFetchTopRatedTvs(
    FetchTopRatedTvs event,
    Emitter<TvListState> emit,
  ) async {
    emit(state.copyWith(topRatedTvsState: RequestState.Loading));

    final result = await getTopRatedTvs.execute();
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            topRatedTvsState: RequestState.Error,
            message: failure.message,
          ),
        );
      },
      (tvsData) {
        emit(
          state.copyWith(
            topRatedTvsState: RequestState.Loaded,
            topRatedTvs: tvsData,
          ),
        );
      },
    );
  }
}
