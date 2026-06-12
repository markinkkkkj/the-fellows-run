import 'package:flutter/material.dart';

import 'package:the_fellows_run/theme/app_colors.dart';
import 'package:the_fellows_run/widgets/app_card.dart';
import 'package:the_fellows_run/widgets/section_label.dart';

/// Card de estatísticas (histórico geral) da aba "Percorridas".
class StatsCard extends StatelessWidget {
  final String totalKm;
  final String runs;

  const StatsCard({super.key, required this.totalKm, required this.runs});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      radius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(
            text: 'HISTÓRICO GERAL',
            icon: Icons.show_chart,
            iconColor: AppColors.primary,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatItem(value: totalKm, label: 'km percorridos'),
              ),
              Container(
                width: 1,
                height: 50,
                color: Colors.white.withOpacity(0.1),
              ),
              Expanded(
                child: _StatItem(value: runs, label: 'corridas'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.mutedFg),
        ),
      ],
    );
  }
}
