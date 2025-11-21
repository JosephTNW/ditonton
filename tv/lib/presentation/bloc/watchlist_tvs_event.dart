import 'package:equatable/equatable.dart';

abstract class WatchlistTvsEvent extends Equatable {
  const WatchlistTvsEvent();

  @override
  List<Object> get props => [];
}

class FetchWatchlistTvsEvent extends WatchlistTvsEvent {}
