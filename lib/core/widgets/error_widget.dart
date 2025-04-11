// Flutter imports:
import 'package:flutter/material.dart';

/// Widget para exibir erros de forma padronizada
class AppErrorWidget extends StatelessWidget {
  /// Construtor
  const AppErrorWidget({
    Key? key,
    required this.message,
    this.onRetry,
    this.icon,
    this.retryLabel = 'Tentar novamente',
  }) : super(key: key);
  
  /// Mensagem de erro a ser exibida
  final String message;
  
  /// Função a ser chamada quando o usuário quiser tentar novamente
  final VoidCallback? onRetry;
  
  /// Ícone personalizado (opcional)
  final IconData? icon;
  
  /// Label do botão de retry
  final String retryLabel;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon ?? Icons.error_outline,
            size: 64,
            color: Colors.red.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(retryLabel),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }
} 