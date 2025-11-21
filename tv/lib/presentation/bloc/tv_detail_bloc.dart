import 'package:core/utils/state_enum.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:tv/domain/usecases/get_tv_watchlist_status.dart';
import 'package:tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:tv/domain/usecases/save_watchlist_tv.dart';
import 'package:tv/presentation/bloc/tv_detail_event.dart';
import 'package:tv/presentation/bloc/tv_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;
  final GetTvWatchListStatus getWatchListStatus;
  final SaveWatchlistTv saveWatchlist;
  final RemoveWatchlistTv removeWatchlist;

  TvDetailBloc({
    required this.getTvDetail,
    required this.getTvRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(const TvDetailState()) {
    on<FetchTvDetail>(_onFetchTvDetail);
    on<AddTvToWatchlist>(_onAddTvToWatchlist);
    on<RemoveTvFromWatchlist>(_onRemoveTvFromWatchlist);
    on<LoadTvWatchlistStatus>(_onLoadTvWatchlistStatus);
  }

  Future<void> _onFetchTvDetail(
    FetchTvDetail event,
    Emitter<TvDetailState> emit,
  ) async {
    emit(state.copyWith(tvState: RequestState.Loading));

    final detailResult = await getTvDetail.execute(event.id);
    final recommendationResult = await getTvRecommendations.execute(event.id);

    detailResult.fold(
      (failure) {
        emit(
          state.copyWith(tvState: RequestState.Error, message: failure.message),
        );
      },
      (tv) {
        emit(
          state.copyWith(
            tv: tv,
            tvState: RequestState.Loaded,
            recommendationState: RequestState.Loading,
          ),
        );

        recommendationResult.fold(
          (failure) {
            emit(
              state.copyWith(
                recommendationState: RequestState.Error,
                message: failure.message,
              ),
            );
          },
          (tvs) {
            emit(
              state.copyWith(
                recommendationState: RequestState.Loaded,
                tvRecommendations: tvs,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onAddTvToWatchlist(
    AddTvToWatchlist event,
    Emitter<TvDetailState> emit,
  ) async {
    final result = await saveWatchlist.execute(event.tv);

    await result.fold(
      (failure) async {
        emit(state.copyWith(watchlistMessage: failure.message));
      },
      (successMessage) async {
        emit(state.copyWith(watchlistMessage: successMessage));
      },
    );

    add(LoadTvWatchlistStatus(event.tv.id));
  }

  Future<void> _onRemoveTvFromWatchlist(
    RemoveTvFromWatchlist event,
    Emitter<TvDetailState> emit,
  ) async {
    final result = await removeWatchlist.execute(event.tv);

    await result.fold(
      (failure) async {
        emit(state.copyWith(watchlistMessage: failure.message));
      },
      (successMessage) async {
        emit(state.copyWith(watchlistMessage: successMessage));
      },
    );

    add(LoadTvWatchlistStatus(event.tv.id));
  }

  Future<void> _onLoadTvWatchlistStatus(
    LoadTvWatchlistStatus event,
    Emitter<TvDetailState> emit,
  ) async {
    final result = await getWatchListStatus.execute(event.id);
    emit(state.copyWith(isAddedToWatchlist: result));
  }
}
