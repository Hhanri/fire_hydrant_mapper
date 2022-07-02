import 'dart:async';

import 'package:fire_hydrant_mapper/models/fire_hydrant_log_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  Completer<GoogleMapController> controller = Completer();
  MainBloc() : super(MainInitial()) {
    

    on<MainInitializeEvent>((event, emit) {
      emit(MainInitializedState(logs: [FireHydrantLogModel.mockData]));
    });

    on<LoadMapControllerEvent>((event, emit) {
      controller.complete(event.controller);
    });
  }
}
