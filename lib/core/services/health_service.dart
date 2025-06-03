import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health/health.dart';
import 'dart:io';
import '../../shared/models/health_data_model.dart';

enum HealthConnectionStatus {
  connected,
  disconnected,
  connecting,
  error,
}

class HealthService {
  static final Health _health = Health();

  // Define los tipos de datos que vamos a solicitar
  static final List<HealthDataType> _healthDataTypes = [
    HealthDataType.STEPS,
    HealthDataType.HEART_RATE,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.DISTANCE_WALKING_RUNNING,
    HealthDataType.SLEEP_IN_BED,
    HealthDataType.WORKOUT,
  ];

  /// Verifica si los datos de salud están disponibles en este dispositivo
  Future<bool> isHealthDataAvailable() async {
    try {
      if (kIsWeb) {
        print('❌ Health data not available on web');
        return false;
      }

      if (Platform.isIOS) {
        // En iOS, HealthKit siempre está disponible (excepto en simulador)
        bool available =
            await _health.isDataTypeAvailable(HealthDataType.STEPS);
        print('✅ iOS HealthKit available: $available');
        return available;
      }

      if (Platform.isAndroid) {
        // En Android, verificamos Google Fit
        bool available =
            await _health.isDataTypeAvailable(HealthDataType.STEPS);
        print('✅ Android Health Connect available: $available');
        return available;
      }

      return false;
    } catch (e) {
      print('❌ Error checking health data availability: $e');
      return false;
    }
  }

  /// Solicita permisos para acceder a los datos de salud
  Future<bool> requestPermissions() async {
    try {
      print('🔐 Requesting health permissions...');

      if (!await isHealthDataAvailable()) {
        print('⚠️ HealthKit not available, using demo mode');
        return true; // Return true for demo mode
      }

      // Solicitar permisos para todos los tipos de datos
      bool granted = await _health.requestAuthorization(
        _healthDataTypes,
        permissions:
            _healthDataTypes.map((type) => HealthDataAccess.READ).toList(),
      );

      print('✅ Health permissions granted: $granted');

      // If permissions denied, still return true for demo mode
      if (!granted) {
        print('⚠️ Permissions denied, enabling demo mode with simulated data');
        return true;
      }

      return granted;
    } catch (e) {
      print('❌ Error requesting health permissions: $e');
      print('🎯 Enabling demo mode with simulated health data');
      return true; // Return true to enable demo mode
    }
  }

  /// Verifica si ya tenemos permisos
  Future<bool> hasPermissions() async {
    try {
      if (!await isHealthDataAvailable()) {
        return false;
      }

      // Verificar si tenemos permisos para al menos pasos
      bool hasStepsPermission =
          await _health.hasPermissions([HealthDataType.STEPS]) ?? false;
      print('✅ Has steps permission: $hasStepsPermission');
      return hasStepsPermission;
    } catch (e) {
      print('❌ Error checking permissions: $e');
      return false;
    }
  }

