import 'package:flutter/material.dart';

import 'package:the_fellows_run/theme/app_colors.dart';

import 'completed_card.dart';
import 'stats_card.dart';

/// Aba "Percorridas" da home.
class CompletedTab extends StatelessWidget {
  const CompletedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
      children: const [
        StatsCard(totalKm: '25.5', corridas: '3'),
        SizedBox(height: 20),
        Text(
          'ÚLTIMAS CORRIDAS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.mutedFg,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 12),
        CompletedCard(
          titulo: 'Corrida da Lagoa',
          subtitulo: '5.2 km / meta 5 km',
          data: '14 mai 2026',
          km: '5.2 km',
          metaBatida: true,
        ),
        SizedBox(height: 12),
        CompletedCard(
          titulo: 'Corrida Ipanema',
          subtitulo: '8.2 km / meta 10 km',
          data: '26 abr 2026',
          km: '8.2 km',
          metaBatida: false,
        ),
        SizedBox(height: 12),
        CompletedCard(
          titulo: 'Corrida do Parque',
          subtitulo: '12.1 km / meta 12 km',
          data: '10 abr 2026',
          km: '12.1 km',
          metaBatida: true,
        ),
      ],
    );
  }
}
