import 'package:flutter/material.dart';

import 'package:the_fellows_run/models/run.dart';
import 'package:the_fellows_run/theme/app_colors.dart';
import 'package:the_fellows_run/widgets/app_card.dart';
import 'package:the_fellows_run/widgets/section_label.dart';
import 'package:the_fellows_run/widgets/status_badge.dart';

/// Card de inscrições (deadline + status) na tela de detalhes.
class RegistrationsCard extends StatelessWidget {
  final Run run;

  const RegistrationsCard({super.key, required this.run});

  @override
  Widget build(BuildContext context) {
    final deadlineLabel = run.deadlineLabel;
    final isOpen = run.registrationOpen;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(text: 'INSCRIÇÕES'),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                isOpen
                    ? Icons.warning_amber_rounded
                    : Icons.lock_clock_outlined,
                size: 16,
                color: isOpen ? AppColors.alert : AppColors.mutedFg,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  deadlineLabel != null
                      ? 'Encerram em $deadlineLabel'
                      : 'Inscrições abertas',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              StatusBadge(
                text: isOpen ? 'Aberta' : 'Encerrada',
                background: isOpen ? AppColors.success : AppColors.secondary,
                foreground: isOpen ? Colors.black : AppColors.mutedFg,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                fontSize: 12,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
