import 'dart:async';
import 'dart:math';

import 'package:uuid/uuid.dart';

import '../../../core/errors/app_exception.dart';
import '../models/benefit.dart';
import '../models/redeemed_benefit.dart';
import 'benefit_repository.dart';

/// Implementação mock do BenefitRepository para testes e desenvolvimento
class MockBenefitRepository implements BenefitRepository {
  final List<Benefit> _mockBenefits = [];
  final List<RedeemedBenefit> _mockRedeemedBenefits = [];
  final Uuid _uuid = const Uuid();
  
  // Mock de pontos do usuário para testes
  int _userPoints = 500;
  
  MockBenefitRepository() {
    _initMockData();
  }
  
  void _initMockData() {
    // Categorias para benefícios
    final categories = [
      'Fitness', 'Alimentação', 'Bem-estar', 'Experiências', 'Produtos'
    ];
    
    // Parceiros
    final partners = [
      'Ray Gym', 'NutriFood', 'ZenMind', 'EcoStore', 'SportGear'
    ];
    
    // Preenche dados mock de benefícios
    for (int i = 0; i < 15; i++) {
      final category = categories[i % categories.length];
      final partner = partners[i % partners.length];
      final pointsRequired = (Random().nextInt(8) + 1) * 50; // 50, 100, 150... até 400
      
      _mockBenefits.add(Benefit(
        id: _uuid.v4(),
        title: 'Benefício ${i + 1} - $category',
        description: 'Descrição detalhada do benefício ${i + 1} oferecido por $partner.',
        imageUrl: 'https://via.placeholder.com/300x200.png?text=Benefit+${i + 1}',
        pointsRequired: pointsRequired,
        category: category,
        partner: partner,
        expirationDate: i % 3 == 0 ? DateTime.now().add(Duration(days: 30 + i)) : null,
        isFeatured: i < 3, // Primeiros 3 são destacados
        promoCode: 'RAYCLUB${100 + i}',
        termsAndConditions: 'Termos e condições aplicáveis. Oferta válida enquanto durar o estoque.',
        availableQuantity: i % 4 == 0 ? 5 + i : null,
        externalUrl: i % 2 == 0 ? 'https://example.com/benefit/$i' : null,
      ));
    }
    
    // Adiciona alguns benefícios já resgatados pelo usuário
    _mockRedeemedBenefits.add(RedeemedBenefit(
      id: _uuid.v4(),
      benefitId: _mockBenefits[0].id,
      userId: 'mock_user_id',
      redeemedAt: DateTime.now().subtract(const Duration(days: 5)),
      redemptionCode: 'RED${_randomCode(6)}',
      status: RedemptionStatus.active,
      benefitSnapshot: _mockBenefits[0],
    ));
    
    _mockRedeemedBenefits.add(RedeemedBenefit(
      id: _uuid.v4(),
      benefitId: _mockBenefits[1].id,
      userId: 'mock_user_id',
      redeemedAt: DateTime.now().subtract(const Duration(days: 10)),
      redemptionCode: 'RED${_randomCode(6)}',
      status: RedemptionStatus.used,
      usedAt: DateTime.now().subtract(const Duration(days: 8)),
      benefitSnapshot: _mockBenefits[1],
    ));
    
    _mockRedeemedBenefits.add(RedeemedBenefit(
      id: _uuid.v4(),
      benefitId: _mockBenefits[2].id,
      userId: 'mock_user_id',
      redeemedAt: DateTime.now().subtract(const Duration(days: 30)),
      redemptionCode: 'RED${_randomCode(6)}',
      status: RedemptionStatus.expired,
      expiresAt: DateTime.now().subtract(const Duration(days: 5)),
      benefitSnapshot: _mockBenefits[2],
    ));
  }
  
  // Gera código aleatório para simulação
  String _randomCode(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(length, (_) => chars[random.nextInt(chars.length)]).join();
  }
  
