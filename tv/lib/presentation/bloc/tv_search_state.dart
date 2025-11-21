import 'package:tv/domain/entities/tv.dart';
import 'package:core/utils/state_enum.dart';
import 'package:equatable/equatable.dart';

class TvSearchState extends Equatable {
  final List<Tv> searchResult;
  final RequestState state;
  final String message;

  const TvSearchState({
    this.searchResult = const [],
    this.state = RequestState.Empty,
    this.message = '',
  });

  TvSearchState copyWith({
    List<Tv>? searchResult,
    RequestState? state,
    String? message,
  }) {
    return TvSearchState(
      searchResult: searchResult ?? this.searchResult,
      state: state ?? this.state,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [searchResult, state, message];
}
