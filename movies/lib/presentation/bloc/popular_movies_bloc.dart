import 'package:core/utils/state_enum.dart';
import 'package:movies/domain/usecases/get_popular_movies.dart';
import 'package:movies/presentation/bloc/popular_movies_event.dart';
import 'package:movies/presentation/bloc/popular_movies_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularMoviesBloc extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  final GetPopularMovies getPopularMovies;

  PopularMoviesBloc({required this.getPopularMovies})
    : super(const PopularMoviesState()) {
    on<FetchPopularMoviesEvent>(_onFetchPopularMovies);
  }

  Future<void> _onFetchPopularMovies(
    FetchPopularMoviesEvent event,
    Emitter<PopularMoviesState> emit,
  ) async {
    emit(state.copyWith(state: RequestState.Loading));

    final result = await getPopularMovies.execute();

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
