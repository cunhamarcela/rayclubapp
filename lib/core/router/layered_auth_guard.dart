// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:ray_club_app/core/router/app_router.dart';
import 'package:ray_club_app/features/auth/models/auth_state.dart';
import 'package:ray_club_app/features/auth/viewmodels/auth_view_model.dart';

/// Constante que define o intervalo mínimo entre verificações completas
/// de autenticação (em minutos)
const int AUTH_CHECK_INTERVAL_MINUTES = 15;

/// Guarda de rota em camadas para otimizar verificação de autenticação
class LayeredAuthGuard extends AutoRouteGuard {
  final ProviderRef _ref;
  
  // Armazena o timestamp da última verificação completa
  static int _lastFullAuthCheck = 0;

  LayeredAuthGuard(this._ref);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final targetPath = resolver.route.path;
    
    print('LayeredAuthGuard - Navegando para: $targetPath');
    
    // Rotas que não precisam de autenticação
    final nonAuthRoutes = [
      AppRoutes.intro,
      AppRoutes.login,
      AppRoutes.signup,
      AppRoutes.forgotPassword,
      AppRoutes.resetPassword,
    ];
    
    // Se for uma rota que não precisa de autenticação, permitir acesso
    if (nonAuthRoutes.contains(targetPath)) {
      print('LayeredAuthGuard - Permitindo acesso à rota pública: $targetPath');
      resolver.next(true);
      return;
    }
    
    // Verificar se o usuário já viu a tela de introdução
    final hasSeenIntro = GetIt.instance<SharedPreferences>().getBool('has_seen_intro') ?? false;
    if (!hasSeenIntro && targetPath != AppRoutes.intro) {
      // Se ainda não viu a introdução, redirecionar para introdução
      print('LayeredAuthGuard - Usuário ainda não viu intro, redirecionando para tela de introdução');
      router.replaceNamed(AppRoutes.intro);
      resolver.next(false);
      return;
    }
    
    // Leitura do estado de autenticação do cache
    final authViewModel = _ref.read(authViewModelProvider.notifier);
    final authState = _ref.read(authViewModelProvider);
    
    // 1. Verificação rápida baseada em cache
    final isAuthenticatedInCache = authState.maybeWhen(
      authenticated: (_) => true,
      orElse: () => false,
    );
    
    // 2. Determinar se é necessária uma verificação completa
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final needsFullCheck = 
        !isAuthenticatedInCache || 
        _isFullCheckNeeded(currentTime) ||
        authState.maybeWhen(
          initial: () => true,
          loading: () => true,
          orElse: () => false,
        );
    
    if (needsFullCheck) {
      print('LayeredAuthGuard - Realizando verificação completa de autenticação');
      await authViewModel.checkAuthStatus();
      _lastFullAuthCheck = currentTime;
    } else {
      print('LayeredAuthGuard - Usando estado em cache (última verificação há ${_getMinutesSinceLastCheck(currentTime)} minutos)');
    }
    
    // Ler o estado atualizado após verificação (se ocorreu)
    final updatedAuthState = _ref.read(authViewModelProvider);
    
    // Verificar se o usuário está autenticado no estado atual
    final isAuthenticated = updatedAuthState.maybeWhen(
      authenticated: (_) => true,
      orElse: () => false,
    );
    
    if (isAuthenticated) {
      // O usuário está autenticado, permitir navegação
      print('LayeredAuthGuard - Usuário autenticado, permitindo acesso');
      resolver.next(true);
    } else {
      // Armazenar no ViewModel a rota para redirecionamento posterior
      authViewModel.setRedirectPath(targetPath);
      
      print('LayeredAuthGuard - Usuário não autenticado, redirecionando para login');
      // Redirecionar para login
      router.navigateNamed(AppRoutes.login);
      resolver.next(false);
    }
  }
  
  /// Verifica se é necessário realizar uma verificação completa baseado no tempo
  bool _isFullCheckNeeded(int currentTime) {
    // Converter intervalo de minutos para milissegundos
    final intervalMs = AUTH_CHECK_INTERVAL_MINUTES * 60 * 1000;
    return (currentTime - _lastFullAuthCheck) > intervalMs;
  }
  
  /// Retorna quantos minutos se passaram desde a última verificação completa
  int _getMinutesSinceLastCheck(int currentTime) {
    return (currentTime - _lastFullAuthCheck) ~/ (60 * 1000);
  }
} 