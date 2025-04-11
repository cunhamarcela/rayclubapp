// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

// Project imports:
import 'package:ray_club_app/utils/performance_monitor.dart';
import 'core/config/app_config.dart';
import 'core/config/environment.dart';
import 'core/constants/app_colors.dart';
import 'core/di/service_locator.dart';
import 'core/errors/error_handler.dart';
import 'core/providers/service_providers.dart';
import 'core/router/app_router.dart';
import 'core/services/cache_service.dart';
import 'services/deep_link_service.dart';
import 'core/config/theme.dart';

// Adicionar no topo do arquivo, após os imports existentes
import 'dart:async';

/// Entry point of the application
void main() async {
  debugPrint('🟢 MAIN ATUAL EXECUTADA');
  
  try {
    // Ensure Flutter bindings are initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize date formatting for locales
    await initializeDateFormatting('pt_BR', null);
    Intl.defaultLocale = 'pt_BR';

    // Set preferred orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    // Carregar variáveis de ambiente
    await dotenv.load();

    // Initialize app configuration
    await AppConfig.initialize();
    
    // Validar se o ambiente está configurado corretamente
    if (!EnvironmentManager.validateEnvironment()) {
      debugPrint('⚠️ AVISO: Configuração de ambiente incompleta!');
    }
    
    debugPrint('✅ AppConfig inicializado (Ambiente: ${EnvironmentManager.current})');

    // Initialize Supabase client
    await Supabase.initialize(
      url: EnvironmentManager.supabaseUrl,
      anonKey: EnvironmentManager.supabaseAnonKey,
      debug: EnvironmentManager.debugMode,
    );
    debugPrint('✅ Supabase inicializado');

    // Adicionar verificação de tabelas necessárias
    try {
      debugPrint('🔍 Verificando tabelas do Supabase');
      final supabase = Supabase.instance.client;
      
      // Verificar se pelo menos uma tabela essencial existe
      try {
        await supabase.from('workouts').select('id').limit(1);
        debugPrint('✅ Tabela workouts verificada');
      } catch (e) {
        debugPrint('⚠️ Aviso: Tabela workouts não existe ou não está acessível');
        debugPrint('⚠️ Erro: $e');
      }
      
      try {
        await supabase.from('banners').select('id').limit(1);
        debugPrint('✅ Tabela banners verificada');
      } catch (e) {
        debugPrint('⚠️ Aviso: Tabela banners não existe ou não está acessível');
        debugPrint('⚠️ Erro: $e');
      }
      
      try {
        await supabase.from('user_progress').select('id').limit(1);
        debugPrint('✅ Tabela user_progress verificada');
      } catch (e) {
        debugPrint('⚠️ Aviso: Tabela user_progress não existe ou não está acessível');
        debugPrint('⚠️ Erro: $e');
      }
    } catch (e) {
      debugPrint('⚠️ Erro ao verificar tabelas: $e');
    }

    // Initialize SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    
    // Check and print the current value of has_seen_intro
    final hasSeenIntro = prefs.getBool('has_seen_intro');
    debugPrint('🔍 Current has_seen_intro value: $hasSeenIntro');
    
    // FORCE RESET the has_seen_intro flag to false for testing
    await prefs.setBool('has_seen_intro', false);
    debugPrint('⚠️ FORCED RESET: has_seen_intro flag set to false for testing');
    
    // NÃO marcar has_seen_intro como true durante inicialização
    // O flag deve ser marcado apenas após o usuário realmente ver a introdução
    // final hasSeenIntro = prefs.getBool('has_seen_intro') ?? false;
    // if (!hasSeenIntro) {
    //   await prefs.setBool('has_seen_intro', true);
    // }
    
    debugPrint('✅ SharedPreferences inicializado');

    // Initialize dependencies
    await initializeDependencies();
    debugPrint('✅ Dependências inicializadas');
    
    // Cria um observador que será configurado após a criação do container
    final appObserver = AppProviderObserver();
    
    // Criar o CacheService que será usado no container
    final cacheService = SharedPrefsCacheService(prefs);
    
    // Criar o container para os providers com os overrides necessários
    final container = ProviderContainer(
      observers: [appObserver],
      overrides: [
        // Sobrescrever o provider do CacheService com uma instância já inicializada
        cacheServiceProvider.overrideWithValue(cacheService),
        // Sobrescrever o provider do SharedPreferences com a instância já inicializada
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );
    
    // Agora que o container existe, configuramos o observador com ele
    appObserver.setContainer(container);
    
    // Configurar o serviço de log remoto para o ErrorHandler global
    // ErrorHandler.setRemoteLoggingService(container.read(remoteLoggingServiceProvider));

    // Configurar o PerformanceMonitor para monitorar operações críticas
    PerformanceMonitor.setRemoteLoggingService(container.read(remoteLoggingServiceProvider));

    // Configurar deferred loading para otimização do tamanho do aplicativo
    if (kReleaseMode) {
      // Pré-carregar bibliotecas principais
      await _preloadCoreLibraries();
    }

    // Pré-carregamento de fontes para evitar problemas com o Impeller
    await precacheFontFamilies();

    // Run the app with error handling
    runApp(
      UncontrolledProviderScope(
        container: container,
        child: const MyApp(),
      ),
    );
    debugPrint('🚀 App inicializado e rodando');

    // Adicionar diagnóstico de Deep Link após inicialização
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (kDebugMode) {
        final deepLinkService = getIt<DeepLinkService>();
        deepLinkService.printDeepLinkInfo();
        
        // Testar um deep link manualmente (descomentar para testar)
        // deepLinkService.processLink('rayclub://login-callback/?token=test');
      }
    });
  } catch (e, stackTrace) {
    // Log fatal error and show error screen
    debugPrint('Fatal error during initialization: $e\n$stackTrace');
    runApp(const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            'Erro ao inicializar o aplicativo.\nPor favor, tente novamente.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ));
  }
}

