import 'package:flutter/material.dart';

import 'package:the_fellows_run/theme/app_colors.dart';
import 'package:the_fellows_run/widgets/app_card.dart';

/// Card de corrida concluída exibido na aba "Percorridas".
class CompletedCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String date;
  final String ran; // distância percorrida formatada, ou "—" se não registrada
  final String goal; // meta formatada
  final bool reached; // meta batida

  const CompletedCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.ran,
    required this.goal,
    required this.reached,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      radius: 20,
      child: Row(
        children: [
          // Troféu (contorno)
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.emoji_events_outlined,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          // Título + local + data
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 13, color: AppColors.mutedFg),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: const TextStyle(fontSize: 12, color: AppColors.mutedFg),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Percorrido + meta
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                ran,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'meta $goal',
                style: const TextStyle(fontSize: 12, color: AppColors.mutedFg),
              ),
              const SizedBox(height: 4),
              if (reached)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.check, size: 13, color: AppColors.success),
                    SizedBox(width: 3),
                    Text(
                      'meta batida',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
