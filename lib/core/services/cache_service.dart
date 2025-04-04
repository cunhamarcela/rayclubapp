import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Interface para serviço de cache
abstract class CacheService {
  /// Armazena um valor no cache
  Future<bool> set(String key, dynamic value, {Duration? expiry});
  
  /// Recupera um valor do cache
  Future<dynamic> get(String key);
  
  /// Remove um valor do cache
  Future<bool> remove(String key);
  
  /// Limpa todo o cache
  Future<bool> clear();
  
  /// Verifica se um valor no cache está expirado
  Future<bool> isExpired(String key);
}

/// Implementação de CacheService usando SharedPreferences
class SharedPrefsCacheService implements CacheService {
  final SharedPreferences _prefs;
  
  // Prefixo para os registros de expiração
  static const String _expiryPrefix = '_expiry_';
  
  SharedPrefsCacheService(this._prefs);
  
  @override
  Future<bool> set(String key, dynamic value, {Duration? expiry}) async {
    bool result;
    
    // Converter o valor para JSON para armazenamento
    final jsonValue = json.encode(value);
    result = await _prefs.setString(key, jsonValue);
    
    // Se uma duração de expiração foi fornecida, armazenar a timestamp de expiração
    if (expiry != null) {
      final expiryTime = DateTime.now().add(expiry).millisecondsSinceEpoch;
      await _prefs.setInt('$_expiryPrefix$key', expiryTime);
    } else {
      // Se não houver expiração, remover qualquer expiração anterior
      await _prefs.remove('$_expiryPrefix$key');
    }
    
    return result;
  }
  
  @override
  Future<dynamic> get(String key) async {
    // Verificar se o valor existe e não está expirado
    if (await isExpired(key)) {
      await remove(key);
      return null;
    }
    
    // Recuperar o valor
    final jsonValue = _prefs.getString(key);
    if (jsonValue == null) {
      return null;
    }
    
    try {
      return json.decode(jsonValue);
    } catch (e) {
      // Se não for possível decodificar o JSON, retornar nulo
      return null;
    }
  }
  
  @override
  Future<bool> remove(String key) async {
    // Remover tanto o valor quanto a expiração
    bool result = await _prefs.remove(key);
    await _prefs.remove('$_expiryPrefix$key');
    return result;
  }
  
  @override
  Future<bool> clear() async {
    return await _prefs.clear();
  }
  
  @override
  Future<bool> isExpired(String key) async {
    // Se o valor não existir, considerar expirado
    if (!_prefs.containsKey(key)) {
      return true;
    }
    
    // Se não tiver timestamp de expiração, considerar válido
    final expiryKey = '$_expiryPrefix$key';
    if (!_prefs.containsKey(expiryKey)) {
      return false;
    }
    
    // Comparar timestamp atual com timestamp de expiração
    final expiryTime = _prefs.getInt(expiryKey);
    final now = DateTime.now().millisecondsSinceEpoch;
    
    return expiryTime != null && now > expiryTime;
  }
}

/// Provider para o serviço de cache
final cacheServiceProvider = Provider<CacheService>((ref) {
  // Esta implementação será substituída na inicialização do app
  throw UnimplementedError('CacheService deve ser inicializado na configuração do app');
});

/// Provider para inicializar o serviço de cache
final cacheServiceInitProvider = FutureProvider<CacheService>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return SharedPrefsCacheService(prefs);
}); 