/// Carrega bibliotecas principais de forma otimizada
Future<void> _preloadCoreLibraries() async {
  // Implementar lazy loading para features menos usadas
  unawaited(_initializeDeferredLibraries());
}

/// Inicializa bibliotecas sob demanda para reduzir o tamanho inicial do app
Future<void> _initializeDeferredLibraries() async {
  // Esta função será chamada após o app iniciar
  // Carregar bibliotecas em segundo plano para melhorar o tempo de inicialização
  
  // Exemplo de uso:
  // await DeferredFeature.ensureInitialized();
}

/// Pré-carrega fontes utilizadas na aplicação para evitar problemas de renderização com o Impeller
Future<void> precacheFontFamilies() async {
  // Skip loading Poppins fonts as they appear to be empty files
  
  // Carrega as fontes Century Gothic
  final fontLoaderCentury = FontLoader('CenturyGothic');
  fontLoaderCentury.addFont(rootBundle.load('assets/fonts/Century-Gothic.ttf'));
  fontLoaderCentury.addFont(rootBundle.load('assets/fonts/Century-Gothic-Bold.TTF')); // Note the uppercase TTF
  
  // Carrega as fontes Stinger
  final fontLoaderStinger = FontLoader('Stinger');
  fontLoaderStinger.addFont(rootBundle.load('assets/fonts/Stinger-Regular.ttf'));
  fontLoaderStinger.addFont(rootBundle.load('assets/fonts/Stinger-Bold.ttf'));
  
  // Aguarda o carregamento de todas as fontes
  await Future.wait([
    fontLoaderCentury.load(),
    fontLoaderStinger.load(),
  ]);
}

/// Main application widget
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('🔍 Building MyApp');
    return Consumer(
      builder: (context, ref, _) {
        final router = ref.watch(appRouterProvider);
        debugPrint('🔍 Configurando router - rota inicial: ${AppRoutes.intro}');
        
        return MaterialApp.router(
          title: 'Ray Club',
          theme: AppTheme.lightTheme,
          routerConfig: router.config(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

/// Global navigator key for use throughout the app
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
