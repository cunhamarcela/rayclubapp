import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ray_club_app/features/auth/viewmodels/auth_view_model.dart';

/// Guarda de rotas para verificar autenticação
/// Redireciona para login se o usuário não estiver autenticado
class AuthGuard extends AutoRouteGuard {
  final ProviderRef ref;

  AuthGuard(this.ref);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final authState = ref.read(authViewModelProvider);
    
    authState.maybeWhen(
      authenticated: (_) {
        // O usuário está autenticado, permitir navegação
        resolver.next(true);
      },
      orElse: () {
        // Usuário não autenticado, redirecionar para login
        router.pushNamed('/login');
        resolver.next(false);
      },
    );
  }
} 