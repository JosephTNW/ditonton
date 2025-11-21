import 'package:equatable/equatable.dart';

abstract class OnTheAirTvsEvent extends Equatable {
  const OnTheAirTvsEvent();

  @override
  List<Object> get props => [];
}

class FetchOnTheAirTvsEvent extends OnTheAirTvsEvent {}
