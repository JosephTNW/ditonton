import 'package:equatable/equatable.dart';

abstract class PopularTvsEvent extends Equatable {
  const PopularTvsEvent();

  @override
  List<Object> get props => [];
}

class FetchPopularTvsEvent extends PopularTvsEvent {}
