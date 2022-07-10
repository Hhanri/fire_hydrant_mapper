import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
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
  LogFormCubit({required this.initialLog, required this.firebaseService}) : super(const LogFormInitial(isLoading: false));

  final TextEditingController streetNameController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();

  void init() {
    streetNameController.text = initialLog.streetName;
    latitudeController.text = initialLog.geoPoint.latitude.toString();
    longitudeController.text = initialLog.geoPoint.longitude.toString();
    archivesStreamController.addStream(firebaseService.getArchivesStream(parentLogId: initialLog.logId));
  }

  Future<void> editLog() async {
    final newGeoFirePoint = GeoFirePoint(double.parse(latitudeController.text), double.parse(longitudeController.text));
    final newLogId = newGeoFirePoint.hash;
    final String newStreetName = streetNameController.text;

    final LogModel newLog = LogModel(
      logId: newLogId,
      geoPoint: newGeoFirePoint,
      streetName: newStreetName
    );
    await tryCatch(firebaseService.updateLog(oldLog: initialLog, newLog: newLog));
  }

  Future<void> deleteLog() async {
    await tryCatch(firebaseService.deleteLog(logId: initialLog.logId));
  }

  Future<void> addArchive() async {
    await tryCatch(firebaseService.setArchive(ArchiveModel.emptyArchive(initialLog.logId)));
  }

  Future<void> deleteArchive(String archiveId) async {
    await tryCatch(firebaseService.deleteArchive(archiveId: archiveId));
  }

  final loadingState = const LogFormInitial(isLoading: true);
  final notLoadingState = const LogFormInitial(isLoading: false);

  void emitErrorState(FirebaseException error) {
    emit(LogFormInitial(isLoading: false, errorMessage: error.message));
  }

  Future<void> tryCatch(Future<void> function) async {
    emit(loadingState);
    try {
      await function;
      emit(notLoadingState);
    } on FirebaseException catch(error) {
      emit(LogFormInitial(isLoading: false, errorMessage: error.message));
    }
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
