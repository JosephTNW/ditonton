import 'package:tv/domain/entities/tv.dart';
import 'package:core/utils/state_enum.dart';
import 'package:equatable/equatable.dart';

class TvListState extends Equatable {
  final List<Tv> onTheAirTvs;
  final RequestState onTheAirState;
  final List<Tv> popularTvs;
  final RequestState popularTvsState;
  final List<Tv> topRatedTvs;
  final RequestState topRatedTvsState;
  final String message;

  const TvListState({
    this.onTheAirTvs = const [],
    this.onTheAirState = RequestState.Empty,
    this.popularTvs = const [],
    this.popularTvsState = RequestState.Empty,
    this.topRatedTvs = const [],
    this.topRatedTvsState = RequestState.Empty,
    this.message = '',
  });

  TvListState copyWith({
    List<Tv>? onTheAirTvs,
    RequestState? onTheAirState,
    List<Tv>? popularTvs,
    RequestState? popularTvsState,
    List<Tv>? topRatedTvs,
    RequestState? topRatedTvsState,
    String? message,
  }) {
    return TvListState(
      onTheAirTvs: onTheAirTvs ?? this.onTheAirTvs,
      onTheAirState: onTheAirState ?? this.onTheAirState,
      popularTvs: popularTvs ?? this.popularTvs,
      popularTvsState: popularTvsState ?? this.popularTvsState,
      topRatedTvs: topRatedTvs ?? this.topRatedTvs,
      topRatedTvsState: topRatedTvsState ?? this.topRatedTvsState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
    onTheAirTvs,
    onTheAirState,
    popularTvs,
    popularTvsState,
    topRatedTvs,
    topRatedTvsState,
    message,
  ];
}
