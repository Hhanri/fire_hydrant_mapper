import 'dart:async';

import 'package:fire_hydrant_mapper/models/archive_model.dart';
import 'package:fire_hydrant_mapper/models/log_model.dart';
import 'package:fire_hydrant_mapper/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

part 'log_form_state.dart';

class LogFormCubit extends Cubit<LogFormState> {
  final LogModel initialLog;
  final FirebaseService firebaseService;
  final StreamController<List<ArchiveModel>> archivesStreamController = StreamController<List<ArchiveModel>>();
  LogFormCubit({required this.initialLog, required this.firebaseService}) : super(LogFormInitial());

  final TextEditingController streetNameController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();

  void init() {
    streetNameController.text = initialLog.streetName;
    latitudeController.text = initialLog.geoPoint.latitude.toString();
    longitudeController.text = initialLog.geoPoint.longitude.toString();
    getArchivesStream();
  }

  void getArchivesStream() {
    firebaseService
      .getArchivesStream(logId: initialLog.logId)
      .listen((event) {
        archivesStreamController.sink.add(
          event.docs.map((doc) {
            return ArchiveModel.fromJson(doc.data());
          }).toList()
        );
      });
  }

  void editLog() async {
    final newGeoFirePoint = GeoFirePoint(double.parse(latitudeController.text), double.parse(longitudeController.text));
    final newLogId = newGeoFirePoint.hash;
    final String newStreetName = streetNameController.text;

    final LogModel newLog = LogModel(
      logId: newLogId,
      geoPoint: newGeoFirePoint,
      streetName: newStreetName
    );

    firebaseService.updateLog(oldLog: initialLog, newLog: newLog);
  }

  void deleteLog() async {
    await firebaseService.deleteLog(logId: initialLog.logId);
  }

  @override
  Future<void> close () {
    streetNameController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    archivesStreamController.close();
    return super.close();
  }
}
