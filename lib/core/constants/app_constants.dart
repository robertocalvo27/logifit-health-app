class AppConstants {
  // App Info
  static const String appName = 'Logifit';
  static const String appVersion = '1.0.0';

  // Colors
  static const primaryColor = 0xFF2563EB; // Blue 600
  static const secondaryColor = 0xFF10B981; // Emerald 500
  static const errorColor = 0xFFEF4444; // Red 500
  static const warningColor = 0xFFF59E0B; // Amber 500
  static const successColor = 0xFF10B981; // Emerald 500

  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;

  // Animation Durations
  static const Duration animationShort = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationLong = Duration(milliseconds: 500);

  // Health Data Types
  static const List<String> requiredHealthPermissions = [
    'STEPS',
    'HEART_RATE',
    'ACTIVE_ENERGY_BURNED',
    'DISTANCE_WALKING_RUNNING',
    'SLEEP_IN_BED',
    'WORKOUT',
  ];

  // Storage Keys
  static const String keyUserToken = 'user_token';
  static const String keyUserData = 'user_data';
  static const String keyOnboardingCompleted = 'onboarding_completed';
  static const String keyHealthPermissionsGranted =
      'health_permissions_granted';
  static const String keyFirstLaunch = 'first_launch';
}
