part of 'main_bloc.dart';

@immutable
abstract class MainState {}

class MainInitial extends MainState {}

class MainInitializedState extends MainState {
  final MapController controller;

  MainInitializedState({required this.controller});
}