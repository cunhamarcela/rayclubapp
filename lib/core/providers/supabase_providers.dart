import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/app_config.dart';

/// Provider global para o cliente Supabase
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Provider para inicialização do Supabase
final supabaseInitProvider = FutureProvider<SupabaseClient>((ref) async {
  final supabase = await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
    debug: AppConfig.isDebug,
    authFlowType: AuthFlowType.pkce,
  );
  return supabase.client;
}); 