import '../core/di/base_service.dart';

class AnalyticsService implements BaseService {
  final bool enabled;
  final String key;
  bool _initialized = false;

  AnalyticsService({
    required this.enabled,
    required this.key,
  });

  @override
  bool get isInitialized => _initialized;

  @override
  Future<void> initialize() async {
    if (!enabled) return;

    // Inicializar serviço de analytics
    _initialized = true;
  }

  Future<void> logEvent(String name, {Map<String, dynamic>? parameters}) async {
    if (!enabled) return;

    // Implementar logging de eventos
    print('Analytics Event: $name, Parameters: $parameters');
  }

  Future<void> setUserProperties(Map<String, dynamic> properties) async {
    if (!enabled) return;

    // Implementar propriedades do usuário
    print('User Properties: $properties');
  }

  Future<void> logError(dynamic error, StackTrace? stackTrace) async {
    if (!enabled) return;

    // Implementar logging de erros
    print('Error: $error\nStackTrace: $stackTrace');
  }

  @override
  Future<void> dispose() async {
    _initialized = false;
  }
}
