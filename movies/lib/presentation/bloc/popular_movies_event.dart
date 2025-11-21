import 'package:equatable/equatable.dart';

abstract class PopularMoviesEvent extends Equatable {
  const PopularMoviesEvent();

  @override
  List<Object> get props => [];
}

class FetchPopularMoviesEvent extends PopularMoviesEvent {}
