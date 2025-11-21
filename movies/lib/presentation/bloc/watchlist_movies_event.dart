import 'package:equatable/equatable.dart';

abstract class WatchlistMoviesEvent extends Equatable {
  const WatchlistMoviesEvent();

  @override
  List<Object> get props => [];
}

class FetchWatchlistMoviesEvent extends WatchlistMoviesEvent {}
