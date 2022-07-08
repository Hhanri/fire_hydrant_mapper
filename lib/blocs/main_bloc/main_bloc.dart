import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_hydrant_mapper/models/fire_hydrant_log_model.dart';
import 'package:fire_hydrant_mapper/services/firebase_service.dart';
import 'package:fire_hydrant_mapper/services/location_service.dart';
import 'package:fire_hydrant_mapper/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final FirebaseService firebaseService;
  Completer<GoogleMapController> mapController = Completer();
  final StreamController<FireHydrantLogModel> tempLogStream = StreamController<FireHydrantLogModel>.broadcast();
  final StreamController<List<FireHydrantLogModel>> logsController = StreamController<List<FireHydrantLogModel>>();
  MainBloc({required this.firebaseService}) : super(MainInitial()) {

    void listenToLogs() {
      firebaseService.getLogsStream().listen((QuerySnapshot<Map<String, dynamic>> event) async {
        final List<Map<String, dynamic>> docs = event.docs.map((doc) => doc.data()).toList();
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

    on<AddLogEvent>((event, emit) async {
      await firebaseService.addLog(logModel: event.log);
    });

    on<AddTemporaryMarker>((event, emit) async {
      tempLogStream.add(FireHydrantLogModel.emptyLog(geoFirePoint: event.point.geoFireFromLatLng()));
      print("NEW TEMP LOG");
    });

    on<CenterCameraEvent>((event, emit) async {
      if (await LocationService.getLocationPermission()) {
        final GoogleMapController googleMapController = await mapController.future;
        final Position position = await LocationService.getLocation();
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: position.latLngFromPosition(), zoom: 18 )
          )
        );
      } else {
        print("NO LOCATION PERMISSION");
      }
    });
  }
  @override
  Future<void> close() {
    logsController.close();
    tempLogStream.close();
    mapController.future.then((value) => value.dispose());
    return super.close();
  }
}
