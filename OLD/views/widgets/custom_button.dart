import 'package:flutter/material.dart';

/// A customizable button widget that supports loading state and different styles
class CustomButton extends StatelessWidget {
  /// The text to display on the button
  final String text;

  /// Callback function when the button is pressed
  final VoidCallback? onPressed;

  /// Whether to show a loading indicator instead of text
  final bool isLoading;

  /// Whether to use an outlined style instead of filled
  final bool isOutlined;

  /// The background color of the button (for filled style)
  /// or border/text color (for outlined style)
  final Color? color;

  /// Optional fixed width for the button
  final double? width;

  /// Height of the button, defaults to 48
  final double height;

  /// Border radius of the button corners, defaults to 8
  final double borderRadius;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.color,
    this.width,
    this.height = 48,
    this.borderRadius = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonColor = color ?? theme.primaryColor;

    return SizedBox(
      width: width,
      height: height,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: buttonColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24),
              ),
              child: _buildChild(theme, buttonColor),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                elevation: 2,
              ),
              child: _buildChild(theme, buttonColor),
            ),
    );
  }

  Widget _buildChild(ThemeData theme, Color buttonColor) {
    if (isLoading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            isOutlined ? buttonColor : Colors.white,
          ),
        ),
      );
    }

    return Text(
      text,
      style: theme.textTheme.labelLarge?.copyWith(
        color: isOutlined ? buttonColor : Colors.white,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }
}
