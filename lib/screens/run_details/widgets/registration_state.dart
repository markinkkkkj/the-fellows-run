import 'package:flutter/material.dart';

import 'package:the_fellows_run/theme/app_colors.dart';
import 'package:the_fellows_run/widgets/app_card.dart';
import 'package:the_fellows_run/widgets/section_label.dart';
import 'package:the_fellows_run/widgets/status_badge.dart';

// ═══════════════════════════════════════════════════════════════
// ESTADO A — NÃO INSCRITO
// ═══════════════════════════════════════════════════════════════

class NotRegisteredState extends StatelessWidget {
  const NotRegisteredState({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(text: 'ESTADO A · NÃO INSCRITO', dot: true),
          const SizedBox(height: 12),
          const Text(
            'Você ainda não está inscrito',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Inscreva-se e defina uma meta pessoal de distância para '
            'participar desta corrida com o grupo.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.mutedFg,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Inscrever-se na corrida'),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ESTADO B — INSCRITO
// ═══════════════════════════════════════════════════════════════

class RegisteredState extends StatelessWidget {
  const RegisteredState({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              SectionLabel(text: 'ESTADO B · INSCRITO', dot: true),
              StatusBadge(
                text: 'Inscrito',
                background: AppColors.success,
                foreground: Colors.black,
                icon: Icons.check,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                fontSize: 12,
              ),
            ],
          ),
          const SizedBox(height: 14),
          const SectionLabel(text: 'SUA META'),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                child: Text(
                  '5 km',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
              // Botão editar (lápis) circular
              Material(
                color: AppColors.secondary,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: () {},
                  customBorder: const CircleBorder(),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.edit_outlined,
                        size: 18, color: AppColors.primary),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Editável até o início da corrida',
            style: TextStyle(fontSize: 13, color: AppColors.mutedFg),
          ),
          const SizedBox(height: 16),
          // Botão secundário (outline) — Editar meta
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary, width: 1.5),
                minimumSize: const Size.fromHeight(54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text('Editar meta'),
            ),
          ),
          const SizedBox(height: 4),
          // Botão de texto — Cancelar inscrição
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: AppColors.error,
                minimumSize: const Size.fromHeight(48),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text('Cancelar inscrição'),
            ),
          ),
        ],
      ),
    );
  }
}

