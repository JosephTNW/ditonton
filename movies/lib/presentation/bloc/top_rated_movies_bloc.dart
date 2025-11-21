import 'package:core/utils/state_enum.dart';
import 'package:movies/domain/usecases/get_top_rated_movies.dart';
import 'package:movies/presentation/bloc/top_rated_movies_event.dart';
import 'package:movies/presentation/bloc/top_rated_movies_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedMoviesBloc
    extends Bloc<TopRatedMoviesEvent, TopRatedMoviesState> {
  final GetTopRatedMovies getTopRatedMovies;

  TopRatedMoviesBloc({required this.getTopRatedMovies})
    : super(const TopRatedMoviesState()) {
    on<FetchTopRatedMoviesEvent>(_onFetchTopRatedMovies);
  }

  Future<void> _onFetchTopRatedMovies(
    FetchTopRatedMoviesEvent event,
    Emitter<TopRatedMoviesState> emit,
  ) async {
    emit(state.copyWith(state: RequestState.Loading));

    final result = await getTopRatedMovies.execute();

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
