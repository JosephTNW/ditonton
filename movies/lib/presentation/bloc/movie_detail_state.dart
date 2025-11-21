import 'package:movies/domain/entities/movie.dart';
import 'package:movies/domain/entities/movie_detail.dart';
import 'package:core/utils/state_enum.dart';
import 'package:equatable/equatable.dart';

class MovieDetailState extends Equatable {
  final MovieDetail? movie;
  final RequestState movieState;
  final List<Movie> movieRecommendations;
  final RequestState recommendationState;
  final String message;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const MovieDetailState({
    this.movie,
    this.movieState = RequestState.Empty,
    this.movieRecommendations = const [],
    this.recommendationState = RequestState.Empty,
    this.message = '',
    this.isAddedToWatchlist = false,
    this.watchlistMessage = '',
  });

  MovieDetailState copyWith({
    MovieDetail? movie,
    RequestState? movieState,
    List<Movie>? movieRecommendations,
    RequestState? recommendationState,
    String? message,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return MovieDetailState(
      movie: movie ?? this.movie,
      movieState: movieState ?? this.movieState,
      movieRecommendations: movieRecommendations ?? this.movieRecommendations,
      recommendationState: recommendationState ?? this.recommendationState,
      message: message ?? this.message,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
    movie,
    movieState,
    movieRecommendations,
    recommendationState,
    message,
    isAddedToWatchlist,
    watchlistMessage,
  ];
}
