import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ray_club_app/features/auth/viewmodels/auth_view_model.dart';
import 'package:ray_club_app/features/auth/models/auth_state.dart';

/// AuthGate é responsável por verificar o estado de autenticação do usuário
/// e redirecioná-lo para a tela apropriada (home ou login)
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);

    return authState.when(
      initial: () => const _LoadingScreen(),
      loading: () => const _LoadingScreen(),
      authenticated: (userId) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, '/home');
        });
        return const SizedBox.shrink();
      },
      unauthenticated: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, '/login');
        });
        return const SizedBox.shrink();
      },
      error: (message) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro: $message')),
          );
          Navigator.pushReplacementNamed(context, '/login');
        });
        return const SizedBox.shrink();
      },
    );
  }
}

/// Widget de loading exibido enquanto a verificação de autenticação ocorre
class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
