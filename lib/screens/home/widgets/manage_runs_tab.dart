import 'package:flutter/material.dart';

import 'package:the_fellows_run/models/run.dart';
import 'package:the_fellows_run/screens/add_run/add_run_page.dart';
import 'package:the_fellows_run/screens/manage_run/manage_run_page.dart';
import 'package:the_fellows_run/services/run_repository.dart';
import 'package:the_fellows_run/theme/app_colors.dart';
import 'package:the_fellows_run/widgets/app_card.dart';

/// Aba de gerência de corridas (só admin): lista todas, cria e exclui.
class ManageRunsTab extends StatelessWidget {
  const ManageRunsTab({super.key});

  void _openAddRun(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddRunPage()),
    );
  }

  Future<void> _delete(BuildContext context, Run run) async {
    final theme = Theme.of(context).colorScheme;
    final messenger = ScaffoldMessenger.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text('Excluir corrida', style: TextStyle(color: theme.onSurface)),
        content: Text(
          'Tem certeza que quer excluir "${run.title}"? Não dá pra desfazer.',
          style: TextStyle(color: theme.onSurface.withOpacity(0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar',
                style: TextStyle(color: theme.onSurface.withOpacity(0.6))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    try {
      await RunRepository().delete(run.id);
    } catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text('Erro ao excluir: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder<List<Run>>(
          stream: RunRepository().watchAll(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            }

            final runs = snapshot.data ?? const <Run>[];
            if (runs.isEmpty) {
              return const Center(
                child: Text(
                  'Nenhuma corrida cadastrada.',
                  style: TextStyle(color: AppColors.mutedFg),
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
              children: [
                for (final run in runs) ...[
                  _ManageRunRow(
                    run: run,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManageRunPage(run: run),
                      ),
                    ),
                    onDelete: () => _delete(context, run),
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            );
          },
        ),
        Positioned(
          bottom: 24,
          right: 24,
          child: FloatingActionButton(
            onPressed: () => _openAddRun(context),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}

class _ManageRunRow extends StatelessWidget {
  final Run run;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ManageRunRow({
    required this.run,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      radius: 20,
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  run.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${run.shortDate} · ${run.location}',
                  style: const TextStyle(fontSize: 13, color: AppColors.mutedFg),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: onDelete,
            tooltip: 'Excluir',
          ),
        ],
      ),
    );
  }
}
