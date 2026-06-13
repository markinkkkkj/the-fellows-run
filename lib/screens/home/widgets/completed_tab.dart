import 'package:flutter/material.dart';

import 'package:the_fellows_run/models/run.dart';
import 'package:the_fellows_run/services/registration_repository.dart';
import 'package:the_fellows_run/theme/app_colors.dart';
import 'package:the_fellows_run/widgets/section_label.dart';

import 'completed_card.dart';
import 'stats_card.dart';

enum _Period { month, year, all }

/// Aba "Percorridas" da home.
class CompletedTab extends StatefulWidget {
  const CompletedTab({super.key});

  @override
  State<CompletedTab> createState() => _CompletedTabState();
}

class _CompletedTabState extends State<CompletedTab> {
  final _repo = RegistrationRepository();
  late Future<List<CompletedRun>> _future;
  _Period _period = _Period.all;

  @override
  void initState() {
    super.initState();
    _future = _repo.loadCompleted();
  }

  bool _inPeriod(DateTime date) {
    final now = DateTime.now();
    switch (_period) {
      case _Period.month:
        return date.year == now.year && date.month == now.month;
      case _Period.year:
        return date.year == now.year;
      case _Period.all:
        return true;
    }
  }

  String _formatKm(num value) =>
      (value % 1 == 0 ? value.toInt() : value).toString();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CompletedRun>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Erro ao carregar histórico: ${snapshot.error}'),
          );
        }

        final all = snapshot.data ?? const <CompletedRun>[];
        final filtered =
            all.where((c) => _inPeriod(c.run.date)).toList();
        final totalKm =
            filtered.fold<num>(0, (sum, c) => sum + (c.distanceRun ?? 0));

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
          children: [
            StatsCard(
              totalKm: _formatKm(totalKm),
              runs: filtered.length.toString(),
            ),
            const SizedBox(height: 16),
            _PeriodSelector(
              selected: _period,
              onChanged: (p) => setState(() => _period = p),
            ),
            const SizedBox(height: 20),
            const SectionLabel(text: 'ÚLTIMAS CORRIDAS'),
            const SizedBox(height: 12),
            if (filtered.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 24),
                child: Center(
                  child: Text(
                    'Nenhuma corrida nesse período.',
                    style: TextStyle(color: AppColors.mutedFg),
                  ),
                ),
              )
            else
              for (final c in filtered) ...[
                CompletedCard(
                  title: c.run.title,
                  subtitle: c.run.location,
                  date: c.run.shortDate,
                  ran: c.distanceRun != null
                      ? Run.formatKm(c.distanceRun!)
                      : '—',
                  goal: Run.formatKm(c.goal),
                  reached: c.distanceRun != null && c.distanceRun! >= c.goal,
                ),
                const SizedBox(height: 12),
              ],
          ],
        );
      },
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  final _Period selected;
  final ValueChanged<_Period> onChanged;

  const _PeriodSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _chip('Mês', _Period.month),
        const SizedBox(width: 8),
        _chip('Ano', _Period.year),
        const SizedBox(width: 8),
        _chip('Toda a vida', _Period.all),
      ],
    );
  }

  Widget _chip(String label, _Period period) {
    final isSelected = selected == period;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(period),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.card,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.black : AppColors.mutedFg,
            ),
          ),
        ),
      ),
    );
  }
}
