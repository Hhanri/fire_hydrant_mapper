part of 'main_bloc.dart';

@immutable
abstract class MainEvent {}

class MainInitializeEvent extends MainEvent {}

class LoadMapControllerEvent extends MainEvent{
  final GoogleMapController controller;

  LoadMapControllerEvent({required this.controller});
}

class AddPositionEvent extends MainEvent {
  final BuildContext context;

  AddPositionEvent({required this.context});
}