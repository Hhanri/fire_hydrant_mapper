import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fire_hydrant_mapper/models/archive_model.dart';
import 'package:fire_hydrant_mapper/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

part 'archive_form_state.dart';

class ArchiveFormCubit extends Cubit<ArchiveFormState> {
  final ArchiveModel initialArchive;
  final FirebaseService firebaseService;
  ArchiveFormCubit({required this.initialArchive, required this.firebaseService}) : super(const ArchiveFormInitial(isLoading: false));

  late DateTime date;
  final TextEditingController dateController = TextEditingController();
  final TextEditingController waterLevelController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  void changeDate(DateTime newDate) {
    date = newDate;
    dateController.text = DateFormat('yyyy-MM-dd hh:mm').format(date);
  }

  void editArchive() {
    final DateTime newDate = date;
    final double newWaterLevel = double.parse(waterLevelController.text);
    final String newNote = noteController.text;

    if (newDate != initialArchive.date
      || newWaterLevel != initialArchive.waterLevel
      || newNote != initialArchive.note
    ) {
      emit(loadingState);
      try {
        firebaseService.updateArchiveWithoutImages(
          newArchive: ArchiveModel(
            parentLogId: initialArchive.parentLogId,
            archiveId: initialArchive.archiveId,
            date: newDate,
            waterLevel: newWaterLevel,
            note: newNote,
            images: const []
          )
        );
      } on FirebaseException catch(error) {
        emitErrorState(error);
      }
    }
  }

  final loadingState = const ArchiveFormInitial(isLoading: true);
  final notLoadingState = const ArchiveFormInitial(isLoading: false);
  void emitErrorState(FirebaseException error) {
    emit(ArchiveFormInitial(isLoading: false, errorMessage: error.message));
  }

  @override
  Future<void> close () {
    dateController.dispose();
    waterLevelController.dispose();
    noteController.dispose();
    return super.close();
  }

}
