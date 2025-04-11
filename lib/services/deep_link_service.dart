import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:uni_links/uni_links.dart';

// Project imports:
import '../core/di/base_service.dart';

/// Serviço para gerenciar deep links no aplicativo
class DeepLinkService implements BaseService {
  // Singleton instance
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  // Stream controller para enviar eventos de deep link
  final _deepLinkStreamController = StreamController<Uri?>.broadcast();
  
  // Stream para ouvir eventos de deep link
  Stream<Uri?> get deepLinkStream => _deepLinkStreamController.stream;
  
  // Stream subscription para o listener de links
  StreamSubscription? _linkSubscription;
  
  bool _initialized = false;
  
  @override
  bool get isInitialized => _initialized;
  
  /// Inicializa o serviço e começa a ouvir deep links
  @override
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    
    debugPrint("🔍 DeepLinkService: Inicializando serviço de deep links");
    
    // Tenta obter o link inicial se houver
    try {
      final initialLink = await getInitialLink();
      if (initialLink != null) {
        debugPrint("🔍 DeepLinkService: Link inicial detectado: $initialLink");
        final uri = Uri.parse(initialLink);
        _deepLinkStreamController.add(uri);
      } else {
        debugPrint("🔍 DeepLinkService: Nenhum link inicial detectado");
      }
    } catch (e) {
      debugPrint('❌ DeepLinkService: Erro ao obter link inicial: $e');
    }
    
    // Começa a ouvir por links futuros
    try {
      _linkSubscription = linkStream.listen((String? link) {
        debugPrint("🔍 DeepLinkService: Evento de link recebido: $link");
        if (link != null) {
          try {
            final uri = Uri.parse(link);
            debugPrint("✅ DeepLinkService: Link processado como URI: ${uri.toString()}");
            debugPrint("✅ DeepLinkService: Esquema: ${uri.scheme}, Host: ${uri.host}, Path: ${uri.path}");
            
            _deepLinkStreamController.add(uri);
            
            if (isAuthLink(uri)) {
              debugPrint("🔑 DeepLinkService: Detectado link de autenticação!");
              
              // Extrair informações de autenticação do URI
              if (uri.fragment.isNotEmpty) {
                debugPrint("🔑 DeepLinkService: Informações no fragmento: ${uri.fragment}");
              }
              
              if (uri.queryParameters.isNotEmpty) {
                debugPrint("🔑 DeepLinkService: Parâmetros de consulta: ${uri.queryParameters}");
              }
            }
          } catch (e) {
            debugPrint('❌ DeepLinkService: Erro ao processar link: $e');
          }
        }
      }, onError: (e) {
        debugPrint('❌ DeepLinkService: Erro no stream de links: $e');
      });
      
      debugPrint("✅ DeepLinkService: Listener de links configurado com sucesso");
    } catch (e) {
      debugPrint('❌ DeepLinkService: Erro ao configurar listener de links: $e');
    }
  }
  
  /// Força a captura manual de um link
  void processLink(String link) {
    try {
      debugPrint('🔍 DeepLinkService: Processando link manualmente: $link');
      final uri = Uri.parse(link);
      _deepLinkStreamController.add(uri);
      debugPrint('✅ DeepLinkService: Link manual processado com sucesso');
    } catch (e) {
      debugPrint('❌ DeepLinkService: Erro ao processar link manualmente: $e');
    }
  }
  
  /// Encerra o serviço, cancelando os listeners
  @override
  Future<void> dispose() async {
    if (!_initialized) return;
    
    debugPrint("🔍 DeepLinkService: Encerrando serviço de deep links");
    await _linkSubscription?.cancel();
    await _deepLinkStreamController.close();
    _initialized = false;
  }
  
  /// Verifica se um link é um link de autenticação
  bool isAuthLink(Uri uri) {
    // Esquema padrão para deep linking no app
    final isRayClubScheme = uri.scheme == 'rayclub';
    final isLoginCallback = uri.host == 'login-callback';
    final isAuth = isRayClubScheme && isLoginCallback;
    
    debugPrint('🔍 DeepLinkService: Verificando link $uri');
    debugPrint('🔍 DeepLinkService: Esquema: ${uri.scheme} (esperado: rayclub) - Match: $isRayClubScheme');
    debugPrint('🔍 DeepLinkService: Host: ${uri.host} (esperado: login-callback) - Match: $isLoginCallback');
    debugPrint('🔍 DeepLinkService: É link de autenticação: $isAuth');
    
    return isAuth;
  }
  
  /// Método para exibir informações sobre a configuração do deep link
  void printDeepLinkInfo() {
    debugPrint('🔍 ----- INFORMAÇÕES DE DEEP LINKING -----');
    debugPrint('🔍 DeepLinkService inicializado: $_initialized');
    debugPrint('🔍 Formato esperado de URL: rayclub://login-callback/'); 
    debugPrint('🔍 Configuração necessária:');
    debugPrint('🔍   - Android: <data android:scheme="rayclub" android:host="login-callback" />');
    debugPrint('🔍   - iOS: CFBundleURLSchemes array com <string>rayclub</string>');
    debugPrint('🔍   - iOS: FlutterDeepLinkingEnabled key com <true/>');
    debugPrint('🔍   - Supabase: Redirect URL deve incluir rayclub://login-callback/');
    debugPrint('🔍   - GCP: https://[ID DO PROJETO].supabase.co/auth/v1/callback');
    
    // Testar reconhecimento com links de exemplo
    final testUri1 = Uri.parse('rayclub://login-callback/');
    final testUri2 = Uri.parse('rayclub://login-callback/?token=1234');
    final testUri3 = Uri.parse('https://rayclub.vercel.app/auth/callback');
    
    debugPrint('🔍 Teste URI 1: $testUri1 => isAuthLink: ${isAuthLink(testUri1)}');
    debugPrint('🔍 Teste URI 2: $testUri2 => isAuthLink: ${isAuthLink(testUri2)}');
    debugPrint('🔍 Teste URI 3: $testUri3 => isAuthLink: ${isAuthLink(testUri3)}');
    debugPrint('🔍 ----- FIM DAS INFORMAÇÕES DE DEEP LINKING -----');
  }
} 