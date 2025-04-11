import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';

import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../features/users/models/user.dart';
import '../../../features/users/providers/user_provider.dart';
import '../models/challenge.dart';
import '../providers/challenge_provider.dart';

@RoutePage()
class ChallengeDetailScreen extends ConsumerStatefulWidget {
  final String challengeId;

  const ChallengeDetailScreen({
    Key? key,
    @PathParam('id') required this.challengeId,
  }) : super(key: key);

  @override
  ConsumerState<ChallengeDetailScreen> createState() => _ChallengeDetailScreenState();
}

class _ChallengeDetailScreenState extends ConsumerState<ChallengeDetailScreen> {
  @override
  void initState() {
    super.initState();
    
    // Carrega os detalhes do desafio quando a tela é montada
    Future.microtask(() {
      ref.read(challengeViewModelProvider.notifier).getChallengeDetails(widget.challengeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(challengeViewModelProvider);
    final currentUser = ref.watch(currentUserProvider);
    
    return state.maybeWhen(
      loading: () => const Scaffold(body: LoadingView()),
      error: (message) => Scaffold(
        appBar: AppBar(
          title: const Text('Erro'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.router.maybePop(),
          ),
        ),
        body: ErrorView(
          message: message,
          onRetry: () => ref.read(challengeViewModelProvider.notifier).getChallengeDetails(widget.challengeId),
        ),
      ),
      success: (challenges, filteredChallenges, selectedChallenge, pendingInvites, progressList, message) {
        if (selectedChallenge == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Desafio não encontrado')),
            body: const Center(
              child: Text('Não foi possível encontrar este desafio'),
            ),
          );
        }
        
        return _buildContent(context, ref, selectedChallenge, progressList, message, currentUser);
      },
      orElse: () => const Scaffold(body: LoadingView()),
    );
  }
  
  Scaffold _buildContent(
    BuildContext context,
    WidgetRef ref,
    Challenge challenge,
    List<ChallengeProgress> progressList,
    String? message,
    UserData? currentUser,
  ) {
    // Simplified implementation
    return Scaffold(
      appBar: AppBar(
        title: Text(challenge.title),
      ),
      body: Center(
        child: Text('Desafio ${challenge.title} carregado com sucesso!'),
      ),
    );
  }
} 