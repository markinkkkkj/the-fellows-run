import 'package:flutter/material.dart';

import 'package:the_fellows_run/theme/app_colors.dart';

/// Título de seção na tela de configurações.
class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.mutedFg,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

/// Item de lista (linha clicável) na tela de configurações.
class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: Colors.white.withOpacity(0.7), size: 22),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.mutedFg,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
