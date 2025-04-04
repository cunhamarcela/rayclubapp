import 'package:dio/dio.dart';
import 'package:ray_club_app/models/nutrition_item.dart';
import 'package:ray_club_app/services/supabase_service.dart';

/// Repositório para gerenciar dados de nutrição
class NutritionRepository {
  final SupabaseService _supabaseService;
  final Dio _dio;

  NutritionRepository(this._supabaseService, this._dio);

  /// Obtém todos os itens de nutrição do banco de dados
  Future<List<NutritionItem>> getNutritionItems() async {
    // Retorna dados fictícios em vez de acessar o Supabase
    await Future.delayed(const Duration(milliseconds: 800)); // Simulando tempo de carregamento
    return _getMockNutritionItems();
  }

  /// Obtém itens de nutrição filtrados por categoria
  Future<List<NutritionItem>> getNutritionItemsByCategory(String category) async {
    // Retorna dados fictícios filtrados por categoria
    await Future.delayed(const Duration(milliseconds: 600));
    final allItems = _getMockNutritionItems();
    if (category.isEmpty) {
      return allItems;
    }
    return allItems.where((item) => item.category.toLowerCase() == category.toLowerCase()).toList();
  }

  /// Obtém um item de nutrição específico pelo ID
  Future<NutritionItem> getNutritionItemById(String id) async {
    // Retorna um item fictício com o ID especificado
    await Future.delayed(const Duration(milliseconds: 300));
    final allItems = _getMockNutritionItems();
    final item = allItems.firstWhere(
      (item) => item.id == id,
      orElse: () => allItems.first, // Fallback para o primeiro item se não encontrar
    );
    return item;
  }

  /// Obtém itens de nutrição destacados
  Future<List<NutritionItem>> getFeaturedNutritionItems() async {
    // Retorna itens fictícios marcados como destacados
    await Future.delayed(const Duration(milliseconds: 500));
    final allItems = _getMockNutritionItems();
    return allItems.where((item) => item.isFeatured).toList();
  }

