import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_hydrant_mapper/models/fire_hydrant_log_model.dart';
import 'package:fire_hydrant_mapper/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final FirebaseService firebaseService;
  Completer<GoogleMapController> mapController = Completer();
  StreamController<List<FireHydrantLogModel>> logsController = StreamController<List<FireHydrantLogModel>>();
  MainBloc(this.firebaseService) : super(MainInitial()) {

    void listenToLogs() {
      firebaseService.getLogsStream().listen((QuerySnapshot<Map<String, dynamic>> event) async {
        final List<Map<String, dynamic>> docs = event.docs.map((e) => e.data()).toList();
        final List<FireHydrantLogModel> logs = docs.map((log) => FireHydrantLogModel.fromJson(log)).toList();
        logsController.sink.add(logs);
      });
    }



    on<MainInitializeEvent>((event, emit) async {
      emit(MainInitializedState());
      listenToLogs();
    });

    on<LoadMapControllerEvent>((event, emit) {
      mapController.complete(event.controller);
    });

    on<AddPositionEvent>((event, emit) async {
      await firebaseService.addLocalPoint();
    });
  }
  @override
  Future<void> close() {
    logsController.close();
    mapController.future.then((value) => value.dispose());
    return super.close();
  }
}
