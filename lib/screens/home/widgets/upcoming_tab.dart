import 'package:flutter/material.dart';

import 'package:the_fellows_run/screens/run_details/run_details_page.dart';
import 'package:the_fellows_run/theme/app_colors.dart';

import 'run_card.dart';
import 'see_more_button.dart';

/// Aba "Próximas" da home.
class UpcomingTab extends StatelessWidget {
  const UpcomingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
      children: [
        // Cabeçalho do mês
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'JUNHO 2026',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.mutedFg,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              '3 corridas',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        RunCard(
          day: '14',
          month: 'JUN',
          title: 'Corrida da Lagoa',
          time: '07:00',
          location: 'Lagoa Rodrigo de Freitas',
          km: '5 km',
          statusType: StatusType.registered,
          statusText: 'Inscrito · Meta 5km',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RunDetails()),
            );
          },
        ),
        const SizedBox(height: 12),
        const RunCard(
          day: '19',
          month: 'JUN',
          title: 'Corrida Ipanema',
          time: '06:30',
          location: 'Praia de Ipanema',
          km: '10 km',
          statusType: StatusType.deadline,
          statusText: 'Deadline próximo',
        ),
        const SizedBox(height: 12),
        const RunCard(
          day: '28',
          month: 'JUN',
          title: 'Corrida do Parque',
          time: '07:30',
          location: 'Parque Lage',
          km: '8 km',
          statusType: StatusType.notRegistered,
          statusText: 'Não inscrito',
        ),
        const SizedBox(height: 20),
        const SeeMoreButton(),
      ],
    );
  }
}
