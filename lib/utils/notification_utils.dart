// Project imports:
import '../models/notification.dart';

/// Extensões e utilidades para trabalhar com notificações
extension NotificationExtensions on AppNotification {
  /// Converte a string de data para um objeto DateTime
  DateTime? get readAtDate => readAt != null ? DateTime.parse(readAt!) : null;
  
  /// Converte a string de data de criação para um objeto DateTime
  DateTime get createdAtDate => DateTime.parse(createdAt);
  
  /// Verifica se a notificação foi lida
  bool get isRead => readAt != null;
  
  /// Retorna um ícone apropriado para o tipo de notificação
  String get iconForType {
    switch (type) {
      case 'challenge':
        return 'assets/icons/challenge.png';
      case 'workout':
        return 'assets/icons/workout.png';
      case 'coupon':
        return 'assets/icons/coupon.png';
      case 'system':
      default:
        return 'assets/icons/system.png';
    }
  }
  
  /// Retorna uma cor apropriada para o tipo de notificação (em hexadecimal)
  String get colorForType {
    switch (type) {
      case 'challenge':
        return '#FF5722'; // Laranja
      case 'workout':
        return '#4CAF50'; // Verde
      case 'coupon':
        return '#2196F3'; // Azul
      case 'system':
      default:
        return '#9E9E9E'; // Cinza
    }
  }
}

/// Classe de utilidade para operações comuns de notificações
class NotificationUtils {
  /// Formata uma lista de notificações agrupadas por data (hoje, ontem, esta semana, etc.)
  static Map<String, List<AppNotification>> groupByDate(
    List<AppNotification> notifications
  ) {
    final Map<String, List<AppNotification>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    
    for (final notification in notifications) {
      final createdAt = notification.createdAtDate;
      final notificationDate = DateTime(
        createdAt.year,
        createdAt.month,
        createdAt.day,
      );
      
      String group;
      if (notificationDate == today) {
        group = 'Hoje';
      } else if (notificationDate == yesterday) {
        group = 'Ontem';
      } else if (now.difference(notificationDate).inDays <= 7) {
        group = 'Esta Semana';
      } else if (now.difference(notificationDate).inDays <= 30) {
        group = 'Este Mês';
      } else {
        group = 'Anteriores';
      }
      
      if (!grouped.containsKey(group)) {
        grouped[group] = [];
      }
      
      grouped[group]!.add(notification);
    }
    
    return grouped;
  }
  
  /// Filtra notificações por tipo
  static List<AppNotification> filterByType(
    List<AppNotification> notifications,
    String type,
  ) {
    return notifications.where((n) => n.type == type).toList();
  }
  
  /// Filtra notificações não lidas
  static List<AppNotification> filterUnread(
    List<AppNotification> notifications,
  ) {
    return notifications.where((n) => n.readAt == null).toList();
  }
  
  /// Conta notificações não lidas
  static int countUnread(List<AppNotification> notifications) {
    return notifications.where((n) => n.readAt == null).length;
  }
} 
