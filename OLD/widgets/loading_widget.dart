import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../core/constants/app_colors.dart';

/// Widget de loading reutilizável
class LoadingWidget extends StatelessWidget {
  /// Construtor do widget
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SpinKitFadingCircle(
        color: AppColors.primary,
        size: 50.0,
      ),
    );
  }
} 