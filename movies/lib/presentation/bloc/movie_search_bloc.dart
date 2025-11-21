import 'package:core/utils/state_enum.dart';
import 'package:movies/domain/usecases/search_movies.dart';
import 'package:movies/presentation/bloc/movie_search_event.dart';
import 'package:movies/presentation/bloc/movie_search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final SearchMovies searchMovies;

  MovieSearchBloc({required this.searchMovies})
    : super(const MovieSearchState()) {
    on<OnQueryChanged>(
      _onQueryChanged,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }

  Future<void> _onQueryChanged(
    OnQueryChanged event,
    Emitter<MovieSearchState> emit,
  ) async {
    final query = event.query;

    if (query.isEmpty) {
      emit(state.copyWith(searchResult: [], state: RequestState.Empty));
      return;
    }

    emit(state.copyWith(state: RequestState.Loading));

    final result = await searchMovies.execute(query);

    result.fold(
      (failure) {
        emit(
          state.copyWith(state: RequestState.Error, message: failure.message),
        );
      },
      (data) {
        emit(state.copyWith(state: RequestState.Loaded, searchResult: data));
      },
    );
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
