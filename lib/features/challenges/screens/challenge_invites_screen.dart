import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/app_loading.dart';
import '../models/challenge.dart';
import '../viewmodels/challenge_view_model.dart';
import 'challenge_detail_screen.dart';

/// Tela para visualizar e gerenciar convites de desafios
class ChallengeInvitesScreen extends ConsumerStatefulWidget {
  final String userId;

  const ChallengeInvitesScreen({
    super.key,
    required this.userId,
  });

  @override
  ConsumerState<ChallengeInvitesScreen> createState() => _ChallengeInvitesScreenState();
}

class _ChallengeInvitesScreenState extends ConsumerState<ChallengeInvitesScreen> {
  // Constantes para paginação
  static const int _pageSize = 10;
  int _currentPage = 0;
  List<ChallengeInvite> _displayedInvites = [];
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    // Carrega os convites pendentes ao iniciar a tela
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(challengeViewModelProvider.notifier)
          .loadPendingInvites(widget.userId);
    });
  }

  // Função para obter a página atual de convites do estado
  void _updateDisplayedInvites(List<ChallengeInvite> allInvites) {
    final int startIndex = _currentPage * _pageSize;
    
    if (startIndex >= allInvites.length) {
      // Se estamos além do final da lista, não há mais dados
      setState(() {
        _hasMoreData = false;
      });
      return;
    }
    
    // Calcular o índice final (não exceder o tamanho da lista)
    final int endIndex = (startIndex + _pageSize < allInvites.length) 
        ? startIndex + _pageSize 
        : allInvites.length;
    
    // Atualizar a lista exibida
    setState(() {
      if (_currentPage == 0) {
        // Se é a primeira página, substitui a lista
        _displayedInvites = allInvites.sublist(startIndex, endIndex);
      } else {
        // Senão, adiciona à lista existente
        _displayedInvites.addAll(allInvites.sublist(startIndex, endIndex));
      }
      
      // Verifica se há mais dados
      _hasMoreData = endIndex < allInvites.length;
    });
  }

  // Função para carregar mais convites
  void _loadMoreInvites(List<ChallengeInvite> allInvites) {
    if (!_hasMoreData) return;
    
    setState(() {
      _currentPage++;
    });
    
    _updateDisplayedInvites(allInvites);
  }

  // Função para recarregar os convites
  Future<void> _refreshInvites() async {
    setState(() {
      _currentPage = 0;
      _displayedInvites = [];
      _hasMoreData = true;
    });
    
    await ref.read(challengeViewModelProvider.notifier)
        .loadPendingInvites(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(challengeViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Convites de Desafios'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: state.when(
        initial: () => const Center(child: AppLoading()),
        loading: () => const Center(child: AppLoading()),
        success: (_, __, ___, invites, ____, message, _____) {
          // Inicializa os convites exibidos na primeira vez
          if (_displayedInvites.isEmpty && invites.isNotEmpty) {
            _updateDisplayedInvites(invites);
          }
          
          if (invites.isEmpty) {
            return const AppEmptyState(
              message: 'Você não tem convites pendentes',
              icon: Icons.mail,
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshInvites,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _displayedInvites.length + (_hasMoreData ? 1 : 0),
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      // Se for o último item e temos mais dados, mostrar o loader
                      if (index == _displayedInvites.length && _hasMoreData) {
                        _loadMoreInvites(invites);
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      
                      // Se for um item normal, mostrar o convite
                      if (index < _displayedInvites.length) {
                        final invite = _displayedInvites[index];
                        return _buildInviteCard(invite);
                      }
                      
                      return null;
                    },
                  ),
                ),
                
                // Exibir número de convites carregados
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Mostrando ${_displayedInvites.length} de ${invites.length} convites',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ),
              ],
            ),
          );
        },
        error: (message) => AppErrorWidget(
          message: message,
          onRetry: () => ref
              .read(challengeViewModelProvider.notifier)
              .loadPendingInvites(widget.userId),
        ),
      ),
    );
  }

  Widget _buildInviteCard(ChallengeInvite invite) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.emoji_events,
                  color: AppTheme.primaryColor,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    invite.challengeTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Convite enviado por ${invite.inviterName}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Data: ${_formatDate(invite.createdAt)}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _respondToInvite(invite.id, InviteStatus.declined),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Recusar'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _respondToInvite(invite.id, InviteStatus.accepted),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Aceitar'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () => _viewChallengeDetails(invite.challengeId),
                child: const Text('Ver detalhes do desafio'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _respondToInvite(String inviteId, InviteStatus status) {
    ref.read(challengeViewModelProvider.notifier).respondToInvite(
          inviteId: inviteId,
          status: status,
        );

    final message = status == InviteStatus.accepted
        ? 'Você aceitou o convite e entrou no desafio!'
        : 'Você recusou o convite';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _viewChallengeDetails(String challengeId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChallengeDetailScreen(challengeId: challengeId),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
} 