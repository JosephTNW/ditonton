import 'package:tv/domain/entities/tv.dart';
import 'package:core/utils/state_enum.dart';
import 'package:equatable/equatable.dart';

class OnTheAirTvsState extends Equatable {
  final List<Tv> tvs;
  final RequestState state;
  final String message;

  const OnTheAirTvsState({
    this.tvs = const [],
    this.state = RequestState.Empty,
    this.message = '',
  });

  OnTheAirTvsState copyWith({
    List<Tv>? tvs,
    RequestState? state,
    String? message,
  }) {
    return OnTheAirTvsState(
      tvs: tvs ?? this.tvs,
      state: state ?? this.state,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [tvs, state, message];
}
