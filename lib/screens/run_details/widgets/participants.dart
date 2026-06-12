import 'package:flutter/material.dart';

import 'package:the_fellows_run/models/registration.dart';
import 'package:the_fellows_run/theme/app_colors.dart';
import 'package:the_fellows_run/widgets/app_card.dart';
import 'package:the_fellows_run/widgets/section_label.dart';
import 'package:the_fellows_run/widgets/status_badge.dart';

/// Lista de participantes da corrida na tela de detalhes.
class Participants extends StatelessWidget {
  final List<Registration> participants;
  final String currentUid;

  const Participants({
    super.key,
    required this.participants,
    required this.currentUid,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(
          text: 'PARTICIPANTES · ${participants.length}',
          icon: Icons.people_alt_outlined,
          iconSize: 14,
        ),
        const SizedBox(height: 12),
        AppCard(
          padding: EdgeInsets.zero,
          child: participants.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Ninguém inscrito ainda. Seja o primeiro!',
                    style: TextStyle(fontSize: 14, color: AppColors.mutedFg),
                  ),
                )
              : Column(
                  children: [
                    for (var i = 0; i < participants.length; i++) ...[
                      _ParticipantRow(
                        registration: participants[i],
                        isYou: participants[i].uid == currentUid,
                      ),
                      if (i < participants.length - 1) const _SubtleDivider(),
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}

class _ParticipantRow extends StatelessWidget {
  final Registration registration;
  final bool isYou;

  const _ParticipantRow({required this.registration, this.isYou = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: isYou
          ? const BoxDecoration(
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
              registration.initials,
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
                    registration.name,
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
                  const StatusBadge(
                    text: 'você',
                    background: AppColors.primary,
                    foreground: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    fontSize: 10,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            registration.goalLabel,
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
