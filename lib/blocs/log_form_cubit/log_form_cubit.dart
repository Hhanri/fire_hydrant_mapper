import 'dart:async';

import 'package:fire_hydrant_mapper/models/fire_hydrant_archive_model.dart';
import 'package:fire_hydrant_mapper/models/fire_hydrant_log_model.dart';
import 'package:fire_hydrant_mapper/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

part 'log_form_state.dart';

class LogFormCubit extends Cubit<LogFormState> {
  final FireHydrantLogModel initialLog;
  final FirebaseService firebaseService;
  final StreamController<List<FireHydrantArchiveModel>> archivesStreamController = StreamController<List<FireHydrantArchiveModel>>();
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
      .getArchivesStream(documentId: initialLog.documentId)
      .listen((event) {
        archivesStreamController.sink.add(
          event.docs.map((doc) {
            return FireHydrantArchiveModel.fromJson(doc.data());
          }).toList()
        );
      });
  }

  void editLog() async {
    final newGeoFirePoint = GeoFirePoint(double.parse(latitudeController.text), double.parse(longitudeController.text));
    final newDocumentId = newGeoFirePoint.hash;
    final String newStreetName = streetNameController.text;

    final FireHydrantLogModel newLog = FireHydrantLogModel(
      documentId: newDocumentId,
      geoPoint: newGeoFirePoint,
      streetName: newStreetName
    );

    firebaseService.updateLog(oldLog: initialLog, newLog: newLog);
  }

  void deleteLog() async {
    await firebaseService.deleteLog(documentId: initialLog.documentId);
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
