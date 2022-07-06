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
  LogFormCubit({required this.initialLog, required this.firebaseService}) : super(LogFormInitial());

  final TextEditingController streetNameController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();

  void init() {
    streetNameController.text = initialLog.streetName;
    latitudeController.text = initialLog.geoPoint.latitude.toString();
    longitudeController.text = initialLog.geoPoint.longitude.toString();
  }

  void editLog(List<FireHydrantArchiveModel> newArchives) async {
    FireHydrantLogModel newLog = FireHydrantLogModel(
      geoPoint: GeoFirePoint(double.parse(latitudeController.text), double.parse(longitudeController.text)),
      streetName: streetNameController.text,
      archives: newArchives
    );
    if (newLog != initialLog) {
      deleteLog();
      firebaseService.addGeoPoint(logModel: newLog);
    }
  }

  void deleteLog() async {
    await firebaseService.deleteGeoPoint(documentId: initialLog.documentId!);
  }

  @override
  Future<void> close () {
    streetNameController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    return super.close();
  }
}
