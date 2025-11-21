import 'package:core/utils/state_enum.dart';
import 'package:tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:tv/presentation/bloc/top_rated_tvs_event.dart';
import 'package:tv/presentation/bloc/top_rated_tvs_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedTvsBloc extends Bloc<TopRatedTvsEvent, TopRatedTvsState> {
  final GetTopRatedTvs getTopRatedTvs;

  TopRatedTvsBloc({required this.getTopRatedTvs})
    : super(const TopRatedTvsState()) {
    on<FetchTopRatedTvsEvent>(_onFetchTopRatedTvs);
  }

  Future<void> _onFetchTopRatedTvs(
    FetchTopRatedTvsEvent event,
    Emitter<TopRatedTvsState> emit,
  ) async {
    emit(state.copyWith(state: RequestState.Loading));

    final result = await getTopRatedTvs.execute();

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
