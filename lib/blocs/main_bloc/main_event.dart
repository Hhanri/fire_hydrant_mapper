part of 'main_bloc.dart';

@immutable
abstract class MainEvent {}

class MainInitializeEvent extends MainEvent {}

class LoadMapControllerEvent extends MainEvent{
  final GoogleMapController controller;

  LoadMapControllerEvent({required this.controller});
}

class AddLogEvent extends MainEvent {
  final BuildContext context;
  final LogModel log;
  AddLogEvent({required this.context, required this.log});
}

class AddTemporaryMarker extends MainEvent {
  final LatLng point;

  AddTemporaryMarker({required this.point});
}

class CenterCameraEvent extends MainEvent {}