import 'package:core/utils/state_enum.dart';
import 'package:movies/domain/usecases/get_now_playing_movies.dart';
import 'package:movies/presentation/bloc/now_playing_movies_event.dart';
import 'package:movies/presentation/bloc/now_playing_movies_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NowPlayingMoviesBloc
    extends Bloc<NowPlayingMoviesEvent, NowPlayingMoviesState> {
  final GetNowPlayingMovies getNowPlayingMovies;

  NowPlayingMoviesBloc({required this.getNowPlayingMovies})
    : super(const NowPlayingMoviesState()) {
    on<FetchNowPlayingMoviesEvent>(_onFetchNowPlayingMovies);
  }

  Future<void> _onFetchNowPlayingMovies(
    FetchNowPlayingMoviesEvent event,
    Emitter<NowPlayingMoviesState> emit,
  ) async {
    emit(state.copyWith(state: RequestState.Loading));

    final result = await getNowPlayingMovies.execute();

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
