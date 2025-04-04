import 'package:flutter/material.dart';

/// A customizable loading indicator widget with optional message
class LoadingWidget extends StatelessWidget {
  /// Optional message to display below the loading indicator
  final String? message;

  /// Color of the loading indicator
  final Color? color;

  /// Size of the loading indicator
  final double size;

  /// Stroke width of the loading indicator
  final double strokeWidth;

  /// Whether to show the loading indicator on a card
  final bool showCard;

  const LoadingWidget({
    Key? key,
    this.message,
    this.color,
    this.size = 36,
    this.strokeWidth = 3,
    this.showCard = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? theme.primaryColor,
            ),
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );

    if (!showCard) {
      return Center(child: content);
    }

    return Center(
      child: Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: content,
        ),
      ),
    );
  }

  /// Creates a loading widget that overlays the entire screen with a barrier
  static Widget overlay({
    String? message,
    Color? color,
    Color barrierColor = Colors.black54,
  }) {
    return Stack(
      children: [
        ModalBarrier(
          color: barrierColor,
          dismissible: false,
        ),
        LoadingWidget(
          message: message,
          color: color,
          showCard: true,
        ),
      ],
    );
  }
}
