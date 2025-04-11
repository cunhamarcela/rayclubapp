// Dart imports:
import 'dart:async';
import 'dart:io';

// Package imports:
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod/riverpod.dart';

// Project imports:
import 'package:ray_club_app/utils/log_utils.dart';

/// Serviço para monitorar e gerenciar conectividade
class ConnectivityService {
  final StreamController<bool> _connectionChangeController = StreamController<bool>.broadcast();
  bool _hasConnection = true;
  
  ConnectivityService() {
    // Inicializar monitoramento de conectividade
    Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    // Verificar estado inicial
    _checkConnection();
  }
  
  /// Stream de mudanças de conexão
  Stream<bool> get connectionChange => _connectionChangeController.stream;
  
  /// Indica se há conexão ativa
  bool get hasConnection => _hasConnection;
  
  /// Verifica a conexão atual
  Future<bool> _checkConnection() async {
    // Primeiro verificamos se há alguma conectividade reportada pelo sistema
    final connectivityResult = await Connectivity().checkConnectivity();
    
    // Se não houver nenhuma conexão a nível de dispositivo, estamos definitivamente offline
    if (connectivityResult == ConnectivityResult.none) {
      _hasConnection = false;
      _connectionChangeController.add(false);
      return false;
    }
    
    // Se o sistema reporta conectividade, vamos assumir que está online
    // Isso evita falsos negativos e é mais alinhado à experiência do usuário
    _hasConnection = true;
    _connectionChangeController.add(true);
    
    // Ainda tentamos verificar a conexão real com um servidor, mas apenas para logging
    _checkActualConnectivity().then((hasActualConnectivity) {
      if (!hasActualConnectivity) {
        LogUtils.warning('Dispositivo reporta conectividade, mas não consegue atingir servidores externos.',
            tag: 'ConnectivityService');
      }
    });
    
    return true;
  }
  
  /// Verifica se há conectividade real tentando acessar múltiplos domínios
  /// Esta função é apenas para diagnóstico e não altera o estado de conectividade
  Future<bool> _checkActualConnectivity() async {
    // Lista de domínios confiáveis para verificar, em ordem de prioridade
    final domains = ['cloudflare.com', 'google.com', 'apple.com', 'microsoft.com'];
    
    for (final domain in domains) {
      try {
        final result = await InternetAddress.lookup(domain)
            .timeout(const Duration(seconds: 3));
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          return true;
        }
      } catch (e) {
        // Continuar tentando outros domínios
        continue;
      }
    }
    
    return false;
  }
  
  /// Atualiza o status de conexão quando muda
  Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
    if (results.contains(ConnectivityResult.none) || results.isEmpty) {
      _hasConnection = false;
      _connectionChangeController.add(false);
    } else {
      // Verificar se realmente há conexão com a internet
      await _checkConnection();
    }
  }
  
  /// Força uma verificação de conectividade
  Future<bool> checkConnectionNow() async {
    return await _checkConnection();
  }
  
  /// Fecha o controller quando não for mais necessário
  void dispose() {
    _connectionChangeController.close();
  }
}

/// Provider para o serviço de conectividade
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Provider para obter o status atual de conectividade
final connectivityStatusProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.connectionChange;
}); 