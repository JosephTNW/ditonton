import 'package:core/utils/state_enum.dart';
import 'package:tv/domain/usecases/get_on_the_air_tvs.dart';
import 'package:tv/presentation/bloc/on_the_air_tvs_event.dart';
import 'package:tv/presentation/bloc/on_the_air_tvs_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnTheAirTvsBloc extends Bloc<OnTheAirTvsEvent, OnTheAirTvsState> {
  final GetOnTheAirTvs getOnTheAirTvs;

  OnTheAirTvsBloc({required this.getOnTheAirTvs})
    : super(const OnTheAirTvsState()) {
    on<FetchOnTheAirTvsEvent>(_onFetchOnTheAirTvs);
  }

  Future<void> _onFetchOnTheAirTvs(
    FetchOnTheAirTvsEvent event,
    Emitter<OnTheAirTvsState> emit,
  ) async {
    emit(state.copyWith(state: RequestState.Loading));

    final result = await getOnTheAirTvs.execute();

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
