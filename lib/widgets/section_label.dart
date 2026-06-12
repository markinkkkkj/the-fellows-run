import 'package:flutter/material.dart';

import 'package:the_fellows_run/theme/app_colors.dart';

/// Rótulo de seção em caixa alta (cinza, espaçado), usado como cabeçalho
/// de blocos. Aceita um [icon] ou um [dot] como elemento à esquerda.
class SectionLabel extends StatelessWidget {
  final String text;
  final IconData? icon;
  final double iconSize;
  final Color iconColor;
  final bool dot;

  const SectionLabel({
    super.key,
    required this.text,
    this.icon,
    this.iconSize = 16,
    this.iconColor = AppColors.mutedFg,
    this.dot = false,
  });

  /// Estilo de texto compartilhado (caixa alta, cinza, espaçado).
  static const style = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.mutedFg,
    letterSpacing: 1.2,
  );

  @override
  Widget build(BuildContext context) {
    final label = Text(text, style: style);

    if (icon == null && !dot) return label;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (dot)
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          )
        else
          Icon(icon, size: iconSize, color: iconColor),
        SizedBox(width: dot ? 8 : 6),
        label,
      ],
    );
  }
}
