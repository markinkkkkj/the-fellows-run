import 'package:flutter/material.dart';

/// Pill arredondado de status (fundo colorido + texto, com ícone opcional).
class StatusBadge extends StatelessWidget {
  final String text;
  final Color background;
  final Color foreground;
  final IconData? icon;
  final bool border;
  final EdgeInsetsGeometry padding;
  final double fontSize;

  const StatusBadge({
    super.key,
    required this.text,
    required this.background,
    required this.foreground,
    this.icon,
    this.border = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    this.fontSize = 11,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
        border:
            border ? Border.all(color: Colors.white.withOpacity(0.08)) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: foreground),
            const SizedBox(width: 3),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}
