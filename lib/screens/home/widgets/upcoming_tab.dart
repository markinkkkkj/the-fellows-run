import 'package:flutter/material.dart';

import 'package:the_fellows_run/screens/run_details/run_details_page.dart';
import 'package:the_fellows_run/theme/app_colors.dart';

import 'run_card.dart';
import 'ver_mais_button.dart';

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
          dia: '14',
          mes: 'JUN',
          titulo: 'Corrida da Lagoa',
          horario: '07:00',
          local: 'Lagoa Rodrigo de Freitas',
          km: '5 km',
          statusTipo: StatusTipo.inscrito,
          statusTexto: 'Inscrito · Meta 5km',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RunDetails()),
            );
          },
        ),
        const SizedBox(height: 12),
        const RunCard(
          dia: '19',
          mes: 'JUN',
          titulo: 'Corrida Ipanema',
          horario: '06:30',
          local: 'Praia de Ipanema',
          km: '10 km',
          statusTipo: StatusTipo.deadline,
          statusTexto: 'Deadline próximo',
        ),
        const SizedBox(height: 12),
        const RunCard(
          dia: '28',
          mes: 'JUN',
          titulo: 'Corrida do Parque',
          horario: '07:30',
          local: 'Parque Lage',
          km: '8 km',
          statusTipo: StatusTipo.naoInscrito,
          statusTexto: 'Não inscrito',
        ),
        const SizedBox(height: 20),
        const VerMaisButton(),
      ],
    );
  }
}
