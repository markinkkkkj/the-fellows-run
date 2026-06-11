import 'package:flutter/material.dart';

import 'package:the_fellows_run/theme/app_colors.dart';

/// Card de estatísticas (histórico geral) da aba "Percorridas".
class StatsCard extends StatelessWidget {
  final String totalKm;
  final String corridas;

  const StatsCard({super.key, required this.totalKm, required this.corridas});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.show_chart, color: AppColors.primary, size: 16),
              SizedBox(width: 6),
              Text(
                'HISTÓRICO GERAL',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.mutedFg,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatItem(valor: totalKm, label: 'km percorridos'),
              ),
              Container(
                width: 1,
                height: 50,
                color: Colors.white.withOpacity(0.1),
              ),
              Expanded(
                child: _StatItem(valor: corridas, label: 'corridas'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String valor;
  final String label;

  const _StatItem({required this.valor, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          valor,
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
