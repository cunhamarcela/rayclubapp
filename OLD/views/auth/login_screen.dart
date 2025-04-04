import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../view_models/auth_view_model.dart';
import '../../core/router/app_router.dart';
import '../../core/providers/providers.dart';
import 'widgets/email_input.dart';
import 'widgets/password_input.dart';
import 'widgets/primary_button.dart';
import 'widgets/google_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await ref.read(authViewModelProvider.notifier).signIn(
              _emailController.text.trim(),
              _passwordController.text,
            );

        if (mounted) {
          AppRouter.replaceWith(context, '/home');
        }
      } catch (e) {
        if (mounted) {
          _showErrorSnackBar(e.toString());
        }
      }
    }
  }

  Future<void> _handleGoogleLogin() async {
    try {
      // TODO: Implementar login com Google no AuthViewModel
      // await ref.read(authViewModelProvider.notifier).signInWithGoogle();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Login com Google ainda não implementado')),
      );
    } catch (e) {
      _showErrorSnackBar(e.toString());
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _navigateToForgotPassword() {
    // TODO: Implementar navegação para recuperação de senha
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Recuperação de senha ainda não implementada')),
    );
  }

  void _navigateToSignup() {
    AppRouter.navigateTo(context, '/signup');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final state = ref.watch(authViewModelProvider);

    // Redirecionar se já estiver autenticado
    state.maybeWhen(
      authenticated: (_) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AppRouter.replaceWith(context, '/home');
        });
      },
      orElse: () {},
    );

    // Usando pattern matching para determinar se está carregando
    final isLoading = state.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo centralizado
                // TODO: Adicionar logo com Hero animation quando tiver o asset
                Icon(
                  Icons.sports_gymnastics,
                  size: 80,
                  color: Colors.brown,
                ),
                const SizedBox(height: 48),

                // Campo de email com validação
                EmailInput(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  errorText: _emailError,
                  onEditingComplete: () => _passwordFocusNode.requestFocus(),
                ),
                const SizedBox(height: 16),

                // Campo de senha com toggle de visibilidade
                PasswordInput(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  errorText: _passwordError,
                  onEditingComplete: _handleLogin,
                ),
                const SizedBox(height: 12),

                // Link "Esqueceu a senha?"
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _navigateToForgotPassword,
                    child: Text(
                      'Esqueceu a senha?',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.brown[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Botão de login principal
                PrimaryButton(
                  text: 'Entrar',
                  onPressed: _handleLogin,
                  isLoading: isLoading,
                ),
                const SizedBox(height: 16),

                // Botão de login com Google
                GoogleButton(
                  onPressed: _handleGoogleLogin,
                  isLoading: isLoading,
                ),
                SizedBox(height: size.height * 0.05),

                // Link para cadastro
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Não tem uma conta? ",
                      style: theme.textTheme.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: _navigateToSignup,
                      child: Text(
                        "Cadastre-se",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                    ),
                  ],
                ),

                // Exibir erro se houver
                state.maybeWhen(
                  error: (message) => Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      message,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  orElse: () => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
