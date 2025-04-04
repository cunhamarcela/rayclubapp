# Ray Club App - Arquitectura

## Padrão de Arquitetura MVVM

O Ray Club App segue o padrão Model-View-ViewModel (MVVM) com Riverpod para gerenciamento de estado. Esta arquitetura foi escolhida para proporcionar:

1. **Separação de responsabilidades**: UI, lógica de negócios e dados são claramente separados
2. **Testabilidade**: ViewModels e Models são facilmente testáveis independentemente da UI
3. **Reusabilidade**: Código reutilizável entre diferentes partes do aplicativo

## Estrutura de Pastas

```
lib/
├── core/                      # Componentes essenciais da aplicação
│   ├── constants/             # Constantes da aplicação (cores, strings, etc.)
│   ├── errors/                # Sistema unificado de tratamento de erros
│   ├── providers/             # Providers globais do Riverpod
│   ├── router/                # Configuração de rotas com auto_route
│   ├── services/              # Serviços da aplicação (storage, analytics, etc.)
│   └── utils/                 # Utilitários e helpers
│
├── features/                  # Recursos da aplicação organizados por domínio
│   ├── auth/                  # Feature de autenticação
│   ├── home/                  # Feature da tela inicial
│   ├── nutrition/             # Feature de nutrição (modelo para outras features)
│   └── workouts/              # Feature de treinos
│       ├── models/            # Modelos de dados para a feature
│       ├── repositories/      # Repositórios para acesso a dados
│       ├── screens/           # Telas da feature
│       ├── viewmodels/        # ViewModels para gerenciar o estado da feature
│       └── widgets/           # Widgets específicos da feature
│
└── shared/                    # Componentes compartilhados entre features
    ├── widgets/               # Widgets reutilizáveis
    └── utils/                 # Utilitários compartilhados
```

## Camadas da Arquitetura

### Model

- Representa os dados e lógica de negócios
- Classes imutáveis, definidas com `freezed`
- Responsável pela validação, transformação e manipulação de dados

Exemplo:
```dart
@freezed
class Meal with _$Meal {
  const factory Meal({
    required String id,
    required String name,
    required DateTime dateTime,
    required int calories,
    // ...
  }) = _Meal;

  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);
}
```

### Repository

- Responsável por acessar fontes de dados (API, banco de dados, cache)
- Abstrai detalhes de implementação de fontes de dados
- Gerencia conversão entre dados brutos e modelos
- Lida com tratamento de erros específicos de fonte de dados

Exemplo:
```dart
class MealRepository {
  final SupabaseClient _client;
  
  MealRepository(this._client);
  
  Future<List<Meal>> getMeals({required String userId}) async {
    try {
      final response = await _client
        .from('meals')
        .select()
        .eq('user_id', userId);
        
      return response.map((data) => Meal.fromJson(data)).toList();
    } catch (e) {
      throw StorageException(message: 'Failed to fetch meals');
    }
  }
  
  // ...
}
```

### ViewModel

- Gerencia o estado da UI e responde a interações do usuário
- Expõe estado através de providers Riverpod
- Coordena interações entre repositories e models
- Lida com tratamento de erros de nível de aplicação

Exemplo:
```dart
final mealViewModelProvider = StateNotifierProvider<MealViewModel, MealState>((ref) {
  return MealViewModel(ref.watch(mealRepositoryProvider));
});

class MealViewModel extends StateNotifier<MealState> {
  final MealRepository _repository;
  
  MealViewModel(this._repository) : super(const MealState());
  
  Future<void> loadMeals(String userId) async {
    try {
      state = state.copyWith(isLoading: true);
      final meals = await _repository.getMeals(userId: userId);
      state = state.copyWith(meals: meals, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
  
  // ...
}
```

### View

- Representa a UI (telas e widgets)
- Renderiza dados do ViewModel
- Envia eventos de interface do usuário para o ViewModel
- Não contém lógica de negócios

Exemplo:
```dart
class NutritionScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealState = ref.watch(mealViewModelProvider);
    
    return Scaffold(
      // ...
      body: mealState.isLoading 
        ? const CircularProgressIndicator()
        : ListView.builder(
            itemCount: mealState.meals.length,
            itemBuilder: (context, index) => MealCard(
              meal: mealState.meals[index],
              onTap: () => ref.read(mealViewModelProvider.notifier).selectMeal(index),
            ),
          ),
      // ...
    );
  }
}
```

