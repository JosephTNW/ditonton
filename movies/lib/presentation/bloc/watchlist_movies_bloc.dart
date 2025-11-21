import 'package:core/utils/state_enum.dart';
import 'package:movies/domain/usecases/get_watchlist_movies.dart';
import 'package:movies/presentation/bloc/watchlist_movies_event.dart';
import 'package:movies/presentation/bloc/watchlist_movies_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistMoviesBloc
    extends Bloc<WatchlistMoviesEvent, WatchlistMoviesState> {
  final GetWatchlistMovies getWatchlistMovies;

  WatchlistMoviesBloc({required this.getWatchlistMovies})
    : super(const WatchlistMoviesState()) {
    on<FetchWatchlistMoviesEvent>(_onFetchWatchlistMovies);
  }

  Future<void> _onFetchWatchlistMovies(
    FetchWatchlistMoviesEvent event,
    Emitter<WatchlistMoviesState> emit,
  ) async {
    emit(state.copyWith(state: RequestState.Loading));

    final result = await getWatchlistMovies.execute();

    result.fold(
      (failure) {
        emit(
          state.copyWith(state: RequestState.Error, message: failure.message),
        );
      },
      (data) {
        emit(state.copyWith(state: RequestState.Loaded, movies: data));
      },
    );
  }
}
