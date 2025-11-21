import 'package:equatable/equatable.dart';

abstract class TvListEvent extends Equatable {
  const TvListEvent();

  @override
  List<Object> get props => [];
}

class FetchOnTheAirTvs extends TvListEvent {}

class FetchPopularTvs extends TvListEvent {}

class FetchTopRatedTvs extends TvListEvent {}
