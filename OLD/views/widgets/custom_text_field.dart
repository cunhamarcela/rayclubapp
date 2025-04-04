import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A customizable text field widget with common input features
class CustomTextField extends StatelessWidget {
  /// Label text displayed above the input
  final String? label;

  /// Hint text displayed inside the input when empty
  final String? hint;

  /// Controller for managing the text input
  final TextEditingController? controller;

  /// Type of keyboard to display
  final TextInputType? keyboardType;

  /// Whether to hide the input text (for passwords)
  final bool obscureText;

  /// Validation function that returns an error message or null
  final String? Function(String?)? validator;

  /// Callback function when text changes
  final void Function(String)? onChanged;

  /// List of input formatters to apply to the input
  final List<TextInputFormatter>? inputFormatters;

  /// Widget to display before the input
  final Widget? prefix;

  /// Widget to display after the input
  final Widget? suffix;

  /// Maximum number of lines for the input
  final int? maxLines;

  /// Maximum number of characters allowed
  final int? maxLength;

  /// Whether the input is enabled
  final bool enabled;

  /// Focus node for controlling input focus
  final FocusNode? focusNode;

  /// Text capitalization style
  final TextCapitalization textCapitalization;

  /// Text input action (keyboard action button)
  final TextInputAction? textInputAction;

  /// Callback when the input action button is pressed
  final void Function(String)? onSubmitted;

  const CustomTextField({
    Key? key,
    this.label,
    this.hint,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.inputFormatters,
    this.prefix,
    this.suffix,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      maxLength: maxLength,
      enabled: enabled,
      focusNode: focusNode,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      onFieldSubmitted: onSubmitted,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefix,
        suffixIcon: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: theme.colorScheme.outline,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: theme.primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: theme.colorScheme.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: theme.colorScheme.error,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: enabled
            ? theme.colorScheme.surface
            : theme.colorScheme.surface.withOpacity(0.5),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}
