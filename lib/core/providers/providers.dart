import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../features/auth/repositories/auth_repository.dart';
import '../../features/profile/repositories/profile_repository.dart';
import '../../features/challenges/repositories/challenge_repository.dart';
import '../../services/storage_service.dart';
import '../../services/analytics_service.dart';
import '../../services/supabase_service.dart';
import '../../services/http_service.dart';
import '../../services/notification_service.dart';
import '../config/app_config.dart';
import '../../services/api_service.dart';
import './service_providers.dart' as service_providers;

// Core Providers
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be initialized');
});

// Supabase Client Provider
final supabaseClientProvider = Provider<supabase.SupabaseClient>((ref) {
  return supabase.Supabase.instance.client;
});

final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return SupabaseService(supabaseClient);
});

final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

// Repository Providers
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return AuthRepository(supabaseClient);
});

// Utilizando a implementação mock para desenvolvimento
final userRepositoryProvider = Provider<MockProfileRepository>((ref) {
  return MockProfileRepository();
});

// Utilizando a implementação mock para desenvolvimento
final challengeRepositoryProvider = Provider<MockChallengeRepository>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return MockChallengeRepository(supabaseClient);
});

// Service Providers
final storageServiceProvider = Provider<StorageService>((ref) {
  return ref.watch(service_providers.storageServiceProvider);
});

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService(
    enabled: AppConfig.analyticsEnabled,
    key: AppConfig.analyticsKey,
  );
});

// Adicionando o provider para o ApiService
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

// Provider para HttpService
final httpServiceProvider = Provider<HttpService>((ref) {
  final dio = ref.watch(dioProvider);
  return HttpService(dio: dio);
});

// Provider para NotificationService
final notificationServiceProvider = Provider<NotificationService>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return NotificationService(supabase: supabase);
});
