import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:fire_hydrant_mapper/constants/firebase_constants.dart';

class FireHydrantArchiveModel extends Equatable {
  final String parentLogId;
  final DateTime date;
  final double waterLevel;
  final String note;
  final List<String> images;

  const FireHydrantArchiveModel({
    required this.parentLogId,
    required this.date,
    required this.waterLevel,
    required this.note,
    required this.images
  });

  factory FireHydrantArchiveModel.fromJson(Map<String, dynamic> json) {
    return FireHydrantArchiveModel(
      parentLogId: json[FirebaseConstants.parentLogId],
      date: (json[FirebaseConstants.date] as Timestamp).toDate(),
      waterLevel: json[FirebaseConstants.waterLevel],
      note: json[FirebaseConstants.note],
      images: List<String>.from(json[FirebaseConstants.images])
    );
  }

  static Map<String, dynamic> toJson(FireHydrantArchiveModel model) {
    return {
      FirebaseConstants.parentLogId: model.parentLogId,
      FirebaseConstants.date: model.date,
      FirebaseConstants.waterLevel: model.waterLevel,
      FirebaseConstants.note: model.note,
      FirebaseConstants.images: model.images
    };
  }

  static final List<FireHydrantArchiveModel> mockData = [
    FireHydrantArchiveModel(
      parentLogId: 'test',
      date: DateTime.now(),
      waterLevel: 50,
      note: "RAS",
      images: const []
    ),
    FireHydrantArchiveModel(
      parentLogId: 'test',
      date: DateTime(2022, 3, 23),
      waterLevel: 80,
      note: "RAS",
      images: const []
    )
  ];

  @override
  // TODO: implement props
  List<Object?> get props => [date, waterLevel, note, images];
}