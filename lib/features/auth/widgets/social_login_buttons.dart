import 'package:flutter/material.dart';

/// Widget de botões de login social
class SocialLoginButtons extends StatelessWidget {
  final VoidCallback onGoogleLogin;
  final VoidCallback? onAppleLogin;

  const SocialLoginButtons({
    super.key,
    required this.onGoogleLogin,
    this.onAppleLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Google login button
        SocialButton(
          onPressed: onGoogleLogin,
          icon: 'assets/icons/google.png',
          label: 'Google',
        ),
        
        const SizedBox(width: 16),
        
        // Apple login button (opcional)
        if (onAppleLogin != null)
          SocialButton(
            onPressed: onAppleLogin!,
            icon: 'assets/icons/apple.png',
            label: 'Apple',
            isDark: true,
          ),
      ],
    );
  }
}

/// Botão individual para login social
class SocialButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String icon;
  final String label;
  final bool isDark;

  const SocialButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        backgroundColor: isDark ? Colors.black : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            icon,
            height: 24,
            width: 24,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
} 