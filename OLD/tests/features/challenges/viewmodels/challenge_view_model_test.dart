import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ray_club_app/core/errors/app_exception.dart';
import 'package:ray_club_app/features/challenges/models/challenge.dart';
import 'package:ray_club_app/features/challenges/repositories/challenge_repository.dart';
import 'package:ray_club_app/features/challenges/viewmodels/challenge_view_model.dart';

// Mock do repositório
class MockChallengeRepository extends Mock implements ChallengeRepository {}

// Fake classes para registrar como fallback values
class FakeChallenge extends Fake implements Challenge {}
class FakeChallengeInvite extends Fake implements ChallengeInvite {}
class FakeChallengeProgress extends Fake implements ChallengeProgress {}

void main() {
  late ChallengeViewModel viewModel;
  late MockChallengeRepository mockRepository;
  
  // Dados de teste
  final now = DateTime.now();
  
  final testChallenges = [
    Challenge(
      id: '1',
      title: 'Desafio Ray 2023',
      description: 'Desafio oficial da Ray Club!',
      startDate: now,
      endDate: now.add(const Duration(days: 30)),
      reward: 500,
      creatorId: 'admin',
      isOfficial: true,
      participants: ['user1', 'user2'],
      createdAt: now.subtract(const Duration(days: 5)),
      updatedAt: now,
    ),
    Challenge(
      id: '2',
      title: 'Maratona Fitness',
      description: 'Acumule 100km em corridas',
      startDate: now,
      endDate: now.add(const Duration(days: 30)),
      reward: 800,
      creatorId: 'user3',
      participants: ['user3'],
      invitedUsers: ['user1', 'user4'],
      createdAt: now.subtract(const Duration(days: 2)),
      updatedAt: now,
    ),
    Challenge(
      id: '3',
      title: 'Desafio Força Total',
      description: 'Treinos de força intensos',
      startDate: now.subtract(const Duration(days: 10)),
      endDate: now.add(const Duration(days: 20)),
      reward: 300,
      creatorId: 'user2',
      participants: ['user2', 'user5'],
      createdAt: now.subtract(const Duration(days: 15)),
      updatedAt: now.subtract(const Duration(days: 10)),
    ),
  ];
  
  final testInvites = [
    ChallengeInvite(
      id: 'inv1',
      challengeId: '1',
      challengeTitle: 'Desafio Ray 2023',
      inviterId: 'admin',
      inviterName: 'Administrador',
      inviteeId: 'user3',
      status: InviteStatus.pending,
      createdAt: now.subtract(const Duration(hours: 5)),
    ),
    ChallengeInvite(
      id: 'inv2',
      challengeId: '2',
      challengeTitle: 'Maratona Fitness',
      inviterId: 'user3',
      inviterName: 'Usuário 3',
      inviteeId: 'user1',
      status: InviteStatus.pending,
      createdAt: now.subtract(const Duration(hours: 2)),
    ),
  ];
  
  final testProgress = [
    ChallengeProgress(
      id: 'prog1',
      challengeId: '1',
      userId: 'user1',
      userName: 'Usuário 1',
      points: 150,
      position: 1,
      completionPercentage: 45.0,
      lastUpdated: now.subtract(const Duration(hours: 3)),
    ),
    ChallengeProgress(
      id: 'prog2',
      challengeId: '1',
      userId: 'user2',
      userName: 'Usuário 2',
      points: 120,
      position: 2,
      completionPercentage: 36.0,
      lastUpdated: now.subtract(const Duration(hours: 5)),
    ),
  ];

  // Registrar fallback values
  setUpAll(() {
    registerFallbackValue(FakeChallenge());
    registerFallbackValue(FakeChallengeInvite());
    registerFallbackValue(FakeChallengeProgress());
    registerFallbackValue(InviteStatus.accepted);
  });

  setUp(() {
    mockRepository = MockChallengeRepository();
    
    // Configuração padrão do repository mock
    when(() => mockRepository.getChallenges())
        .thenAnswer((_) async => testChallenges);
    
    when(() => mockRepository.getActiveChallenges())
        .thenAnswer((_) async => testChallenges.where((c) => 
            c.endDate.isAfter(now)).toList());
    
    when(() => mockRepository.getUserChallenges(any()))
        .thenAnswer((_) async => testChallenges.where((c) => 
            c.creatorId == 'user3' || c.participants.contains('user3')).toList());
    
    when(() => mockRepository.getOfficialChallenge())
        .thenAnswer((_) async => testChallenges.firstWhere((c) => c.isOfficial));
    
    when(() => mockRepository.getChallengeById(any()))
        .thenAnswer((invocation) async {
          final id = invocation.positionalArguments[0] as String;
          return testChallenges.firstWhere(
            (c) => c.id == id,
            orElse: () => throw const AppException(message: 'Desafio não encontrado')
          );
        });
    
    when(() => mockRepository.getPendingInvites(any()))
        .thenAnswer((_) async => testInvites);
    
    when(() => mockRepository.getChallengeRanking(any()))
        .thenAnswer((_) async => testProgress);
        
    viewModel = ChallengeViewModel(repository: mockRepository);
  });

  group('ChallengeViewModel - Carregamento de Desafios', () {
    test('estado inicial deve ser loading e carregar desafios automaticamente', () {
      // O ViewModel inicia o carregamento no construtor
      expect(viewModel.state, isA<ChallengeState>());
      
      // Verificar se loadChallenges foi chamado no construtor
      verify(() => mockRepository.getChallenges()).called(1);
    });

    test('loadChallenges deve atualizar o estado com lista de desafios', () async {
      // Resetar o estado
      viewModel = ChallengeViewModel(repository: mockRepository);
      
      // Verificar se o estado foi atualizado corretamente
      await Future.delayed(Duration.zero); // Aguardar a conclusão do loadChallenges
      
      final state = viewModel.state;
      
      // Verificar usando o helper
      final challenges = ChallengeStateHelper.getChallenges(state);
      final filteredChallenges = ChallengeStateHelper.getFilteredChallenges(state);
      
      expect(challenges.length, equals(testChallenges.length));
      expect(filteredChallenges.length, equals(testChallenges.length));
      expect(state.maybeWhen(
        null,
        success: (_, __, ___, ____, _____, ______) => true,
        orElse: () => false,
      ), isTrue);
    });
    
    test('loadChallenges deve tratar erros corretamente', () async {
      // Configurar o mock para lançar uma exceção
      when(() => mockRepository.getChallenges())
          .thenThrow(const StorageException(message: 'Erro ao acessar o banco de dados'));
          
      // Criar um novo ViewModel para testar o caso de erro
      viewModel = ChallengeViewModel(repository: mockRepository);
      
      // Aguardar a conclusão do loadChallenges
      await Future.delayed(Duration.zero);
      
      // Verificar se o estado de erro foi configurado corretamente
      expect(viewModel.state.maybeWhen(
        null,
        error: (message) => message,
        orElse: () => null,
      ), equals('Erro ao acessar o banco de dados'));
    });
    
    test('loadUserChallenges deve filtrar desafios por usuário', () async {
      // Chamar o método com um ID de usuário
      await viewModel.loadUserChallenges('user3');
      
      // Verificar se o método do repositório foi chamado
      verify(() => mockRepository.getUserChallenges('user3')).called(1);
      
      // Verificar se o estado foi atualizado
      final challenges = ChallengeStateHelper.getChallenges(viewModel.state);
      expect(challenges.where((c) => 
          c.creatorId == 'user3' || c.participants.contains('user3')).length, 
          equals(challenges.length));
    });
    
    test('loadActiveChallenges deve trazer apenas desafios ativos', () async {
      // Chamar o método para carregar desafios ativos
      await viewModel.loadActiveChallenges();
      
      // Verificar se o método do repositório foi chamado
      verify(() => mockRepository.getActiveChallenges()).called(1);
      
      // Verificar se foram filtrados apenas desafios ativos
      final challenges = ChallengeStateHelper.getChallenges(viewModel.state);
      expect(challenges.where((c) => c.endDate.isAfter(now)).length, 
          equals(challenges.length));
    });
  });

  group('ChallengeViewModel - Manipulação de Desafios', () {
    test('getChallengeDetails deve buscar um desafio específico', () async {
      // Chamar o método para buscar detalhes de um desafio
      await viewModel.getChallengeDetails('1');
      
      // Verificar se o método do repositório foi chamado
      verify(() => mockRepository.getChallengeById('1')).called(1);
      
      // Verificar se o desafio foi selecionado corretamente
      final selectedChallenge = ChallengeStateHelper.getSelectedChallenge(viewModel.state);
      expect(selectedChallenge?.id, equals('1'));
    });
    
    test('getChallengeDetails deve tratar erros quando o desafio não existe', () async {
      // Configurar o mock para lançar uma exceção para um ID que não existe
      when(() => mockRepository.getChallengeById('999'))
          .thenThrow(const AppException(message: 'Desafio não encontrado'));
          
      // Chamar o método com um ID inválido
      await viewModel.getChallengeDetails('999');
      
      // Verificar se o estado de erro foi configurado corretamente
      expect(viewModel.state.maybeWhen(
        null,
        error: (message) => message,
        orElse: () => null,
      ), equals('Desafio não encontrado'));
    });
    
    test('createChallenge deve adicionar um novo desafio', () async {
      // Criar um novo desafio para o teste
      final newChallenge = Challenge(
        id: '4',
        title: 'Novo Desafio',
        description: 'Descrição do novo desafio',
        startDate: now,
        endDate: now.add(const Duration(days: 14)),
        reward: 200,
        creatorId: 'user1',
        participants: ['user1'],
        createdAt: now,
        updatedAt: now,
      );
      
      // Configurar o mock para retornar o novo desafio
      when(() => mockRepository.createChallenge(any()))
          .thenAnswer((_) async => newChallenge);
          
      // Chamar o método para criar um desafio
      await viewModel.createChallenge(newChallenge);
      
      // Verificar se o método do repositório foi chamado
      verify(() => mockRepository.createChallenge(any())).called(1);
      
      // Verificar se o novo desafio foi adicionado à lista e selecionado
      final challenges = ChallengeStateHelper.getChallenges(viewModel.state);
      final selectedChallenge = ChallengeStateHelper.getSelectedChallenge(viewModel.state);
      
      expect(challenges.any((c) => c.id == '4'), isTrue);
      expect(selectedChallenge?.id, equals('4'));
    });
    
    test('updateChallenge deve atualizar um desafio existente', () async {
      // Configurar o repositório mock para retornar uma lista fixa de desafios
      final challengeToUpdate = testChallenges.first; // Desafio com ID 1
      final updatedChallenge = challengeToUpdate.copyWith(
        title: 'Desafio Atualizado',
        description: 'Descrição atualizada'
      );
      
      // Configurar o mock para o updateChallenge (não faz nada)
      when(() => mockRepository.updateChallenge(any()))
          .thenAnswer((_) async {});
          
      // Configurar o mock para o getChallengeById para retornar o desafio atualizado
      when(() => mockRepository.getChallengeById('1'))
          .thenAnswer((_) async => updatedChallenge);
      
      // Primeiro, carregar um estado inicial com desafios
      // Não usamos await aqui porque queremos simular que já temos o estado carregado
      viewModel = ChallengeViewModel(repository: mockRepository);
      await Future.delayed(Duration.zero); // Espera completar o loadChallenges do construtor
      
      // Verificar se o estado inicial tem desafios
      var challenges = viewModel.state.maybeWhen(
        null,
        success: (challenges, _, __, ___, ____, _____) => challenges,
        orElse: () => <Challenge>[],
      );
      expect(challenges.isNotEmpty, isTrue);
      
      // Chamar o método para atualizar o desafio
      await viewModel.updateChallenge(updatedChallenge);
      
      // Verificar se o método do repositório foi chamado
      verify(() => mockRepository.updateChallenge(any())).called(1);
      
      // Verificar diretamente o estado final para confirmação
      final hasUpdatedTitle = viewModel.state.maybeWhen(
        null,
        success: (challenges, _, selectedChallenge, __, ___, ____) {
          return challenges.any((c) => c.id == '1' && c.title == 'Desafio Atualizado') ||
                 (selectedChallenge?.id == '1' && selectedChallenge?.title == 'Desafio Atualizado');
        },
        orElse: () => false,
      );
      
      expect(hasUpdatedTitle, isTrue, reason: 'O desafio não foi atualizado corretamente');
    });
  });

  group('ChallengeViewModel - Interação com Desafios', () {
    test('joinChallenge deve adicionar um usuário aos participantes', () async {
      // Configurar o mock
      when(() => mockRepository.joinChallenge(
        challengeId: any(named: 'challengeId'), 
        userId: any(named: 'userId')
      )).thenAnswer((_) async {});
      
      // Adicionar mock para o getChallengeById após a junção
      final updatedChallenge = testChallenges[0].copyWith(
        participants: [...testChallenges[0].participants, 'user3']
      );
      
      when(() => mockRepository.getChallengeById('1'))
          .thenAnswer((_) async => updatedChallenge);
      
      // Chamar o método para juntar-se a um desafio
      await viewModel.joinChallenge(challengeId: '1', userId: 'user3');
      
      // Verificar se o método do repositório foi chamado
      verify(() => mockRepository.joinChallenge(
        challengeId: '1', 
        userId: 'user3'
      )).called(1);
      
      // Verificar se o usuário foi adicionado aos participantes
      final selectedChallenge = ChallengeStateHelper.getSelectedChallenge(viewModel.state);
      expect(selectedChallenge?.participants.contains('user3'), isTrue);
    });
    
    test('leaveChallenge deve remover um usuário dos participantes', () async {
      // Configurar o mock
      when(() => mockRepository.leaveChallenge(
        challengeId: any(named: 'challengeId'), 
        userId: any(named: 'userId')
      )).thenAnswer((_) async {});
      
      // Adicionar mock para o getChallengeById após a saída
      final updatedChallenge = testChallenges[0].copyWith(
        participants: testChallenges[0].participants.where((p) => p != 'user1').toList()
      );
      
      when(() => mockRepository.getChallengeById('1'))
          .thenAnswer((_) async => updatedChallenge);
      
      // Chamar o método para sair de um desafio
      await viewModel.leaveChallenge(challengeId: '1', userId: 'user1');
      
      // Verificar se o método do repositório foi chamado
      verify(() => mockRepository.leaveChallenge(
        challengeId: '1', 
        userId: 'user1'
      )).called(1);
      
      // Verificar se o usuário foi removido dos participantes
      final selectedChallenge = ChallengeStateHelper.getSelectedChallenge(viewModel.state);
      expect(selectedChallenge?.participants.contains('user1'), isFalse);
    });
  });

  group('ChallengeViewModel - Convites', () {
    test('loadPendingInvites deve carregar convites pendentes', () async {
      // Chamar o método para carregar convites pendentes
      await viewModel.loadPendingInvites('user3');
      
      // Verificar se o método do repositório foi chamado
      verify(() => mockRepository.getPendingInvites('user3')).called(1);
      
      // Verificar se os convites foram carregados
      final pendingInvites = ChallengeStateHelper.getPendingInvites(viewModel.state);
      expect(pendingInvites.length, equals(testInvites.length));
    });
    
    test('inviteUserToChallenge deve enviar um convite', () async {
      // Configurar o mock
      final newInvite = ChallengeInvite(
        id: 'inv3',
        challengeId: '1',
        challengeTitle: 'Desafio Ray 2023',
        inviterId: 'user1',
        inviterName: 'Usuário 1',
        inviteeId: 'user5',
        status: InviteStatus.pending,
        createdAt: now,
      );
      
      when(() => mockRepository.inviteUserToChallenge(
        challengeId: any(named: 'challengeId'),
        inviterId: any(named: 'inviterId'),
        inviteeId: any(named: 'inviteeId'),
        challengeTitle: any(named: 'challengeTitle'),
        inviterName: any(named: 'inviterName'),
      )).thenAnswer((_) async => newInvite);
      
      // Chamar o método para convidar um usuário
      await viewModel.inviteUserToChallenge(
        challengeId: '1',
        challengeTitle: 'Desafio Ray 2023',
        inviterId: 'user1',
        inviterName: 'Usuário 1',
        inviteeId: 'user5',
      );
      
      // Verificar se o método do repositório foi chamado
      verify(() => mockRepository.inviteUserToChallenge(
        challengeId: '1',
        challengeTitle: 'Desafio Ray 2023',
        inviterId: 'user1',
        inviterName: 'Usuário 1',
        inviteeId: 'user5',
      )).called(1);
      
      // Verificar mensagem de sucesso
      expect(viewModel.state.maybeWhen(
        null,
        success: (_, __, ___, ____, _____, message) => message,
        orElse: () => null,
      ), contains('Convite enviado'));
    });
    
    test('respondToInvite deve atualizar o status do convite', () async {
      // Configurar o mock
      when(() => mockRepository.respondToInvite(
        inviteId: any(named: 'inviteId'),
        status: any(named: 'status'),
      )).thenAnswer((_) async {});
      
      // Primeiro carregamos os convites pendentes
      await viewModel.loadPendingInvites('user3');
      
      // Chamar o método para responder a um convite
      await viewModel.respondToInvite(
        inviteId: 'inv1',
        status: InviteStatus.accepted,
      );
      
      // Verificar se o método do repositório foi chamado
      verify(() => mockRepository.respondToInvite(
        inviteId: 'inv1',
        status: InviteStatus.accepted,
      )).called(1);
      
      // Verificar mensagem de sucesso
      expect(viewModel.state.maybeWhen(
        null,
        success: (_, __, ___, ____, _____, message) => message,
        orElse: () => null,
      ), contains('Você aceitou o convite e entrou no desafio!'));
    });
  });

  group('ChallengeViewModel - Progresso e Ranking', () {
    test('loadChallengeRanking deve carregar o ranking do desafio', () async {
      // Chamar o método para carregar o ranking
      await viewModel.loadChallengeRanking('1');
      
      // Verificar se o método do repositório foi chamado
      verify(() => mockRepository.getChallengeRanking('1')).called(1);
      
      // Verificar se o ranking foi carregado
      final progressList = ChallengeStateHelper.getProgressList(viewModel.state);
      expect(progressList.length, equals(testProgress.length));
    });
    
    test('updateUserProgress deve atualizar o progresso do usuário', () async {
      // Configurar o mock
      when(() => mockRepository.updateUserProgress(
        challengeId: any(named: 'challengeId'),
        userId: any(named: 'userId'),
        userName: any(named: 'userName'),
        userPhotoUrl: any(named: 'userPhotoUrl'),
        points: any(named: 'points'),
        completionPercentage: any(named: 'completionPercentage'),
      )).thenAnswer((_) async {});
      
      // Chamar o método para atualizar o progresso
      await viewModel.updateUserProgress(
        challengeId: '1',
        userId: 'user1',
        userName: 'Usuário 1',
        points: 200,
        completionPercentage: 0.6, // 60%
      );
      
      // Verificar se o método do repositório foi chamado
      verify(() => mockRepository.updateUserProgress(
        challengeId: '1',
        userId: 'user1',
        userName: 'Usuário 1',
        userPhotoUrl: null,
        points: 200,
        completionPercentage: 0.6,
      )).called(1);
      
      // Verificar mensagem de sucesso
      expect(viewModel.state.maybeWhen(
        null,
        success: (_, __, ___, ____, _____, message) => message,
        orElse: () => null,
      ), contains('Progresso atualizado'));
    });
    
    test('updateUserProgress deve validar valores inválidos', () async {
      // Tentar atualizar com uma porcentagem inválida (> 100%)
      await viewModel.updateUserProgress(
        challengeId: '1',
        userId: 'user1',
        userName: 'Usuário 1',
        points: 200,
        completionPercentage: 1.1, // 110%
      );
      
      // Verificar se ocorreu um erro
      expect(viewModel.state.maybeWhen(
        null,
        error: (message) => message,
        orElse: () => null,
      ), contains('percentual de conclusão'));
      
      // Garantir que o repositório não foi chamado
      verifyNever(() => mockRepository.updateUserProgress(
        challengeId: any(named: 'challengeId'),
        userId: any(named: 'userId'),
        userName: any(named: 'userName'),
        userPhotoUrl: any(named: 'userPhotoUrl'),
        points: any(named: 'points'),
        completionPercentage: any(named: 'completionPercentage'),
      ));
    });
  });

  group('ChallengeViewModel - Erros e Recuperação', () {
    test('deve se recuperar de erros ao tentar uma nova operação', () async {
      // Primeiro provocamos um erro
      when(() => mockRepository.getChallengeById('999'))
          .thenThrow(const AppException(message: 'Desafio não encontrado'));
          
      await viewModel.getChallengeDetails('999');
      
      // Verificar se está no estado de erro
      expect(viewModel.state.maybeWhen(
        null,
        error: (_) => true,
        orElse: () => false,
      ), isTrue);
      
      // Agora tentamos uma operação válida
      when(() => mockRepository.getActiveChallenges())
          .thenAnswer((_) async => testChallenges);
          
      await viewModel.loadActiveChallenges();
      
      // Verificar se recuperou para o estado de sucesso
      expect(viewModel.state.maybeWhen(
        null,
        success: (_, __, ___, ____, _____, ______) => true,
        orElse: () => false,
      ), isTrue);
    });
  });
} 