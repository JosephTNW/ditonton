import 'package:core/utils/state_enum.dart';
import 'package:movies/domain/usecases/get_movie_detail.dart';
import 'package:movies/domain/usecases/get_movie_recommendations.dart';
import 'package:movies/domain/usecases/get_movie_watchlist_status.dart';
import 'package:movies/domain/usecases/remove_watchlist_movie.dart';
import 'package:movies/domain/usecases/save_watchlist_movie.dart';
import 'package:movies/presentation/bloc/movie_detail_event.dart';
import 'package:movies/presentation/bloc/movie_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlistMovie saveWatchlist;
  final RemoveWatchlistMovie removeWatchlist;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(const MovieDetailState()) {
    on<FetchMovieDetail>(_onFetchMovieDetail);
    on<AddMovieToWatchlist>(_onAddMovieToWatchlist);
    on<RemoveMovieFromWatchlist>(_onRemoveMovieFromWatchlist);
    on<LoadMovieWatchlistStatus>(_onLoadMovieWatchlistStatus);
  }

  Future<void> _onFetchMovieDetail(
    FetchMovieDetail event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(state.copyWith(movieState: RequestState.Loading));

    final detailResult = await getMovieDetail.execute(event.id);
    final recommendationResult = await getMovieRecommendations.execute(
      event.id,
    );

    detailResult.fold(
      (failure) {
        emit(
          state.copyWith(
            movieState: RequestState.Error,
            message: failure.message,
          ),
        );
      },
      (movie) {
        emit(
          state.copyWith(
            movie: movie,
            movieState: RequestState.Loaded,
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
          (movies) {
            emit(
              state.copyWith(
                recommendationState: RequestState.Loaded,
                movieRecommendations: movies,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onAddMovieToWatchlist(
    AddMovieToWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    final result = await saveWatchlist.execute(event.movie);

    await result.fold(
      (failure) async {
        final status = await getWatchListStatus.execute(event.movie.id);
        emit(
          state.copyWith(
            watchlistMessage: failure.message,
            isAddedToWatchlist: status,
          ),
        );
      },
      (successMessage) async {
        final status = await getWatchListStatus.execute(event.movie.id);
        emit(
          state.copyWith(
            watchlistMessage: successMessage,
            isAddedToWatchlist: status,
          ),
        );
      },
    );
  }

  Future<void> _onRemoveMovieFromWatchlist(
    RemoveMovieFromWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    final result = await removeWatchlist.execute(event.movie);

    await result.fold(
      (failure) async {
        final status = await getWatchListStatus.execute(event.movie.id);
        emit(state.copyWith(watchlistMessage: failure.message, isAddedToWatchlist: status));
      },
      (successMessage) async {
        final status = await getWatchListStatus.execute(event.movie.id);
        emit(
          state.copyWith(
            watchlistMessage: successMessage,
            isAddedToWatchlist: status,
          ),
        );
      },
    );
  }

  Future<void> _onLoadMovieWatchlistStatus(
    LoadMovieWatchlistStatus event,
    Emitter<MovieDetailState> emit,
  ) async {
    final result = await getWatchListStatus.execute(event.id);
    emit(state.copyWith(isAddedToWatchlist: result));
  }
}
