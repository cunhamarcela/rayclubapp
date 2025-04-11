// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ray_club_app/utils/log_utils.dart';

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
  
  /// Método para salvar lista de objetos serializados em cache
  Future<void> setObjectList<T>(
    String key, 
    List<T> objects, 
    {
      required T Function(Map<String, dynamic> json) fromJson,
      required Map<String, dynamic> Function(T object) toJson,
      Duration? expiryDuration,
    }
  );
  
  /// Método para recuperar lista de objetos do cache
  Future<List<T>?> getObjectList<T>(
    String key,
    {
      required T Function(Map<String, dynamic> json) fromJson,
      bool ignoreExpiry = false,
    }
  );
  
  /// Método para verificar se um cache específico está disponível e não expirado
  Future<bool> hasCacheValid(String key);
  
  /// Método para verificar quando um cache específico foi atualizado pela última vez
  Future<DateTime?> getLastCacheUpdate(String key);
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

  /// Método para salvar lista de objetos serializados em cache
  Future<void> setObjectList<T>(
    String key, 
    List<T> objects, 
    {
      required T Function(Map<String, dynamic> json) fromJson,
      required Map<String, dynamic> Function(T object) toJson,
      Duration? expiryDuration,
    }
  ) async {
    final jsonList = objects.map((obj) => toJson(obj)).toList();
    final expiryTime = DateTime.now().add(expiryDuration ?? const Duration(days: 1));
    
    final cacheEntry = {
      'data': jsonList,
      'expiry': expiryTime.millisecondsSinceEpoch,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    
    final encoded = jsonEncode(cacheEntry);
    await _prefs.setString(key, encoded);
    
    // Log de debug
    LogUtils.debug(
      'Cache salvo: $key (expira em: ${expiryTime.toString()})',
      tag: 'CacheService',
    );
  }

  /// Método para recuperar lista de objetos do cache
  Future<List<T>?> getObjectList<T>(
    String key,
    {
      required T Function(Map<String, dynamic> json) fromJson,
      bool ignoreExpiry = false,
    }
  ) async {
    final encoded = _prefs.getString(key);
    
    if (encoded == null) {
      LogUtils.debug('Cache não encontrado: $key', tag: 'CacheService');
      return null;
    }
    
    try {
      final cacheEntry = jsonDecode(encoded) as Map<String, dynamic>;
      
      // Verificar expiração
      if (!ignoreExpiry) {
        final expiryTime = cacheEntry['expiry'] as int;
        final now = DateTime.now().millisecondsSinceEpoch;
        
        if (now > expiryTime) {
          LogUtils.debug('Cache expirado: $key', tag: 'CacheService');
          return null;
        }
      }
      
      final jsonList = cacheEntry['data'] as List<dynamic>;
      final results = jsonList
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList();
      
      LogUtils.debug('Cache recuperado: $key (${results.length} itens)', tag: 'CacheService');
      return results;
    } catch (e) {
      LogUtils.error('Erro ao ler cache: $key', error: e, tag: 'CacheService');
      // Em caso de erro, remove o cache corrompido
      await _prefs.remove(key);
      return null;
    }
  }

  /// Método para verificar se um cache específico está disponível e não expirado
  Future<bool> hasCacheValid(String key) async {
    final encoded = _prefs.getString(key);
    
    if (encoded == null) {
      return false;
    }
    
    try {
      final cacheEntry = jsonDecode(encoded) as Map<String, dynamic>;
      final expiryTime = cacheEntry['expiry'] as int;
      final now = DateTime.now().millisecondsSinceEpoch;
      
      return now < expiryTime;
    } catch (e) {
      // Em caso de erro, remove o cache corrompido
      await _prefs.remove(key);
      return false;
    }
  }

  /// Método para verificar quando um cache específico foi atualizado pela última vez
  Future<DateTime?> getLastCacheUpdate(String key) async {
    final encoded = _prefs.getString(key);
    
    if (encoded == null) {
      return null;
    }
    
    try {
      final cacheEntry = jsonDecode(encoded) as Map<String, dynamic>;
      final timestamp = cacheEntry['timestamp'] as int;
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    } catch (e) {
      return null;
    }
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
