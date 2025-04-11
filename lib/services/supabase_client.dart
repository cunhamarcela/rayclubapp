// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

export 'package:supabase_flutter/supabase_flutter.dart' show SupabaseClient;

/// Provider global para o cliente Supabase
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Inicializa o Supabase com as credenciais do .env
Future<void> initializeSupabase() async {
  try {
    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final supabaseKey = dotenv.env['SUPABASE_ANON_KEY'];
    
    if (supabaseUrl == null || supabaseKey == null) {
      throw Exception('Credenciais do Supabase não encontradas no .env');
    }
    
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
      debug: false,
    );
    
    debugPrint('Supabase inicializado com sucesso');
  } catch (e) {
    debugPrint('Erro ao inicializar Supabase: $e');
    rethrow;
  }
} 