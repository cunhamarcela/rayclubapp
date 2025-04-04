import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../viewmodels/challenge_view_model.dart';
import '../widgets/challenge_card.dart';

@RoutePage()
class ChallengesListScreen extends ConsumerWidget {
  const ChallengesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(challengeViewModelProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Desafios'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(challengeViewModelProvider.notifier).loadChallenges(),
          ),
        ],
      ),
      body: state.maybeWhen(
        initial: () => const LoadingView(),
        loading: () => const LoadingView(),
        error: (message) => ErrorView(
          message: message,
          onRetry: () => ref.read(challengeViewModelProvider.notifier).loadChallenges(),
        ),
        success: (challenges, filteredChallenges, selectedChallenge, message) {
          if (filteredChallenges.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum desafio encontrado',
                style: TextStyle(fontSize: 16),
              ),
            );
          }
          
          return Column(
            children: [
              if (message != null)
                Container(
                  width: double.infinity,
                  color: Colors.green.shade100,
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    message,
                    style: TextStyle(color: Colors.green.shade700),
                    textAlign: TextAlign.center,
                  ),
                ),
              _buildCategoryTabs(context, ref),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredChallenges.length,
                  itemBuilder: (context, index) {
                    final challenge = filteredChallenges[index];
                    return ChallengeCard(
                      challenge: challenge,
                      onTap: () => context.router.pushNamed('/challenges/details/${challenge.id}'),
                    );
                  },
                ),
              ),
            ],
          );
        },
        orElse: () => const LoadingView(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.router.pushNamed('/challenges/new'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCategoryTabs(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(challengeViewModelProvider.notifier);
    
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildTabButton(
            'Todos',
            onTap: () => viewModel.loadChallenges(),
          ),
          _buildTabButton(
            'Ativos',
            onTap: () => viewModel.loadActiveChallenges(),
          ),
          _buildTabButton(
            'Meus Desafios',
            onTap: () {
              // TODO: Obter ID do usuário atual do Auth Provider
              final userId = 'user1'; // Temporário
              viewModel.loadUserChallenges(userId);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, {required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Text(label),
      ),
    );
  }
} 