  // Simula atraso de rede para tornar o mock mais realista
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(Duration(milliseconds: 300 + Random().nextInt(700)));
  }

  @override
  Future<List<Benefit>> getBenefits() async {
    await _simulateNetworkDelay();
    return List.of(_mockBenefits);
  }

  @override
  Future<List<Benefit>> getBenefitsByCategory(String category) async {
    await _simulateNetworkDelay();
    return _mockBenefits.where((benefit) => benefit.category == category).toList();
  }

  @override
  Future<Benefit?> getBenefitById(String id) async {
    await _simulateNetworkDelay();
    try {
      return _mockBenefits.firstWhere((benefit) => benefit.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<RedeemedBenefit> redeemBenefit(String benefitId) async {
    await _simulateNetworkDelay();
    
    final benefit = await getBenefitById(benefitId);
    if (benefit == null) {
      throw StorageException(
        message: 'Benefício não encontrado',
        code: 'benefit_not_found',
      );
    }
    
    // Verifica se o usuário tem pontos suficientes
    if (_userPoints < benefit.pointsRequired) {
      throw ValidationException(
        message: 'Pontos insuficientes para resgatar este benefício',
        code: 'insufficient_points',
      );
    }
    
    // Verifica se ainda há quantidade disponível
    if (benefit.availableQuantity != null && benefit.availableQuantity! <= 0) {
      throw ValidationException(
        message: 'Este benefício não está mais disponível',
        code: 'no_available_quantity',
      );
    }
    
    // Verifica se não está expirado
    if (benefit.expirationDate != null && benefit.expirationDate!.isBefore(DateTime.now())) {
      throw ValidationException(
        message: 'Este benefício expirou',
        code: 'benefit_expired',
      );
    }
    
    // Subtrai pontos do usuário
    _userPoints -= benefit.pointsRequired;
    
    // Define data de expiração padrão (30 dias)
    final expiresAt = DateTime.now().add(const Duration(days: 30));
    
    // Cria registro de benefício resgatado
    final redeemedBenefit = RedeemedBenefit(
      id: _uuid.v4(),
      benefitId: benefitId,
      userId: 'mock_user_id', 
      redeemedAt: DateTime.now(),
      redemptionCode: 'RED${_randomCode(6)}',
      status: RedemptionStatus.active,
      expiresAt: expiresAt,
      benefitSnapshot: benefit,
    );
    
    // Reduz a quantidade disponível, se aplicável
    final index = _mockBenefits.indexWhere((b) => b.id == benefitId);
    if (index >= 0 && _mockBenefits[index].availableQuantity != null) {
      _mockBenefits[index] = _mockBenefits[index].copyWith(
        availableQuantity: _mockBenefits[index].availableQuantity! - 1
      );
    }
    
    _mockRedeemedBenefits.add(redeemedBenefit);
    return redeemedBenefit;
  }

  @override
  Future<List<RedeemedBenefit>> getRedeemedBenefits() async {
    await _simulateNetworkDelay();
    return List.of(_mockRedeemedBenefits);
  }

  @override
  Future<RedeemedBenefit?> getRedeemedBenefitById(String id) async {
    await _simulateNetworkDelay();
    try {
      return _mockRedeemedBenefits.firstWhere((benefit) => benefit.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<RedeemedBenefit> markBenefitAsUsed(String redeemedBenefitId) async {
    await _simulateNetworkDelay();
    
    final index = _mockRedeemedBenefits.indexWhere((b) => b.id == redeemedBenefitId);
    if (index < 0) {
      throw StorageException(
        message: 'Benefício resgatado não encontrado',
        code: 'redeemed_benefit_not_found',
      );
    }
    
    // Verifica se o benefício está ativo
    if (_mockRedeemedBenefits[index].status != RedemptionStatus.active) {
      throw ValidationException(
        message: 'Este benefício não está ativo',
        code: 'benefit_not_active',
      );
    }
    
    // Atualiza status para usado
    final updated = _mockRedeemedBenefits[index].copyWith(
      status: RedemptionStatus.used,
      usedAt: DateTime.now(),
    );
    
    _mockRedeemedBenefits[index] = updated;
    return updated;
  }

  @override
  Future<void> cancelRedeemedBenefit(String redeemedBenefitId) async {
    await _simulateNetworkDelay();
    
    final index = _mockRedeemedBenefits.indexWhere((b) => b.id == redeemedBenefitId);
    if (index < 0) {
      throw StorageException(
        message: 'Benefício resgatado não encontrado',
        code: 'redeemed_benefit_not_found',
      );
    }
    
    // Verifica se o benefício está ativo (só pode cancelar se estiver ativo)
    if (_mockRedeemedBenefits[index].status != RedemptionStatus.active) {
      throw ValidationException(
        message: 'Apenas benefícios ativos podem ser cancelados',
        code: 'benefit_not_active',
      );
    }
    
    // Devolve os pontos ao usuário
    final benefitSnapshot = _mockRedeemedBenefits[index].benefitSnapshot;
    if (benefitSnapshot != null) {
      _userPoints += benefitSnapshot.pointsRequired;
    }
    
    // Atualiza status para cancelado
    _mockRedeemedBenefits[index] = _mockRedeemedBenefits[index].copyWith(
      status: RedemptionStatus.cancelled,
    );
  }

  @override
  Future<List<String>> getBenefitCategories() async {
    await _simulateNetworkDelay();
    final categories = _mockBenefits.map((b) => b.category).toSet().toList();
    return categories;
  }

  @override
  Future<bool> hasEnoughPoints(String benefitId) async {
    await _simulateNetworkDelay();
    
    final benefit = await getBenefitById(benefitId);
    if (benefit == null) {
      throw StorageException(
        message: 'Benefício não encontrado',
        code: 'benefit_not_found',
      );
    }
    
    return _userPoints >= benefit.pointsRequired;
  }

  @override
  Future<List<Benefit>> getFeaturedBenefits() async {
    await _simulateNetworkDelay();
    return _mockBenefits.where((benefit) => benefit.isFeatured).toList();
  }
  
  // Método auxiliar para adicionar pontos ao usuário (apenas para testes)
  Future<int> addUserPoints(int points) async {
    _userPoints += points;
    return _userPoints;
  }
  
  // Método auxiliar para obter pontos do usuário atual (apenas para testes)
  Future<int> getUserPoints() async {
    return _userPoints;
  }
} 