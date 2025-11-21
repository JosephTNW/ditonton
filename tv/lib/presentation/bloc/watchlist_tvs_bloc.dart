import 'package:core/utils/state_enum.dart';
import 'package:tv/domain/usecases/get_watchlist_tvs.dart';
import 'package:tv/presentation/bloc/watchlist_tvs_event.dart';
import 'package:tv/presentation/bloc/watchlist_tvs_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistTvsBloc extends Bloc<WatchlistTvsEvent, WatchlistTvsState> {
  final GetWatchlistTvs getWatchlistTvs;

  WatchlistTvsBloc({required this.getWatchlistTvs})
    : super(const WatchlistTvsState()) {
    on<FetchWatchlistTvsEvent>(_onFetchWatchlistTvs);
  }

  Future<void> _onFetchWatchlistTvs(
    FetchWatchlistTvsEvent event,
    Emitter<WatchlistTvsState> emit,
  ) async {
    emit(state.copyWith(state: RequestState.Loading));

    final result = await getWatchlistTvs.execute();

    result.fold(
      (failure) {
        emit(
          state.copyWith(state: RequestState.Error, message: failure.message),
        );
      },
      (data) {
        emit(state.copyWith(state: RequestState.Loaded, tvs: data));
      },
    );
  }
}
