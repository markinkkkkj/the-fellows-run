import 'package:flutter/material.dart';

import 'package:the_fellows_run/theme/app_colors.dart';

/// Cabeçalho da tela de detalhes da corrida (título, infos e distância).
class RunHero extends StatelessWidget {
  const RunHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Corrida da Lagoa',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 16),
        _InfoLinha(icone: Icons.calendar_today, texto: '14 de junho, 2026'),
        SizedBox(height: 8),
        _InfoLinha(icone: Icons.access_time, texto: '07:00 — largada na Lagoa'),
        SizedBox(height: 8),
        _InfoLinha(
          icone: Icons.place_outlined,
          texto: 'Lagoa Rodrigo de Freitas, Rio de Janeiro',
        ),
        SizedBox(height: 20),
        // Distância total
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '5 km',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                height: 1,
              ),
            ),
            SizedBox(width: 10),
            Padding(
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

class _InfoLinha extends StatelessWidget {
  final IconData icone;
  final String texto;

  const _InfoLinha({required this.icone, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icone, size: 15, color: AppColors.mutedFg),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            texto,
            style: const TextStyle(fontSize: 14, color: AppColors.mutedFg),
          ),
        ),
      ],
    );
  }
}
