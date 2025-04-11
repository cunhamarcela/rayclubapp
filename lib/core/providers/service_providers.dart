// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:ray_club_app/services/remote_logging_service.dart';
import 'package:ray_club_app/services/secure_storage_service.dart';
import 'package:ray_club_app/services/storage_service.dart';
import 'package:ray_club_app/services/supabase_storage_service.dart';
import 'package:ray_club_app/services/deep_link_service.dart';
import '../services/cache_service.dart';

/// Provider para o serviço de log remoto
final remoteLoggingServiceProvider = Provider<RemoteLoggingService>((ref) {
  final service = RemoteLoggingService();
  
  // Inicializar o serviço durante a criação
  service.initialize();
  
  // Garantir que o serviço seja descartado quando o provider for destruído
  ref.onDispose(() {
    service.dispose();
  });
  
  return service;
});

/// Provider para o serviço de armazenamento
final storageServiceProvider = Provider<StorageService>((ref) {
  // Obter o cliente Supabase através da configuração
  final supabase = Supabase.instance.client;
  
  // Criar uma instância do serviço de armazenamento Supabase
  final service = SupabaseStorageService(supabaseClient: supabase);
  
  // Inicializar o serviço durante a criação
  service.initialize();
  
  // Garantir que o serviço seja descartado quando o provider for destruído
  ref.onDispose(() {
    // Chamada de dispose segura
    try {
      service.dispose();
    } catch (e) {
      // Ignora erros durante o dispose para evitar crashes na finalização
    }
  });
  
  return service;
});

/// Provider para o serviço de armazenamento seguro
final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  final service = SecureStorageService();
  
  // Inicializar o serviço durante a criação
  service.initialize();
  
  // Garantir que o serviço seja descartado quando o provider for destruído
  ref.onDispose(() {
    service.dispose();
  });
  
  return service;
});

/// Provider para o serviço de deep links
final deepLinkServiceProvider = Provider<DeepLinkService>((ref) {
  final deepLinkService = DeepLinkService();
  // Inicializar o serviço
  deepLinkService.initialize();
  
  // Garantir a liberação de recursos ao destruir o provider
  ref.onDispose(() {
    deepLinkService.dispose();
  });
  
  return deepLinkService;
});

/// Provider for SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('This provider should be overridden with an instance in main.dart');
}); 
