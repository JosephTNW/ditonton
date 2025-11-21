import 'package:movies/domain/entities/movie.dart';
import 'package:core/utils/state_enum.dart';
import 'package:equatable/equatable.dart';

class WatchlistMoviesState extends Equatable {
  final List<Movie> movies;
  final RequestState state;
  final String message;

  const WatchlistMoviesState({
    this.movies = const [],
    this.state = RequestState.Empty,
    this.message = '',
  });

  WatchlistMoviesState copyWith({
    List<Movie>? movies,
    RequestState? state,
    String? message,
  }) {
    return WatchlistMoviesState(
      movies: movies ?? this.movies,
      state: state ?? this.state,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [movies, state, message];
}
