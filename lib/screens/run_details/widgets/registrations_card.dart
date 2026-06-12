import 'package:flutter/material.dart';

import 'package:the_fellows_run/theme/app_colors.dart';
import 'package:the_fellows_run/widgets/app_card.dart';
import 'package:the_fellows_run/widgets/section_label.dart';
import 'package:the_fellows_run/widgets/status_badge.dart';

/// Card de inscrições (deadline + status) na tela de detalhes.
class RegistrationsCard extends StatelessWidget {
  const RegistrationsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(text: 'INSCRIÇÕES'),
          const SizedBox(height: 10),
          Row(
            children: const [
              Icon(Icons.warning_amber_rounded,
                  size: 16, color: AppColors.alert),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Encerram em 14 de junho · 06:00',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              StatusBadge(
                text: 'Aberta',
                background: AppColors.success,
                foreground: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                fontSize: 12,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
