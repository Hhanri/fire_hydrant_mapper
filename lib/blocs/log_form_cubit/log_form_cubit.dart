import 'package:fire_hydrant_mapper/models/fire_hydrant_archive_model.dart';
import 'package:fire_hydrant_mapper/models/fire_hydrant_log_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

part 'log_form_state.dart';

class LogFormCubit extends Cubit<LogFormState> {
  final FireHydrantLogModel initialLog;
  LogFormCubit({required this.initialLog}) : super(LogFormInitial());

  final TextEditingController streetNameController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();

  void editLog(List<FireHydrantArchiveModel> newArchives) {
    FireHydrantLogModel newLog = FireHydrantLogModel(
      geoPoint: GeoFirePoint(double.parse(latitudeController.text), double.parse(longitudeController.text)),
      streetName: streetNameController.text,
      archives: newArchives
    );
    if (newLog != initialLog) {
      //TODO: update log
    }
  }

  @override
  Future<void> close () {
    streetNameController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    return super.close();
  }
}
