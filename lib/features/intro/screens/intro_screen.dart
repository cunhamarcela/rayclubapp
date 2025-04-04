import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui'; // Import para usar ImageFilter
import 'package:auto_route/auto_route.dart';
import 'package:ray_club_app/core/constants/app_colors.dart';
import 'package:ray_club_app/core/providers/providers.dart';

/// Tela de introdução (Splash/Intro) do Ray Club
/// Apresenta uma tela de boas-vindas com imagem de fundo, logo e botões de ação
@RoutePage()
class IntroScreen extends ConsumerWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('>>> IntroScreen carregada');
    
    // Verificar se o usuário está autenticado e redirecionar se necessário
    final authState = ref.watch(authViewModelProvider);
    
    // Se estiver autenticado, redirecionar para a tela principal
    authState.maybeWhen(
      authenticated: (user) {
        print('IntroScreen - Usuário autenticado: ${user.id}, redirecionando para HOME');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.router.replaceNamed('/');
        });
      },
      orElse: () {
        print('IntroScreen - Usuário não autenticado, mostrando intro');
      },
    );
    
    // Obtém as dimensões da tela para layouts responsivos
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Container(
        // Container principal com imagem de fundo
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/banner_bemvindo.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4), // Aumentado opacidade para efeito de desfoque
              BlendMode.darken,
            ),
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5), // Efeito de desfoque
          child: SafeArea(
            child: Column(
              children: [
                // Área expansível para ocupar espaço e empurrar o conteúdo para baixo
                const Spacer(),
                
                // Logo e Título
                _buildLogoSection(context),
                
                const SizedBox(height: 24),
                
                // Texto da jornada apenas
                _buildMessageSection(context),
                
                const Spacer(),
                
                // Botões de ação
                _buildActionButtons(context),
                
                // Espaço na parte inferior para segurança
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Constrói a seção do logo
  Widget _buildLogoSection(BuildContext context) {
    return Column(
      children: [
        // Logo minimalista sem fundo branco
        Text(
          'RAY\nCLUB',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 32,
          ),
        ),
      ],
    );
  }

  /// Constrói a seção de mensagens simplificada
  Widget _buildMessageSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          // Apenas o texto da jornada
          Text(
            'Sua jornada de bem-estar começa agora. Descubra treinos, nutrição e desafios pensados para você.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              height: 1.5,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói os botões de ação
  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          // Botão primário "Visualizar conteúdo" com cor marrom do Ray Club
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brown, // fundo marrom do Ray Club
                foregroundColor: Colors.white,    // texto branco
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                context.router.pushNamed('/');
              },
              child: const Text(
                'Visualizar conteúdo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Botão secundário "Login"
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                context.router.pushNamed('/login');
              },
              child: const Text(
                'Login',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 