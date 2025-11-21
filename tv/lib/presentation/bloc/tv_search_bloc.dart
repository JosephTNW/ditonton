import 'package:core/utils/state_enum.dart';
import 'package:tv/domain/usecases/search_tvs.dart';
import 'package:tv/presentation/bloc/tv_search_event.dart';
import 'package:tv/presentation/bloc/tv_search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class TvSearchBloc extends Bloc<TvSearchEvent, TvSearchState> {
  final SearchTvs searchTvs;

  TvSearchBloc({required this.searchTvs}) : super(const TvSearchState()) {
    on<OnTvQueryChanged>(
      _onQueryChanged,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }

  Future<void> _onQueryChanged(
    OnTvQueryChanged event,
    Emitter<TvSearchState> emit,
  ) async {
    final query = event.query;

    if (query.isEmpty) {
      emit(state.copyWith(searchResult: [], state: RequestState.Empty));
      return;
    }

    emit(state.copyWith(state: RequestState.Loading));

    final result = await searchTvs.execute(query);

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
