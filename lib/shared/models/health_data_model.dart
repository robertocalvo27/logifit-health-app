import 'package:json_annotation/json_annotation.dart';

part 'health_data_model.g.dart';

@JsonSerializable()
class HealthDataModel {
  final String id;
  final String userId;
  final DateTime date;
  final int? steps;
  final double? heartRate;
  final double? calories;
  final double? distance;
  final Duration? sleepDuration;
  final List<WorkoutModel> workouts;
  final DateTime updatedAt;

  const HealthDataModel({
    required this.id,
    required this.userId,
    required this.date,
    this.steps,
    this.heartRate,
    this.calories,
    this.distance,
    this.sleepDuration,
    this.workouts = const [],
    required this.updatedAt,
  });

  factory HealthDataModel.fromJson(Map<String, dynamic> json) =>
      _$HealthDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$HealthDataModelToJson(this);

  HealthDataModel copyWith({
    String? id,
    String? userId,
    DateTime? date,
    int? steps,
    double? heartRate,
    double? calories,
    double? distance,
    Duration? sleepDuration,
    List<WorkoutModel>? workouts,
    DateTime? updatedAt,
  }) {
    return HealthDataModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      steps: steps ?? this.steps,
      heartRate: heartRate ?? this.heartRate,
      calories: calories ?? this.calories,
      distance: distance ?? this.distance,
      sleepDuration: sleepDuration ?? this.sleepDuration,
      workouts: workouts ?? this.workouts,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@JsonSerializable()
class WorkoutModel {
  final String id;
  final WorkoutType type;
  final DateTime startTime;
  final DateTime endTime;
  final double? calories;
  final double? distance;
  final double? averageHeartRate;
  final double? maxHeartRate;
  final String? notes;

  const WorkoutModel({
    required this.id,
    required this.type,
    required this.startTime,
    required this.endTime,
    this.calories,
    this.distance,
    this.averageHeartRate,
    this.maxHeartRate,
    this.notes,
  });

  factory WorkoutModel.fromJson(Map<String, dynamic> json) =>
      _$WorkoutModelFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutModelToJson(this);

  Duration get duration => endTime.difference(startTime);
}

enum WorkoutType {
  running,
  walking,
  cycling,
  swimming,
  strength,
  yoga,
  pilates,
  dance,
  soccer,
  basketball,
  tennis,
  other,
}

@JsonSerializable()
class HealthSummaryModel {
  final DateTime date;
  final int totalSteps;
  final double totalCalories;
  final double totalDistance;
  final Duration totalSleepTime;
  final double averageHeartRate;
  final int workoutsCount;
  final Duration totalWorkoutTime;

  const HealthSummaryModel({
    required this.date,
    required this.totalSteps,
    required this.totalCalories,
    required this.totalDistance,
    required this.totalSleepTime,
    required this.averageHeartRate,
    required this.workoutsCount,
    required this.totalWorkoutTime,
  });

  factory HealthSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$HealthSummaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$HealthSummaryModelToJson(this);
}
