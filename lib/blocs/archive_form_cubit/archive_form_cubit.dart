import 'package:fire_hydrant_mapper/models/fire_hydrant_archive_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'archive_form_state.dart';

class ArchiveFormCubit extends Cubit<ArchiveFormState> {
  final FireHydrantArchiveModel initialArchive;
  ArchiveFormCubit({required this.initialArchive}) : super(ArchiveFormInitial());

  late DateTime date;
  final TextEditingController dateController = TextEditingController();
  final TextEditingController waterLevelController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  FireHydrantArchiveModel newArchive = FireHydrantArchiveModel(
      date: DateTime.now(),
      waterLevel: 0.0,
      note: "",
      images: const []
  );


  void changeDate(DateTime newDate) {
    date = newDate;
    //dateController.value =
  }

  void editArchive(List<String> newImages) {
    FireHydrantArchiveModel newArchive = FireHydrantArchiveModel(
      date: date,
      waterLevel: double.parse(waterLevelController.text),
      note: noteController.text,
      images: newImages
    );
    if (newArchive.date != initialArchive.date
      || newArchive.waterLevel != initialArchive.waterLevel
      || newArchive.note != initialArchive.note
    ) {
      //TODO: update archive
    }
  }

  @override
  Future<void> close () {
    dateController.dispose();
    waterLevelController.dispose();
    noteController.dispose();
    return super.close();
  }

}
