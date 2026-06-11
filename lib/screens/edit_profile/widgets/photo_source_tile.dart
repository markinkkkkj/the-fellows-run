import 'package:flutter/material.dart';

/// Item do bottom sheet de escolha da origem da foto de perfil.
class PhotoSourceTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;

  const PhotoSourceTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final effectiveColor = color ?? theme.onSurface;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: effectiveColor, size: 22),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  color: effectiveColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
