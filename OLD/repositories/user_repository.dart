import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../models/user.dart';
import '../core/di/base_repository.dart';
import '../core/exceptions/repository_exception.dart';

abstract class IUserRepository {
  Future<AppUser> getUser(String id);
  Future<void> updateUser(String id, Map<String, dynamic> data);
}

class UserRepository implements IUserRepository, BaseRepository {
  final supabase.SupabaseClient _supabase;
  final SharedPreferences _prefs;

  UserRepository({
    required supabase.SupabaseClient supabase,
    required SharedPreferences prefs,
  })  : _supabase = supabase,
        _prefs = prefs;

  @override
  Future<void> initialize() async {
    // Inicialização se necessário
  }

  @override
  Future<AppUser> getUser(String id) async {
    try {
      final response =
          await _supabase.from('users').select().eq('id', id).single();

      return AppUser.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      if (e is supabase.PostgrestException) {
        throw ResourceNotFoundException('User not found');
      }
      throw DatabaseException('Failed to get user: ${e.toString()}');
    }
  }

  @override
  Future<void> updateUser(String id, Map<String, dynamic> data) async {
    try {
      await _supabase.from('users').update(data).eq('id', id);
    } catch (e) {
      if (e is supabase.PostgrestException) {
        throw ResourceNotFoundException('User not found');
      }
      throw DatabaseException('Failed to update user: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCache() async {
    await _prefs.remove('cached_user');
  }

  @override
  Future<void> dispose() async {
    // Limpeza se necessário
  }
}
