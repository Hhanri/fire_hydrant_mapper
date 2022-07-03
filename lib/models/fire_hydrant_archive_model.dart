import 'package:equatable/equatable.dart';

class FireHydrantArchiveModel extends Equatable{
  final DateTime date;
  final double waterLevel;
  final String note;
  final List<String> images;

  const FireHydrantArchiveModel({
    required this.date,
    required this.waterLevel,
    required this.note,
    required this.images
  });

  factory FireHydrantArchiveModel.fromJson(Map<String, dynamic> json) {
    return FireHydrantArchiveModel(
      date: json['date'],
      waterLevel: json['waterLevel'],
      note: json['note'],
      images: json['images']
    );
  }

  static Map<String, dynamic> toJson(FireHydrantArchiveModel model) {
    return {
      'date': model.date,
      'waterLevel': model.waterLevel,
      'note': model.note,
      'images': model.images
    };
  }

  static final List<FireHydrantArchiveModel> mockData = [
    FireHydrantArchiveModel(
      date: DateTime.now(),
      waterLevel: 50,
      note: "RAS",
      images: const []
    ),
    FireHydrantArchiveModel(
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