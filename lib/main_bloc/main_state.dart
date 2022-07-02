part of 'main_bloc.dart';

@immutable
abstract class MainState {}

class MainInitial extends MainState {}

class MainInitializedState extends MainState {
  final List<FireHydrantLogModel> logs;

  MainInitializedState({required this.logs});
}