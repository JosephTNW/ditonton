import 'package:core/utils/state_enum.dart';
import 'package:tv/domain/usecases/get_popular_tvs.dart';
import 'package:tv/presentation/bloc/popular_tvs_event.dart';
import 'package:tv/presentation/bloc/popular_tvs_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularTvsBloc extends Bloc<PopularTvsEvent, PopularTvsState> {
  final GetPopularTvs getPopularTvs;

  PopularTvsBloc({required this.getPopularTvs})
    : super(const PopularTvsState()) {
    on<FetchPopularTvsEvent>(_onFetchPopularTvs);
  }

  Future<void> _onFetchPopularTvs(
    FetchPopularTvsEvent event,
    Emitter<PopularTvsState> emit,
  ) async {
    emit(state.copyWith(state: RequestState.Loading));

    final result = await getPopularTvs.execute();

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
