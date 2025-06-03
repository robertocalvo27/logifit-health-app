// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthDataModel _$HealthDataModelFromJson(Map<String, dynamic> json) =>
    HealthDataModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      date: DateTime.parse(json['date'] as String),
      steps: (json['steps'] as num?)?.toInt(),
      heartRate: (json['heartRate'] as num?)?.toDouble(),
      calories: (json['calories'] as num?)?.toDouble(),
      distance: (json['distance'] as num?)?.toDouble(),
      sleepDuration: json['sleepDuration'] == null
          ? null
          : Duration(microseconds: (json['sleepDuration'] as num).toInt()),
      workouts: (json['workouts'] as List<dynamic>?)
              ?.map((e) => WorkoutModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$HealthDataModelToJson(HealthDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'date': instance.date.toIso8601String(),
      'steps': instance.steps,
      'heartRate': instance.heartRate,
      'calories': instance.calories,
      'distance': instance.distance,
      'sleepDuration': instance.sleepDuration?.inMicroseconds,
      'workouts': instance.workouts,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

WorkoutModel _$WorkoutModelFromJson(Map<String, dynamic> json) => WorkoutModel(
      id: json['id'] as String,
      type: $enumDecode(_$WorkoutTypeEnumMap, json['type']),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      calories: (json['calories'] as num?)?.toDouble(),
      distance: (json['distance'] as num?)?.toDouble(),
      averageHeartRate: (json['averageHeartRate'] as num?)?.toDouble(),
      maxHeartRate: (json['maxHeartRate'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$WorkoutModelToJson(WorkoutModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$WorkoutTypeEnumMap[instance.type]!,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'calories': instance.calories,
      'distance': instance.distance,
      'averageHeartRate': instance.averageHeartRate,
      'maxHeartRate': instance.maxHeartRate,
      'notes': instance.notes,
    };

const _$WorkoutTypeEnumMap = {
  WorkoutType.running: 'running',
  WorkoutType.walking: 'walking',
  WorkoutType.cycling: 'cycling',
  WorkoutType.swimming: 'swimming',
  WorkoutType.strength: 'strength',
  WorkoutType.yoga: 'yoga',
  WorkoutType.pilates: 'pilates',
  WorkoutType.dance: 'dance',
  WorkoutType.soccer: 'soccer',
  WorkoutType.basketball: 'basketball',
  WorkoutType.tennis: 'tennis',
  WorkoutType.other: 'other',
};

HealthSummaryModel _$HealthSummaryModelFromJson(Map<String, dynamic> json) =>
    HealthSummaryModel(
      date: DateTime.parse(json['date'] as String),
      totalSteps: (json['totalSteps'] as num).toInt(),
      totalCalories: (json['totalCalories'] as num).toDouble(),
      totalDistance: (json['totalDistance'] as num).toDouble(),
      totalSleepTime:
          Duration(microseconds: (json['totalSleepTime'] as num).toInt()),
      averageHeartRate: (json['averageHeartRate'] as num).toDouble(),
      workoutsCount: (json['workoutsCount'] as num).toInt(),
      totalWorkoutTime:
          Duration(microseconds: (json['totalWorkoutTime'] as num).toInt()),
    );

Map<String, dynamic> _$HealthSummaryModelToJson(HealthSummaryModel instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'totalSteps': instance.totalSteps,
      'totalCalories': instance.totalCalories,
      'totalDistance': instance.totalDistance,
      'totalSleepTime': instance.totalSleepTime.inMicroseconds,
      'averageHeartRate': instance.averageHeartRate,
      'workoutsCount': instance.workoutsCount,
      'totalWorkoutTime': instance.totalWorkoutTime.inMicroseconds,
    };
