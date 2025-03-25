import '../models/benefit.dart';
import '../models/redeemed_benefit.dart';

/// Interface para o repositório de benefícios
abstract class BenefitRepository {
  /// Obtém todos os benefícios disponíveis
  Future<List<Benefit>> getBenefits();
  
  /// Obtém benefícios por categoria
  Future<List<Benefit>> getBenefitsByCategory(String category);
  
  /// Obtém um benefício específico pelo ID
  Future<Benefit?> getBenefitById(String id);
  
  /// Resgata um benefício para o usuário atual
  Future<RedeemedBenefit> redeemBenefit(String benefitId);
  
  /// Obtém os benefícios resgatados pelo usuário atual
  Future<List<RedeemedBenefit>> getRedeemedBenefits();
  
  /// Obtém um benefício resgatado específico pelo ID
  Future<RedeemedBenefit?> getRedeemedBenefitById(String id);
  
  /// Marca um benefício resgatado como utilizado
  Future<RedeemedBenefit> markBenefitAsUsed(String redeemedBenefitId);
  
  /// Cancela um benefício resgatado
  Future<void> cancelRedeemedBenefit(String redeemedBenefitId);
  
  /// Obtém as categorias de benefícios disponíveis
  Future<List<String>> getBenefitCategories();
  
  /// Verifica se o usuário tem pontos suficientes para resgatar um benefício
  Future<bool> hasEnoughPoints(String benefitId);
  
  /// Obtém benefícios em destaque
  Future<List<Benefit>> getFeaturedBenefits();
} 