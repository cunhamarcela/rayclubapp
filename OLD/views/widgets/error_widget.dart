import 'package:flutter/material.dart';

/// A customizable error widget with optional retry functionality
class CustomErrorWidget extends StatelessWidget {
  /// The error message to display
  final String message;

  /// Optional callback when the retry button is pressed
  final VoidCallback? onRetry;

  /// Icon to display above the error message
  final IconData icon;

  /// Size of the icon
  final double iconSize;

  /// Color of the icon
  final Color? iconColor;

  /// Text style for the error message
  final TextStyle? messageStyle;

  /// Whether to show the error in a card
  final bool showCard;

  const CustomErrorWidget({
    Key? key,
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline,
    this.iconSize = 48,
    this.iconColor,
    this.messageStyle,
    this.showCard = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: iconColor ?? theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: messageStyle ??
                theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar Novamente'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );

    if (!showCard) {
      return Center(child: content);
    }

    return Center(
      child: Card(
        margin: const EdgeInsets.all(16),
        child: content,
      ),
    );
  }

  /// Creates an error widget for empty states
  factory CustomErrorWidget.empty({
    String message = 'Nenhum item encontrado',
    VoidCallback? onRetry,
  }) {
    return CustomErrorWidget(
      message: message,
      onRetry: onRetry,
      icon: Icons.inbox_outlined,
      iconColor: Colors.grey,
    );
  }

  /// Creates an error widget for network errors
  factory CustomErrorWidget.network({
    String message = 'Erro de conexão',
    VoidCallback? onRetry,
  }) {
    return CustomErrorWidget(
      message: message,
      onRetry: onRetry,
      icon: Icons.wifi_off_outlined,
    );
  }

  /// Creates an error widget for permission errors
  factory CustomErrorWidget.permission({
    String message = 'Acesso negado',
    VoidCallback? onRetry,
  }) {
    return CustomErrorWidget(
      message: message,
      onRetry: onRetry,
      icon: Icons.lock_outline,
    );
  }
}
