import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Tipos de ambiente da aplicação
enum Environment {
  development,
  staging,
  production,
}

/// Gerenciador de ambiente
class EnvironmentManager {
  static Environment _environment = Environment.development;
  
  /// Configura o ambiente atual
  static void setEnvironment(Environment env) {
    _environment = env;
  }
  
  /// Retorna o ambiente atual
  static Environment get current => _environment;
  
  /// Verifica se é ambiente de desenvolvimento
  static bool get isDevelopment => _environment == Environment.development;
  
  /// Verifica se é ambiente de produção
  static bool get isProduction => _environment == Environment.production;
  
  /// Verifica se é ambiente de staging
  static bool get isStaging => _environment == Environment.staging;
  
  /// Retorna o URL do Supabase para o ambiente atual
  static String get supabaseUrl {
    switch (_environment) {
      case Environment.development:
        return dotenv.env['DEV_SUPABASE_URL'] ?? '';
      case Environment.staging:
        return dotenv.env['STAGING_SUPABASE_URL'] ?? '';
      case Environment.production:
        return dotenv.env['PROD_SUPABASE_URL'] ?? '';
    }
  }
  
  /// Retorna a chave anônima do Supabase para o ambiente atual
  static String get supabaseAnonKey {
    switch (_environment) {
      case Environment.development:
        return dotenv.env['DEV_SUPABASE_ANON_KEY'] ?? '';
      case Environment.staging:
        return dotenv.env['STAGING_SUPABASE_ANON_KEY'] ?? '';
      case Environment.production:
        return dotenv.env['PROD_SUPABASE_ANON_KEY'] ?? '';
    }
  }
  
  /// Retorna a URL da API para o ambiente atual
  static String get apiUrl {
    switch (_environment) {
      case Environment.development:
        return dotenv.env['DEV_API_URL'] ?? '';
      case Environment.staging:
        return dotenv.env['STAGING_API_URL'] ?? '';
      case Environment.production:
        return dotenv.env['PROD_API_URL'] ?? '';
    }
  }
  
  /// Retorna se o modo de debug está ativo
  static bool get debugMode {
    switch (_environment) {
      case Environment.development:
        return true;
      case Environment.staging:
        return dotenv.env['STAGING_DEBUG_MODE']?.toLowerCase() == 'true';
      case Environment.production:
        return false;
    }
  }
  
  /// Retorna o bucket de armazenamento para workouts no ambiente atual
  static String get workoutBucket {
    return dotenv.env['STORAGE_WORKOUT_BUCKET'] ?? 'workout-images';
  }
  
  /// Retorna o bucket de armazenamento para perfis no ambiente atual
  static String get profileBucket {
    return dotenv.env['STORAGE_PROFILE_BUCKET'] ?? 'profile-images';
  }
  
  /// Retorna o bucket de armazenamento para nutrição no ambiente atual
  static String get nutritionBucket {
    return dotenv.env['STORAGE_NUTRITION_BUCKET'] ?? 'nutrition-images';
  }
  
  /// Retorna o bucket de armazenamento para destaque no ambiente atual
  static String get featuredBucket {
    return dotenv.env['STORAGE_FEATURED_BUCKET'] ?? 'featured-images';
  }
  
  /// Retorna o bucket de armazenamento para desafios no ambiente atual
  static String get challengeBucket {
    return dotenv.env['STORAGE_CHALLENGE_BUCKET'] ?? 'challenge-media';
  }
  
  /// Verifica se todos os valores necessários estão configurados
  static bool validateEnvironment() {
    final requiredKeys = [
      supabaseUrl,
      supabaseAnonKey,
    ];
    
    return !requiredKeys.any((key) => key.isEmpty);
  }
} 