  /// Obtiene el resumen de salud de hoy
  Future<HealthSummaryModel?> getTodaysSummary() async {
    try {
      if (!await hasPermissions()) {
        print('❌ No health permissions, returning demo summary');
        return _createDemoSummary();
      }

      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

      print('📊 Fetching health data from $startOfDay to $endOfDay');

      // Obtener datos de salud
      final healthData = await _health.getHealthDataFromTypes(
        types: _healthDataTypes,
        startTime: startOfDay,
        endTime: endOfDay,
      );

      print('📊 Retrieved ${healthData.length} health data points');

      // Procesar los datos
      int totalSteps = 0;
      double totalCalories = 0;
      double totalDistance = 0;
      List<double> heartRates = [];
      Duration totalSleepTime = Duration.zero;
      int workoutsCount = 0;
      Duration totalWorkoutTime = Duration.zero;

      for (var data in healthData) {
        switch (data.type) {
          case HealthDataType.STEPS:
            totalSteps += (data.value as num).toInt();
            break;
          case HealthDataType.ACTIVE_ENERGY_BURNED:
            totalCalories += (data.value as num).toDouble();
            break;
          case HealthDataType.DISTANCE_WALKING_RUNNING:
            totalDistance += (data.value as num).toDouble();
            break;
          case HealthDataType.HEART_RATE:
            heartRates.add((data.value as num).toDouble());
            break;
          case HealthDataType.SLEEP_IN_BED:
            // El valor de sueño viene en minutos
            totalSleepTime += Duration(minutes: (data.value as num).toInt());
            break;
          case HealthDataType.WORKOUT:
            workoutsCount++;
            if (data.dateTo != null && data.dateFrom != null) {
              totalWorkoutTime += data.dateTo!.difference(data.dateFrom!);
            }
            break;
          default:
            break;
        }
      }

      final averageHeartRate = heartRates.isNotEmpty
          ? heartRates.reduce((a, b) => a + b) / heartRates.length
          : 0.0;

      final summary = HealthSummaryModel(
        date: startOfDay,
        totalSteps: totalSteps,
        totalCalories: totalCalories,
        totalDistance: totalDistance / 1000, // Convert to kilometers
        totalSleepTime: totalSleepTime,
        averageHeartRate: averageHeartRate,
        workoutsCount: workoutsCount,
        totalWorkoutTime: totalWorkoutTime,
      );

      print(
          '✅ Health summary created: ${summary.totalSteps} steps, ${summary.totalCalories} calories');
      return summary;
    } catch (e) {
      print('❌ Error getting health summary: $e');
      return null;
    }
  }

  /// Obtiene solo los pasos de hoy
  Future<int> getTodaysSteps() async {
    try {
      if (!await hasPermissions()) {
        print('❌ No permissions for steps data, returning demo steps');
        return 8547; // Demo steps
      }

      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

      final healthData = await _health.getHealthDataFromTypes(
        types: [HealthDataType.STEPS],
        startTime: startOfDay,
        endTime: endOfDay,
      );

      int totalSteps = 0;
      for (var data in healthData) {
        if (data.type == HealthDataType.STEPS) {
          totalSteps += (data.value as num).toInt();
        }
      }

      print('👟 Today\'s steps: $totalSteps');
      return totalSteps;
    } catch (e) {
      print('❌ Error getting steps: $e');
      return 0;
    }
  }

  /// Obtiene datos de pasos de los últimos días
  Future<List<HealthDataPoint>> getStepsHistory(int days) async {
    try {
      if (!await hasPermissions()) {
        return [];
      }

      final now = DateTime.now();
      final startDate = now.subtract(Duration(days: days));

      final healthData = await _health.getHealthDataFromTypes(
        types: [HealthDataType.STEPS],
        startTime: startDate,
        endTime: now,
      );

      return healthData
          .where((data) => data.type == HealthDataType.STEPS)
          .toList();
    } catch (e) {
      print('❌ Error getting steps history: $e');
      return [];
    }
  }

  /// Crea datos de demo cuando HealthKit no está disponible
  HealthSummaryModel _createDemoSummary() {
    return HealthSummaryModel(
      date: DateTime.now(),
      totalSteps: 8547,
      totalCalories: 420.5,
      totalDistance: 6.2, // km
      totalSleepTime: const Duration(hours: 7, minutes: 30),
      averageHeartRate: 72.0,
      workoutsCount: 2,
      totalWorkoutTime: const Duration(hours: 1, minutes: 15),
    );
  }
}

// Provider for HealthService
final healthServiceProvider = Provider<HealthService>((ref) => HealthService());

// Provider for health connection status
final healthConnectionStatusProvider = StateProvider<HealthConnectionStatus>(
  (ref) => HealthConnectionStatus.disconnected,
);

// Provider for today's health summary
final todaysHealthSummaryProvider = FutureProvider<HealthSummaryModel?>((ref) {
  return ref.read(healthServiceProvider).getTodaysSummary();
});

// Provider for today's steps
final todaysStepsProvider = FutureProvider<int>((ref) {
  return ref.read(healthServiceProvider).getTodaysSteps();
});

// Provider for steps history
final stepsHistoryProvider =
    FutureProvider.family<List<HealthDataPoint>, int>((ref, days) {
  return ref.read(healthServiceProvider).getStepsHistory(days);
});
