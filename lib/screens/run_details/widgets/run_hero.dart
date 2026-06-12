import 'package:flutter/material.dart';

import 'package:the_fellows_run/models/run.dart';
import 'package:the_fellows_run/theme/app_colors.dart';

/// Cabeçalho da tela de detalhes da corrida (título, infos e distância).
class RunHero extends StatelessWidget {
  final Run run;
  final num totalKm;

  const RunHero({super.key, required this.run, required this.totalKm});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          run.title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        _InfoRow(icon: Icons.calendar_today, text: run.fullDate),
        const SizedBox(height: 8),
        _InfoRow(icon: Icons.access_time, text: run.time),
        const SizedBox(height: 8),
        _InfoRow(icon: Icons.place_outlined, text: run.location),
        const SizedBox(height: 20),
        // Distância total
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              Run.formatKm(totalKm),
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                height: 1,
              ),
            ),
            const SizedBox(width: 10),
            const Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Text(
                'DISTÂNCIA TOTAL',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.mutedFg,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.mutedFg),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: AppColors.mutedFg),
          ),
        ),
      ],
    );
  }
}