## Gerenciamento de Estado com Riverpod

- Providers são definidos globalmente para serviços e repositórios
- ViewModels são expostos como StateNotifierProviders
- Estados complexos utilizam Freezed para imutabilidade e copy-with

### Tipos de Providers Utilizados

- **Provider**: Para serviços e repositórios que não mudam de estado
- **StateProvider**: Para estados simples e primitivos
- **StateNotifierProvider**: Para estados complexos gerenciados por um StateNotifier
- **FutureProvider**: Para valores assíncronos que são carregados uma vez
- **StreamProvider**: Para fluxos de dados que mudam ao longo do tempo

## Sistema de Tratamento de Erros

O app implementa um sistema unificado de tratamento de erros com os seguintes componentes:

### Hierarquia de Exceções

```dart
// Classe base para todas as exceções da aplicação
class AppException implements Exception {
  final String message;
  final Object? originalError;
  final StackTrace? stackTrace;
  final String? code;
  
  AppException({
    required this.message,
    this.originalError,
    this.stackTrace,
    this.code,
  });
}

// Exceções específicas para diferentes cenários
class NetworkException extends AppException { ... }
class AuthException extends AppException { ... }
class StorageException extends AppException { ... }
class ValidationException extends AppException { ... }
```

### ErrorClassifier

Um utilitário central que analisa e categoriza os erros:

```dart
class ErrorClassifier {
  static AppException classifyError(Object error, StackTrace stackTrace) {
    if (error is AppException) return error;
    
    // Análise heurística do erro
    final String errorString = error.toString();
    
    if (errorString.contains('connection') || errorString.contains('network')) {
      return NetworkException(...);
    }
    
    // Outras categorizações...
    
    return AppException(message: 'Erro desconhecido: $errorString');
  }
}
```

### AppProviderObserver

Middleware para capturar e tratar erros em providers:

```dart
class AppProviderObserver extends ProviderObserver {
  @override
  void providerDidFail(
    ProviderBase provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    final appError = ErrorClassifier.classifyError(error, stackTrace);
    
    // Logging centralizado e notificação ao usuário
    // ...
  }
}
```

## Testes

Cada camada pode ser testada independentemente:

- **Models**: Testes unitários para validação e lógica de negócios
- **Repositories**: Testes de integração para acesso a dados
- **ViewModels**: Testes unitários com mocks para lógica de UI
- **Views**: Testes de widget para comportamento da UI

## Integração com Supabase

### Autenticação

A autenticação utiliza o serviço Supabase Auth para:
- Login com email/senha
- Login social com Google
- Persistência de sessão
- Recuperação de senha

### Banco de Dados

O banco de dados PostgreSQL do Supabase é utilizado com:
- Row Level Security para cada tabela
- Triggers para atualizações automáticas
- Integridade referencial com chaves estrangeiras

### Storage

O armazenamento de arquivos usa o Supabase Storage:
- Bucket "workout_images" para fotos de treinos
- Políticas de acesso baseadas no usuário
- Upload otimizado com compressão de imagens

## Convenções de Código

1. **Nomenclatura**:
   - Classes: PascalCase (e.g., `MealRepository`)
   - Variáveis/métodos: camelCase (e.g., `getUserMeals()`)
   - Constantes: SNAKE_CASE (e.g., `MAX_MEAL_COUNT`)

2. **Documentação**:
   - Comentários para classes e métodos públicos
   - Docstrings para APIs externas

3. **Imports organizados**:
   - Dart/Flutter padrão
   - Pacotes externos
   - Imports do projeto

4. **Gestão de Estado**:
   - Evitar setState(), usar exclusivamente ViewModels e Providers
   - Estados complexos com classes Freezed
   - Estados simples com StateProvider

## Status da Implementação

### Features Implementadas (100%)
- Auth, Home, Nutrition, Workout, Profile, Challenges

### Features em Desenvolvimento
- Benefits (~90%)

### Features Removidas do Escopo
- Community

## Próximos Passos

1. Completar a feature Benefits (falta sistema de expiração de cupons)
2. Aumentar cobertura de testes
3. Implementar cache estratégico para melhoria de desempenho
4. Otimizar renderização de UI para listas grandes 