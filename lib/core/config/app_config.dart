import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  static String get apiUrl => dotenv.env['API_URL'] ?? '';
  static String get apiVersion => dotenv.env['API_VERSION'] ?? 'v1';

  static String get appName => dotenv.env['APP_NAME'] ?? 'Ray Club';
  static String get appEnv => dotenv.env['APP_ENV'] ?? 'development';
  static bool get debugMode =>
      dotenv.env['DEBUG_MODE']?.toLowerCase() == 'true';

  // @deprecated Variáveis legadas que serão removidas em versões futuras.
  // Utilize os buckets específicos abaixo em vez dessas variáveis genéricas.
  static String get storageBucket => dotenv.env['STORAGE_BUCKET'] ?? '';
  static String get storageUrl => dotenv.env['STORAGE_URL'] ?? '';
  
  // Storage buckets
  static String get workoutBucket => dotenv.env['STORAGE_WORKOUT_BUCKET'] ?? 'workout-images';
  static String get profileBucket => dotenv.env['STORAGE_PROFILE_BUCKET'] ?? 'profile-images';
  static String get nutritionBucket => dotenv.env['STORAGE_NUTRITION_BUCKET'] ?? 'nutrition-images';
  static String get featuredBucket => dotenv.env['STORAGE_FEATURED_BUCKET'] ?? 'featured-images';
  static String get challengeBucket => dotenv.env['STORAGE_CHALLENGE_BUCKET'] ?? 'challenge-media';

  static bool get analyticsEnabled =>
      dotenv.env['ANALYTICS_ENABLED']?.toLowerCase() == 'true';
  static String get analyticsKey => dotenv.env['ANALYTICS_KEY'] ?? '';

  static Future<void> initialize() async {
    await dotenv.load();
  }

  static bool get isProduction => appEnv == 'production';
  static bool get isDevelopment => appEnv == 'development';
  static bool get isStaging => appEnv == 'staging';
}
