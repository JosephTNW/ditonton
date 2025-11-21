import 'package:tv/domain/entities/tv.dart';
import 'package:core/utils/state_enum.dart';
import 'package:equatable/equatable.dart';

class WatchlistTvsState extends Equatable {
  final List<Tv> tvs;
  final RequestState state;
  final String message;

  const WatchlistTvsState({
    this.tvs = const [],
    this.state = RequestState.Empty,
    this.message = '',
  });

  WatchlistTvsState copyWith({
    List<Tv>? tvs,
    RequestState? state,
    String? message,
  }) {
    return WatchlistTvsState(
      tvs: tvs ?? this.tvs,
      state: state ?? this.state,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [tvs, state, message];
}