  /// Retorna uma lista de itens de nutrição fictícios para visualização
  List<NutritionItem> _getMockNutritionItems() {
    return [
      NutritionItem(
        id: '1',
        title: 'Salada de Quinoa com Legumes',
        description: 'Uma salada completa rica em proteínas e nutrientes essenciais para o pós-treino.',
        category: 'recipe',
        imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=2070&auto=format&fit=crop',
        preparationTimeMinutes: 20,
        ingredients: [
          '1 xícara de quinoa cozida',
          '1/2 pimentão vermelho picado',
          '1/2 pepino picado',
          '1/4 xícara de cenoura ralada',
          '2 colheres de sopa de azeite de oliva',
          'Suco de 1/2 limão',
          'Sal e pimenta a gosto',
          '1/4 xícara de ervas frescas picadas (coentro, salsa)',
        ],
        instructions: [
          'Cozinhe a quinoa de acordo com as instruções da embalagem e deixe esfriar.',
          'Em uma tigela grande, misture a quinoa com os legumes picados.',
          'Em um recipiente separado, misture o azeite, suco de limão, sal e pimenta para fazer o molho.',
          'Despeje o molho sobre a salada e misture bem.',
          'Adicione as ervas frescas por cima e sirva.',
        ],
        tags: ['Proteína', 'Pós-treino', 'Vegano'],
        isFeatured: true,
        nutritionistTip: 'A quinoa é um pseudocereal completo que contém todos os aminoácidos essenciais, tornando-a uma excelente fonte de proteína vegetal para recuperação muscular.',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        author: 'nutri',
      ),
      NutritionItem(
        id: '2',
        title: 'Smoothie de Banana e Proteína',
        description: 'Bebida rápida e nutritiva ideal para o pré-treino ou recuperação muscular.',
        category: 'recipe',
        imageUrl: 'https://images.unsplash.com/photo-1594488526596-d3e7c8a8685d?q=80&w=1964&auto=format&fit=crop',
        preparationTimeMinutes: 5,
        ingredients: [
          '1 banana madura',
          '1 scoop de proteína em pó (whey ou vegetal)',
          '1 colher de sopa de pasta de amendoim natural',
          '1 xícara de leite (animal ou vegetal)',
          '3-4 cubos de gelo',
          '1 colher de chá de mel (opcional)',
        ],
        instructions: [
          'Adicione todos os ingredientes no liquidificador.',
          'Bata até obter uma mistura homogênea e cremosa.',
          'Se necessário, ajuste a consistência adicionando mais leite.',
          'Sirva imediatamente.',
        ],
        tags: ['Pré-treino', 'Recuperação', 'Rápido'],
        isFeatured: false,
        nutritionistTip: 'Consumir carboidratos e proteínas antes do treino ajuda a melhorar o desempenho e reduzir o catabolismo muscular. A banana fornece energia rápida e a proteína auxilia na recuperação.',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        author: 'ray',
      ),
      NutritionItem(
        id: '3',
        title: 'Bowl de Açaí Energético',
        description: 'Um bowl refrescante e nutritivo perfeito para repor as energias após o treino.',
        category: 'recipe',
        imageUrl: 'https://images.unsplash.com/photo-1631656098239-b10bec923117?q=80&w=2071&auto=format&fit=crop',
        preparationTimeMinutes: 10,
        ingredients: [
          '200g de polpa de açaí congelada',
          '1 banana congelada',
          '1/2 xícara de leite ou substituto vegetal',
          '1 colher de sopa de mel ou agave',
          'Toppings: granola, banana fatiada, morangos, amêndoas fatiadas, coco ralado',
        ],
        instructions: [
          'No liquidificador, bata o açaí congelado com a banana congelada e o leite até obter uma mistura homogênea.',
          'Adicione o mel ou agave e pulse mais algumas vezes.',
          'Transfira para uma tigela e adicione os toppings de sua preferência.',
          'Sirva imediatamente para aproveitar a consistência ideal.',
        ],
        tags: ['Energia', 'Antioxidantes', 'Pós-treino'],
        isFeatured: false,
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
        author: 'nutri',
      ),
      NutritionItem(
        id: '4',
        title: 'Hidratação estratégica durante o treino',
        description: 'Dicas fundamentais para manter-se adequadamente hidratado durante os exercícios e maximizar o desempenho.',
        category: 'tip',
        imageUrl: 'https://images.unsplash.com/photo-1532938911079-1b06ac7ceec7?q=80&w=2071&auto=format&fit=crop',
        preparationTimeMinutes: 3,
        tags: ['Hidratação', 'Desempenho', 'Saúde'],
        isFeatured: true,
        nutritionistTip: 'Beba água em pequenas quantidades ao longo do treino, não espere sentir sede. A sede já é um sinal de desidratação leve. Para treinos intensos com mais de uma hora, considere bebidas com eletrólitos para repor os minerais perdidos pelo suor.',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        author: 'nutri',
      ),
      NutritionItem(
        id: '5',
        title: 'Como equilibrar carboidratos para diferentes objetivos',
        description: 'Entenda como ajustar seu consumo de carboidratos de acordo com seus objetivos de treino e composição corporal.',
        category: 'tip',
        imageUrl: 'https://images.unsplash.com/photo-1498837167922-ddd27525d352?q=80&w=2070&auto=format&fit=crop',
        preparationTimeMinutes: 5,
        tags: ['Carboidratos', 'Emagrecimento', 'Hipertrofia'],
        isFeatured: false,
        nutritionistTip: 'Para hipertrofia, priorize consumo moderado a alto de carboidratos (4-7g/kg de peso corporal), concentrando maior parte no pré e pós-treino. Para emagrecimento, reduza para 2-4g/kg e priorize fontes complexas e de baixo índice glicêmico, como batata doce, aveia e legumes.',
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
        author: 'nutri',
      ),
      NutritionItem(
        id: '6',
        title: 'Proteínas vegetais: combinações completas',
        description: 'Aprenda a combinar fontes vegetais para obter todos os aminoácidos essenciais em uma dieta baseada em plantas.',
        category: 'tip',
        imageUrl: 'https://images.unsplash.com/photo-1511690656952-34342bb7c2f2?q=80&w=1964&auto=format&fit=crop',
        preparationTimeMinutes: 4,
        tags: ['Vegano', 'Proteínas', 'Nutrição'],
        isFeatured: false,
        nutritionistTip: 'Combine leguminosas (feijão, lentilha, grão-de-bico) com cereais (arroz, milho, quinoa) na mesma refeição ou ao longo do dia para garantir um perfil completo de aminoácidos. Alimentos como soja, quinoa e amaranto já são naturalmente completos em aminoácidos essenciais.',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        author: 'nutri',
      ),
      NutritionItem(
        id: '7',
        title: 'Torradas de Abacate com Ovo Pochê',
        description: 'Um café da manhã nutritivo rico em proteínas e gorduras saudáveis para começar o dia com energia.',
        category: 'recipe',
        imageUrl: 'https://images.unsplash.com/photo-1525351484163-7529414344d8?q=80&w=2080&auto=format&fit=crop',
        preparationTimeMinutes: 15,
        ingredients: [
          '2 fatias de pão integral',
          '1 abacate maduro',
          '2 ovos',
          'Suco de limão a gosto',
          'Sal e pimenta a gosto',
          'Flocos de pimenta vermelha (opcional)',
          'Cebolinha picada para decorar',
        ],
        instructions: [
          'Torre as fatias de pão.',
          'Amasse o abacate em uma tigela, adicione suco de limão, sal e pimenta.',
          'Em uma panela com água fervente, adicione um pouco de vinagre e crie um redemoinho com uma colher.',
          'Quebre o ovo no centro do redemoinho e cozinhe por 3-4 minutos para um ovo pochê perfeito.',
          'Espalhe o abacate nas torradas e coloque o ovo pochê por cima.',
          'Finalize com flocos de pimenta e cebolinha picada.',
        ],
        tags: ['Café da Manhã', 'Proteína', 'Ômega-3'],
        isFeatured: false,
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
        author: 'ray',
      ),
      NutritionItem(
        id: '8',
        title: 'Jejum intermitente: prós e contras para atletas',
        description: 'Uma análise das vantagens e desvantagens do jejum intermitente para quem pratica atividade física regular.',
        category: 'tip',
        imageUrl: 'https://images.unsplash.com/photo-1546548970-71785318a17b?q=80&w=2070&auto=format&fit=crop',
        preparationTimeMinutes: 5,
        tags: ['Jejum', 'Metabolismo', 'Performance'],
        isFeatured: false,
        nutritionistTip: 'O jejum intermitente pode trazer benefícios metabólicos, mas para atletas em fase de hipertrofia ou com alta demanda energética, pode comprometer a ingestão calórica e proteica necessária. Se optar por jejum, programe os treinos para o final da janela alimentar e garanta adequada reposição nutricional pós-exercício.',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        author: 'nutri',
      ),
      NutritionItem(
        id: '9',
        title: 'Panquecas Proteicas de Banana',
        description: 'Café da manhã rápido, delicioso e cheio de proteínas para começar o dia com energia.',
        category: 'recipe',
        imageUrl: 'https://images.unsplash.com/photo-1575853121743-60c24f0a7502?q=80&w=1964&auto=format&fit=crop',
        preparationTimeMinutes: 15,
        ingredients: [
          '1 banana madura',
          '2 ovos',
          '1 scoop de proteína em pó sabor baunilha',
          '2 colheres de sopa de aveia em flocos (opcional)',
          '1/4 colher de chá de canela',
          'Azeite ou óleo de coco para untar a frigideira',
          'Mel ou frutas para servir',
        ],
        instructions: [
          'Em uma tigela, amasse bem a banana com um garfo.',
          'Adicione os ovos e bata bem com um fouet ou garfo.',
          'Acrescente a proteína em pó, aveia e canela. Misture até ficar homogêneo.',
          'Aqueça uma frigideira antiaderente em fogo médio e unte levemente com azeite ou óleo de coco.',
          'Despeje pequenas porções da massa para formar panquecas de aproximadamente 10cm de diâmetro.',
          'Cozinhe por 2-3 minutos até que bolhas apareçam na superfície, vire e cozinhe por mais 1-2 minutos.',
          'Sirva quente com frutas frescas, mel ou pasta de amendoim.',
        ],
        tags: ['Café da Manhã', 'Proteína', 'Rápido'],
        isFeatured: false,
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        author: 'ray',
      ),
      NutritionItem(
        id: '10',
        title: 'Wrap de Frango e Abacate',
        description: 'Um almoço prático e balanceado para levar para a academia ou trabalho.',
        category: 'recipe',
        imageUrl: 'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?q=80&w=1964&auto=format&fit=crop',
        preparationTimeMinutes: 12,
        ingredients: [
          '1 wrap integral grande',
          '100g de peito de frango grelhado e desfiado',
          '1/2 abacate maduro fatiado',
          'Folhas de alface ou rúcula',
          '1/4 de tomate fatiado',
          '1 colher de sopa de iogurte natural',
          'Temperos a gosto (pimenta, limão)',
        ],
        instructions: [
          'Aqueça levemente o wrap em uma frigideira seca ou no micro-ondas por 10 segundos.',
          'Espalhe o iogurte natural no centro do wrap.',
          'Adicione o frango desfiado, abacate, tomate e folhas verdes.',
          'Tempere com pimenta e limão a gosto.',
          'Dobre as laterais para dentro e enrole firmemente.',
          'Corte ao meio e sirva imediatamente ou embrulhe em papel alumínio para levar.',
        ],
        tags: ['Almoço', 'Proteína', 'Prático'],
        isFeatured: false,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        author: 'ray',
      ),
    ];
  }
} 