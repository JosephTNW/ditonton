import 'package:equatable/equatable.dart';

abstract class TopRatedTvsEvent extends Equatable {
  const TopRatedTvsEvent();

  @override
  List<Object> get props => [];
}

class FetchTopRatedTvsEvent extends TopRatedTvsEvent {}
