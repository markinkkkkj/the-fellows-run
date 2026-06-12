import 'package:flutter/material.dart';

import 'package:the_fellows_run/theme/app_colors.dart';

/// Card de corrida concluída exibido na aba "Percorridas".
class CompletedCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String date;
  final String km;
  final bool goalReached;

  const CompletedCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.km,
    required this.goalReached,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
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
          // Título + subtítulo + data
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
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.mutedFg,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.mutedFg,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // km percorrido + badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                km,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 6),
              if (goalReached)
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
                )
              else
                const Text(
                  'parcial',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mutedFg,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
