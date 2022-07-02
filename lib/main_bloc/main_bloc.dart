import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map/map.dart';
import 'package:latlng/latlng.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final MapController controller = MapController(
    location: const LatLng(35.674, 51.41)
  );

  MainBloc() : super(MainInitial()) {
    

    on<MainInitializeEvent>((event, emit) {
      emit(MainInitializedState(controller: controller));
    });
  }
  @override
  Future<void> close() {
    controller.dispose();
    return super.close();
  }
}
