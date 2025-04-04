import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ray_club_app/core/router/app_router.dart';
import 'package:ray_club_app/shared/bottom_navigation_bar.dart';
import 'package:ray_club_app/core/constants/app_colors.dart';
import 'package:ray_club_app/features/home/widgets/register_exercise_sheet.dart';
import 'package:ray_club_app/features/profile/viewmodels/profile_view_model.dart';
import 'package:ray_club_app/shared/widgets/error_view.dart';
import 'package:ray_club_app/shared/widgets/loading_view.dart';

@RoutePage()
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Carrega o perfil do usuário quando a tela é inicializada
    Future.microtask(() {
      ref.read(profileViewModelProvider.notifier).loadCurrentUserProfile();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileViewModelProvider);
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: profileState.when(
          initial: () => const LoadingView(message: 'Carregando perfil...'),
          loading: () => const LoadingView(message: 'Carregando perfil...'),
          updating: (profile) => _buildProfileContent(context, profile),
          loaded: (profile) => _buildProfileContent(context, profile),
          error: (message) => ErrorView(
            message: message,
            onRetry: () => ref.read(profileViewModelProvider.notifier).loadCurrentUserProfile(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showRegisterExerciseSheet(context);
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: const SharedBottomNavigationBar(currentIndex: 3),
    );
  }
  
  Widget _buildProfileContent(BuildContext context, profile) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text(
            'Perfil',
            style: TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                // TODO: Implementar tela de configurações
              },
              icon: const Icon(Icons.settings),
              color: AppColors.textDark,
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Meu perfil',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 20),
                // Perfil do usuário
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Avatar
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColors.primaryLight.withOpacity(0.3),
                          child: profile.photoUrl != null
                              ? ClipOval(
                                  child: Image.network(
                                    profile.photoUrl!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                )
                              : const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: AppColors.primary,
                                ),
                        ),
                        const SizedBox(height: 16),
                        // Nome
                        Text(
                          profile.name ?? 'Usuário',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Email
                        Text(
                          profile.email ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (profile.bio != null && profile.bio!.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          // Bio
                          Text(
                            profile.bio!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        // Botão de editar perfil
                        ElevatedButton(
                          onPressed: () {
                            // TODO: Implementar edição de perfil
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text("Editar Perfil"),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Seção de estatísticas
                const Text(
                  'Estatísticas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard('Treinos', '${profile.completedWorkouts}', Icons.fitness_center),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard('Sequência', '${profile.streak} dias', Icons.trending_up),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard('Pontos', '${profile.points}', Icons.star),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Seção de objetivos (opcional)
                if (profile.goals.isNotEmpty) ...[
                  const Text(
                    'Meus objetivos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: profile.goals.map((goal) => Chip(
                      label: Text(goal),
                      backgroundColor: AppColors.primaryLight.withOpacity(0.2),
                      labelStyle: const TextStyle(color: AppColors.primary),
                    )).toList(),
                  ),
                  const SizedBox(height: 20),
                ],
                // Opções de menu
                _buildMenuCard('Meus dados', Icons.person_outline, () {
                  // TODO: Implementar acesso aos dados do usuário
                }),
                _buildMenuCard('Meus treinos salvos', Icons.favorite_outline, () {
                  // TODO: Implementar acesso aos treinos salvos
                }),
                _buildMenuCard('Histórico de atividades', Icons.history, () {
                  // TODO: Implementar histórico
                }),
                _buildMenuCard('Ajuda e suporte', Icons.help_outline, () {
                  // TODO: Implementar tela de ajuda
                }),
                _buildMenuCard('Sair', Icons.exit_to_app, () {
                  // TODO: Implementar logout
                }, isLogout: true),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMenuCard(String title, IconData icon, VoidCallback onTap, {bool isLogout = false}) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isLogout ? Colors.red : AppColors.primary,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isLogout ? Colors.red : AppColors.textDark,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
} 