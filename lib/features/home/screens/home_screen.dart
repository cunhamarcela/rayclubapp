import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ray_club_app/core/constants/app_colors.dart';
import 'package:ray_club_app/core/providers/providers.dart';
import 'package:ray_club_app/features/home/models/featured_content.dart';
import 'package:ray_club_app/features/home/models/home_model.dart';
import 'package:ray_club_app/features/home/viewmodels/states/home_state.dart';
import 'package:ray_club_app/features/home/widgets/register_exercise_sheet.dart';
import 'package:ray_club_app/shared/bottom_navigation_bar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:ray_club_app/features/home/viewmodels/home_view_model.dart';
import 'package:ray_club_app/features/home/viewmodels/featured_content_view_model.dart';

@RoutePage()
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);
    final authState = ref.watch(authViewModelProvider);

    // Verifica se é guest
    final bool isGuest = authState.maybeWhen(
      unauthenticated: () => true, 
      orElse: () => false
    );
    
    // Nome do usuário (para personalização)
    final String username = authState.maybeWhen(
      authenticated: (user) => user.name?.split(' ')[0] ?? "Raygirl",
      orElse: () => "Raygirl"
    );

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.2),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Icon(
                  Icons.fitness_center,
                  size: 20,
                  color: AppColors.primaryLight,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'RayClub',
              style: TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.w600,
                fontSize: 20,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
            color: AppColors.textDark,
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: () {},
            color: AppColors.textDark,
          ),
        ],
      ),
      body: homeState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : homeState.error != null
              ? Center(child: Text('Erro: ${homeState.error}'))
              : homeState.data != null
                  ? _buildHomeContent(context, username, homeState.data!, ref)
                  : const Center(child: Text('Sem dados disponíveis')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showRegisterExerciseSheet(context);
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: const SharedBottomNavigationBar(currentIndex: 0),
    );
  }

  // Conteúdo principal da tela
  Widget _buildHomeContent(BuildContext context, String username, HomeData data, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () => ref.read(homeViewModelProvider.notifier).loadHomeData(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Saudação personalizada
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Text(
                'Olá, $username!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ),
            
            // Banner promocional
            _buildPromotionalBanner(context, data.banners, ref),
            
            // Mini dashboard de progresso
            _buildProgressDashboard(context, data.progress),
            
            // Registrar treino
            _buildRegisterWorkoutButton(context),
            
            // Categorias de treinos
            _buildCategoriesSection(context, data.categories),
            
            // Treinos populares
            _buildPopularWorkoutsSection(context, data.popularWorkouts),
            
            // Conteúdos em destaque
            _buildFeaturedContentSection(context),
            
            // Seção de Treinos
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Treinos',
                    style: AppTypography.headingSmall.copyWith(color: AppColors.white),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/workouts');
                    },
                    child: Text(
                      'Ver Todos',
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/workouts'),
                    child: Container(
                      width: 200,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary.withOpacity(0.8),
                            AppColors.primary.withOpacity(0.4),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            index == 0 ? Icons.fitness_center : 
                            index == 1 ? Icons.directions_run : Icons.self_improvement,
                            color: AppColors.white,
                            size: 28,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            index == 0 ? 'Treino de Força' : 
                            index == 1 ? 'Treino Cardio' : 'Yoga',
                            style: AppTypography.bodyLarge.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Banner promocional
  Widget _buildPromotionalBanner(BuildContext context, List<BannerItem> banners, WidgetRef ref) {
    final currentIndex = ref.watch(homeViewModelProvider).currentBannerIndex;
    
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: PageView.builder(
        itemCount: banners.length,
        onPageChanged: (index) {
          ref.read(homeViewModelProvider.notifier).updateBannerIndex(index);
        },
        itemBuilder: (context, index) {
          final banner = banners[index];
          return _buildBannerItem(
            banner.title,
            banner.subtitle,
            banner.imageUrl,
            context,
          );
        },
      ),
    );
  }

  // Item individual do banner
  Widget _buildBannerItem(String title, String subtitle, String imagePath, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          // Verifica se é um asset ou URL remota
          image: imagePath.startsWith('assets/') 
              ? AssetImage(imagePath) as ImageProvider
              : NetworkImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.7),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'DESTAQUE',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Mini dashboard de progresso do usuário
  Widget _buildProgressDashboard(BuildContext context, UserProgress progress) {
    // ... o resto do método permanece igual, mas usando o progress passado como parâmetro
    // ... adaptar conforme necessário
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seu Progresso',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildProgressItem(
                'Dias Treinados',
                progress.daysTrainedThisMonth.toString(),
                Icons.calendar_today,
                AppColors.primary,
              ),
              _buildProgressItem(
                'Sequência',
                progress.currentStreak.toString(),
                Icons.local_fire_department,
                Colors.orange,
              ),
              _buildProgressItem(
                'Melhor',
                progress.bestStreak.toString(),
                Icons.emoji_events,
                Colors.amber,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progresso no Desafio',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    '${progress.challengeProgress}%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress.challengeProgress / 100,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textMedium,
          ),
        ),
      ],
    );
  }

  // Botão para registrar treino
  Widget _buildRegisterWorkoutButton(BuildContext context) {
    // ... implementação existente
    return GestureDetector(
      onTap: () {
        showRegisterExerciseSheet(context);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.2),
              child: const Icon(
                Icons.fitness_center,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Registrar Treino',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Adicione seu treino de hoje',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  // Categorias de treinos
  Widget _buildCategoriesSection(BuildContext context, List<WorkoutCategory> categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Categorias de Treino',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return _buildCategoryItem(
                category.name,
                category.iconUrl,
                category.workoutCount,
                category.colorHex ?? '#3F51B5',
                context,
              );
            }
          ),
        ),
      ],
    );
  }

  // Item individual de categoria
  Widget _buildCategoryItem(String title, String iconPath, int count, String colorHex, BuildContext context) {
    // Converter hex para Color
    final color = Color(int.parse(colorHex.substring(1), radix: 16) + 0xFF000000);
    
    return Container(
      width: 100,
      margin: const EdgeInsets.all(4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: iconPath.startsWith('assets/')
                  ? Image.asset(
                      iconPath,
                      width: 30,
                      height: 30,
                      color: color,
                    )
                  : Icon(Icons.fitness_center, color: color, size: 30),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textDark,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            '$count treinos',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textMedium,
            ),
          ),
        ],
      ),
    );
  }

  // Seção de treinos populares
  Widget _buildPopularWorkoutsSection(BuildContext context, List<PopularWorkout> workouts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Treinos Populares',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Ver Todos',
                  style: TextStyle(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              final workout = workouts[index];
              return _buildWorkoutItem(
                workout.title,
                workout.duration,
                workout.difficulty,
                workout.imageUrl,
                workout.favoriteCount,
                context,
              );
            },
          ),
        ),
      ],
    );
  }

  // Item individual de treino
  Widget _buildWorkoutItem(String title, String duration, String difficulty, String imageUrl, int favoriteCount, BuildContext context) {
    return Container(
      width: 180,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: imageUrl.startsWith('assets/')
                ? Image.asset(
                    imageUrl,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    imageUrl,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: AppColors.textMedium,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      duration,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMedium,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        difficulty,
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.favorite,
                      size: 14,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$favoriteCount',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMedium,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Seção de conteúdos em destaque
  Widget _buildFeaturedContentSection(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final featuredContentState = ref.watch(featuredContentViewModelProvider);
        
        // Exibir loader durante o carregamento
        if (featuredContentState.isLoading && featuredContentState.contents.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        
        // Exibir mensagem de erro
        if (featuredContentState.error != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('Erro ao carregar conteúdos: ${featuredContentState.error}'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(featuredContentViewModelProvider.notifier).loadFeaturedContents();
                    },
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            ),
          );
        }
        
        // Se não tem conteúdos, mostrar mensagem
        if (featuredContentState.contents.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text('Nenhum conteúdo em destaque disponível no momento.'),
            ),
          );
        }
        
        // Lista de conteúdos
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Conteúdos para você',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navegação para a tela de todos os conteúdos (será implementada futuramente)
                    },
                    child: Text(
                      'Ver Todos',
                      style: TextStyle(
                        color: AppColors.primaryLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                for (var i = 0; i < featuredContentState.contents.length; i++)
                  _buildFeaturedContentCard(featuredContentState.contents[i], context),
              ],
            ),
          ],
        );
      },
    );
  }

  // Card de conteúdo em destaque
  Widget _buildFeaturedContentCard(FeaturedContent content, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Navegar para a tela de detalhes
            context.router.pushNamed('/featured-content/${content.id}');
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Ícone com cor baseada na categoria
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: content.category.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    content.icon,
                    color: content.category.color,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                // Textos
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        content.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        content.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Badge de categoria
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: content.category.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          content.category.name,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: content.category.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Ícone de seta
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF999999),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}












