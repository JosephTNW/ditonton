import 'package:movies/domain/entities/movie.dart';
import 'package:core/utils/state_enum.dart';
import 'package:equatable/equatable.dart';

class MovieSearchState extends Equatable {
  final List<Movie> searchResult;
  final RequestState state;
  final String message;

  const MovieSearchState({
    this.searchResult = const [],
    this.state = RequestState.Empty,
    this.message = '',
  });

  MovieSearchState copyWith({
    List<Movie>? searchResult,
    RequestState? state,
    String? message,
  }) {
    return MovieSearchState(
      searchResult: searchResult ?? this.searchResult,
      state: state ?? this.state,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [searchResult, state, message];
}
