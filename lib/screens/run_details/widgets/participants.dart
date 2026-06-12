import 'package:flutter/material.dart';

import 'package:the_fellows_run/theme/app_colors.dart';
import 'package:the_fellows_run/widgets/dotted_border.dart';

/// Lista de participantes da corrida na tela de detalhes.
class Participants extends StatelessWidget {
  const Participants({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Icon(Icons.people_alt_outlined,
                    size: 14, color: AppColors.mutedFg),
                SizedBox(width: 6),
                Text(
                  'PARTICIPANTES · 8',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.mutedFg,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {},
              child: const Text(
                'Ver todos',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: const [
              _ParticipantRow(
                initials: 'MF',
                name: 'Mateus Ferreira',
                goal: 'Meta 5 km',
                isYou: true,
              ),
              _SubtleDivider(),
              _ParticipantRow(
                initials: 'JS',
                name: 'João Silva',
                goal: 'Meta 5 km',
              ),
              _SubtleDivider(),
              _ParticipantRow(
                initials: 'AC',
                name: 'Ana Costa',
                goal: 'Meta 10 km',
              ),
              _SubtleDivider(),
              _ParticipantRow(
                initials: 'RM',
                name: 'Rafael Mendes',
                goal: 'Meta 5 km',
              ),
              _SubtleDivider(),
              _ParticipantRow(
                initials: 'BL',
                name: 'Beatriz Lima',
                goal: 'Meta 8 km',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const _SeeMoreParticipants(),
      ],
    );
  }
}

class _ParticipantRow extends StatelessWidget {
  final String initials;
  final String name;
  final String goal;
  final bool isYou;

  const _ParticipantRow({
    required this.initials,
    required this.name,
    required this.goal,
    this.isYou = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: isYou
          ? BoxDecoration(
              border: Border(
                left: BorderSide(color: AppColors.primary, width: 2),
              ),
            )
          : null,
      child: Row(
        children: [
          // Avatar com iniciais
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isYou
                  ? AppColors.primary.withOpacity(0.15)
                  : AppColors.secondary,
              shape: BoxShape.circle,
            ),
            child: Text(
              initials,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isYou ? AppColors.primary : AppColors.mutedFg,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Nome (+ tag "você")
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isYou) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'você',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            goal,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SubtleDivider extends StatelessWidget {
  const _SubtleDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 16,
      color: Colors.white.withOpacity(0.06),
    );
  }
}

class _SeeMoreParticipants extends StatelessWidget {
  const _SeeMoreParticipants();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: DottedBorder(
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Ver mais 3 participantes',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mutedFg,
                  ),
                ),
                SizedBox(width: 6),
                Icon(Icons.chevron_right, color: AppColors.mutedFg, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
