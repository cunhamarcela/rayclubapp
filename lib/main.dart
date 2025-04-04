import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/config/app_config.dart';
import 'core/di/service_locator.dart';
import 'core/errors/error_handler.dart';
import 'core/providers/service_providers.dart';
import 'core/router/app_router.dart';
import 'core/constants/app_colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ray_club_app/utils/performance_monitor.dart';

/// Entry point of the application
void main() async {
  debugPrint('🟢 MAIN ATUAL EXECUTADA');
  
  try {
    // Ensure Flutter bindings are initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Set preferred orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    // Carregar variáveis de ambiente
    await dotenv.load();

    // Initialize app configuration
    await AppConfig.initialize();

    // Initialize Supabase client
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
      debug: AppConfig.isDevelopment,
    );

    // Initialize SharedPreferences
    await SharedPreferences.getInstance();

    // Initialize dependencies
    await initializeDependencies();
    
    // Cria um observador que será configurado após a criação do container
    final appObserver = AppProviderObserver();
    
    // Criar o container para os providers
    final container = ProviderContainer(
      observers: [appObserver],
    );
    
    // Agora que o container existe, configuramos o observador com ele
    appObserver.setContainer(container);
    
    // Configurar o serviço de log remoto para o ErrorHandler global
    ErrorHandler.setRemoteLoggingService(container.read(remoteLoggingServiceProvider));

    // Configurar o PerformanceMonitor para monitorar operações críticas
    PerformanceMonitor.setRemoteLoggingService(container.read(remoteLoggingServiceProvider));

    // Run the app with error handling
    runApp(
      UncontrolledProviderScope(
        container: container,
        child: const MyApp(),
      ),
    );
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

/// Main application widget
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final router = ref.watch(appRouterProvider);
        return MaterialApp.router(
          title: 'Ray Club',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          routerConfig: router.config(),
        );
      },
    );
  }
}

/// Global navigator key for use throughout the app
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
