import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:core/utils/state_enum.dart';
import 'package:equatable/equatable.dart';

class TvDetailState extends Equatable {
  final TvDetail? tv;
  final RequestState tvState;
  final List<Tv> tvRecommendations;
  final RequestState recommendationState;
  final String message;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const TvDetailState({
    this.tv,
    this.tvState = RequestState.Empty,
    this.tvRecommendations = const [],
    this.recommendationState = RequestState.Empty,
    this.message = '',
    this.isAddedToWatchlist = false,
    this.watchlistMessage = '',
  });

  TvDetailState copyWith({
    TvDetail? tv,
    RequestState? tvState,
    List<Tv>? tvRecommendations,
    RequestState? recommendationState,
    String? message,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return TvDetailState(
      tv: tv ?? this.tv,
      tvState: tvState ?? this.tvState,
      tvRecommendations: tvRecommendations ?? this.tvRecommendations,
      recommendationState: recommendationState ?? this.recommendationState,
      message: message ?? this.message,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
    tv,
    tvState,
    tvRecommendations,
    recommendationState,
    message,
    isAddedToWatchlist,
    watchlistMessage,
  ];
}
