import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final String? photoURL;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final UserPreferences preferences;
  final List<String> connectedServices;

  const UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.photoURL,
    required this.createdAt,
    this.lastLoginAt,
    required this.preferences,
    this.connectedServices = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoURL,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    UserPreferences? preferences,
    List<String>? connectedServices,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      preferences: preferences ?? this.preferences,
      connectedServices: connectedServices ?? this.connectedServices,
    );
  }
}

@JsonSerializable()
class UserPreferences {
  final String units; // 'metric' or 'imperial'
  final bool notificationsEnabled;
  final bool darkModeEnabled;
  final int dailyStepsGoal;
  final double dailyCaloriesGoal;
  final Duration dailySleepGoal;

  const UserPreferences({
    this.units = 'metric',
    this.notificationsEnabled = true,
    this.darkModeEnabled = false,
    this.dailyStepsGoal = 10000,
    this.dailyCaloriesGoal = 2000.0,
    this.dailySleepGoal = const Duration(hours: 8),
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);

  Map<String, dynamic> toJson() => _$UserPreferencesToJson(this);

  UserPreferences copyWith({
    String? units,
    bool? notificationsEnabled,
    bool? darkModeEnabled,
    int? dailyStepsGoal,
    double? dailyCaloriesGoal,
    Duration? dailySleepGoal,
  }) {
    return UserPreferences(
      units: units ?? this.units,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      dailyStepsGoal: dailyStepsGoal ?? this.dailyStepsGoal,
      dailyCaloriesGoal: dailyCaloriesGoal ?? this.dailyCaloriesGoal,
      dailySleepGoal: dailySleepGoal ?? this.dailySleepGoal,
    );
  }
}
