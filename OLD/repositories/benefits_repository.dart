import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ray_club_app/models/benefit.dart';

/// Provider for the benefits repository
final benefitsRepositoryProvider = Provider<BenefitsRepository>((ref) {
  return BenefitsRepositoryImpl();
});

/// Interface for the benefits repository
abstract class BenefitsRepository {
  /// Gets all available benefits
  Future<List<Benefit>> getAllBenefits();
  
  /// Gets benefits by type
  Future<List<Benefit>> getBenefitsByType(BenefitType type);
  
  /// Gets benefits by partner name
  Future<List<Benefit>> getBenefitsByPartner(String partner);
  
  /// Gets a specific benefit by ID
  Future<Benefit> getBenefitById(String id);
  
  /// Creates a new benefit
  Future<Benefit> createBenefit(Benefit benefit);
  
  /// Updates an existing benefit
  Future<Benefit> updateBenefit(Benefit benefit);
  
  /// Deletes a benefit
  Future<void> deleteBenefit(String id);
}

/// Implementation of the benefits repository
class BenefitsRepositoryImpl implements BenefitsRepository {
  @override
  Future<List<Benefit>> getAllBenefits() async {
    try {
      // TODO: Implement actual API call when database is ready
      // For now, return mock data
      await Future.delayed(const Duration(milliseconds: 800));
      return _getMockBenefits();
    } catch (e) {
      if (e is DioError) {
        throw Exception('Erro de rede: ${e.message}');
      }
      throw Exception('Erro ao buscar benefícios: $e');
    }
  }
  
  @override
  Future<List<Benefit>> getBenefitsByType(BenefitType type) async {
    try {
      final benefits = await getAllBenefits();
      return benefits.where((benefit) => benefit.type == type).toList();
    } catch (e) {
      throw Exception('Erro ao filtrar benefícios por tipo: $e');
    }
  }
  
  @override
  Future<List<Benefit>> getBenefitsByPartner(String partner) async {
    try {
      final benefits = await getAllBenefits();
      return benefits.where((benefit) => 
        benefit.partner.toLowerCase() == partner.toLowerCase()
      ).toList();
    } catch (e) {
      throw Exception('Erro ao filtrar benefícios por parceiro: $e');
    }
  }
  
  @override
  Future<Benefit> getBenefitById(String id) async {
    try {
      final benefits = await getAllBenefits();
      final benefit = benefits.firstWhere(
        (benefit) => benefit.id == id,
        orElse: () => throw Exception('Benefício não encontrado'),
      );
      return benefit;
    } catch (e) {
      throw Exception('Erro ao buscar benefício: $e');
    }
  }
  
  @override
  Future<Benefit> createBenefit(Benefit benefit) async {
    try {
      // Simula criação com atraso
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Gera um ID único com timestamp para simular o banco de dados
      final newBenefit = benefit.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
      );
      
      return newBenefit;
    } catch (e) {
      throw Exception('Erro ao criar benefício: $e');
    }
  }
  
  @override
  Future<Benefit> updateBenefit(Benefit benefit) async {
    try {
      // Verifica se o benefício existe
      await getBenefitById(benefit.id);
      
      // Simula atualização com atraso
      await Future.delayed(const Duration(milliseconds: 500));
      
      return benefit;
    } catch (e) {
      throw Exception('Erro ao atualizar benefício: $e');
    }
  }
  
  @override
  Future<void> deleteBenefit(String id) async {
    try {
      // Verifica se o benefício existe
      await getBenefitById(id);
      
      // Simula exclusão com atraso
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Em um ambiente real, aqui seria feita a chamada para excluir do banco de dados
      return;
    } catch (e) {
      throw Exception('Erro ao excluir benefício: $e');
    }
  }
  
  /// Returns mock benefits data for development
  List<Benefit> _getMockBenefits() {
    return [
      Benefit(
        id: '1',
        title: '15% de desconto em proteínas',
        description: 'Desconto exclusivo para membros Ray Club em todas as proteínas da loja.',
        partner: 'Suplementos Top',
        imageUrl: 'https://images.unsplash.com/photo-1579722820258-02ad62c6b59c',
        type: BenefitType.coupon,
        expiresAt: DateTime.now().add(const Duration(days: 30)),
      ),
      Benefit(
        id: '2',
        title: 'Avaliação física gratuita',
        description: 'Uma avaliação física completa sem custo na academia parceira.',
        partner: 'Academia Fitness',
        imageUrl: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48',
        type: BenefitType.qrCode,
      ),
      Benefit(
        id: '3',
        title: 'Comunidade VIP WhatsApp',
        description: 'Acesse nosso grupo exclusivo de membros no WhatsApp para dicas diárias e suporte.',
        partner: 'Ray Club',
        imageUrl: 'https://images.unsplash.com/photo-1611162616305-c69b3fa7fbe0',
        type: BenefitType.link,
        actionUrl: 'https://chat.whatsapp.com/example',
      ),
      Benefit(
        id: '4',
        title: '20% OFF em roupas esportivas',
        description: 'Desconto especial em toda a linha de roupas para treino.',
        partner: 'Sports Wear',
        imageUrl: 'https://images.unsplash.com/photo-1539185441755-769473a23570',
        type: BenefitType.coupon,
        expiresAt: DateTime.now().add(const Duration(days: 15)),
      ),
      Benefit(
        id: '5',
        title: 'Consulta com nutricionista',
        description: 'Desconto de 30% na primeira consulta com nutricionista especializada em esportes.',
        partner: 'Nutri Esporte',
        imageUrl: 'https://images.unsplash.com/photo-1490645935967-10de6ba17061',
        type: BenefitType.qrCode,
      ),
      Benefit(
        id: '6',
        title: 'Kit exclusivo de amostra',
        description: 'Retire seu kit de amostras de suplementos exclusivamente para membros.',
        partner: 'Vida Natural',
        imageUrl: 'https://images.unsplash.com/photo-1616803689943-5601631c7fec',
        type: BenefitType.qrCode,
      ),
    ];
  }
} 