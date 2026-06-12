import 'package:flutter/material.dart';

import 'package:the_fellows_run/theme/app_colors.dart';

/// Container padrão de card (fundo [AppColors.card] + cantos arredondados).
///
/// Se [onTap] for informado, vira clicável com efeito de toque (ripple).
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 16,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius);

    if (onTap != null) {
      return Material(
        color: AppColors.card,
        borderRadius: borderRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: Padding(padding: padding, child: child),
        ),
      );
    }

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}
