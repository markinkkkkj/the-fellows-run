import 'package:flutter/material.dart';

import 'package:the_fellows_run/models/registration.dart';
import 'package:the_fellows_run/models/run.dart';
import 'package:the_fellows_run/screens/add_run/add_run_page.dart';
import 'package:the_fellows_run/screens/run_details/widgets/goal_dialog.dart';
import 'package:the_fellows_run/services/registration_repository.dart';
import 'package:the_fellows_run/theme/app_colors.dart';
import 'package:the_fellows_run/widgets/app_card.dart';
import 'package:the_fellows_run/widgets/section_label.dart';

/// Gerência de uma corrida (admin): editar dados e definir a distância que
/// cada participante percorreu.
class ManageRunPage extends StatelessWidget {
  final Run run;

  const ManageRunPage({super.key, required this.run});

  Future<void> _editDistance(BuildContext context, Registration reg) async {
    final messenger = ScaffoldMessenger.of(context);
    final value = await showGoalDialog(
      context,
      reg.distanceRun ?? reg.goal,
      title: 'Distância percorrida (km)',
    );
    if (value == null) return;
    try {
      await RegistrationRepository().setDistanceRun(run.id, reg.uid, value);
    } catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text('Erro ao salvar distância: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gerenciar corrida',
          style: TextStyle(color: theme.onPrimary, fontWeight: FontWeight.w700),
        ),
        backgroundColor: theme.primary,
        iconTheme: IconThemeData(color: theme.onPrimary),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          children: [
            AppCard(
              padding: const EdgeInsets.all(20),
              radius: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    run.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${run.fullDate} · ${run.location}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.mutedFg,
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddRunPage(run: run),
                      ),
                    ),
                    icon: Icon(Icons.edit_outlined, color: theme.primary),
                    label: Text(
                      'Editar dados',
                      style: TextStyle(
                        color: theme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      side: BorderSide(color: theme.primary, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const SectionLabel(
              text: 'PARTICIPANTES',
              icon: Icons.people_alt_outlined,
              iconSize: 14,
            ),
            const SizedBox(height: 12),
            StreamBuilder<List<Registration>>(
              stream: RegistrationRepository().watchParticipants(run.id),
              builder: (context, snapshot) {
                final participants = snapshot.data ?? const <Registration>[];
                if (participants.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      'Ninguém inscrito nesta corrida.',
                      style: TextStyle(color: AppColors.mutedFg),
                    ),
                  );
                }
                return Column(
                  children: [
                    for (final reg in participants) ...[
                      _ParticipantDistanceRow(
                        registration: reg,
                        onEdit: () => _editDistance(context, reg),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ParticipantDistanceRow extends StatelessWidget {
  final Registration registration;
  final VoidCallback onEdit;

  const _ParticipantDistanceRow({
    required this.registration,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final ran = registration.distanceRunKm;
    return AppCard(
      radius: 16,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  registration.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Percorreu ${ran ?? '—'} · ${registration.goalLabel}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.mutedFg,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onEdit,
            child: Text(
              ran == null ? 'Definir' : 'Editar',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
