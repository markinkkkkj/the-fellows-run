import 'package:flutter/material.dart';

import 'package:the_fellows_run/widgets/section_label.dart';

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
        StatsCard(totalKm: '25.5', runs: '3'),
        SizedBox(height: 20),
        SectionLabel(text: 'ÚLTIMAS CORRIDAS'),
        SizedBox(height: 12),
        CompletedCard(
          title: 'Corrida da Lagoa',
          subtitle: '5.2 km / meta 5 km',
          date: '14 mai 2026',
          km: '5.2 km',
          goalReached: true,
        ),
        SizedBox(height: 12),
        CompletedCard(
          title: 'Corrida Ipanema',
          subtitle: '8.2 km / meta 10 km',
          date: '26 abr 2026',
          km: '8.2 km',
          goalReached: false,
        ),
        SizedBox(height: 12),
        CompletedCard(
          title: 'Corrida do Parque',
          subtitle: '12.1 km / meta 12 km',
          date: '10 abr 2026',
          km: '12.1 km',
          goalReached: true,
        ),
      ],
    );
  }
}
