import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:the_fellows_run/models/run.dart';
import 'package:the_fellows_run/screens/run_details/run_details_page.dart';
import 'package:the_fellows_run/services/registration_repository.dart';
import 'package:the_fellows_run/theme/app_colors.dart';
import 'package:the_fellows_run/widgets/section_label.dart';

import 'run_card.dart';

/// Aba "Próximas" da home.
class UpcomingTab extends StatefulWidget {
  const UpcomingTab({super.key});

  @override
  State<UpcomingTab> createState() => _UpcomingTabState();
}

class _UpcomingTabState extends State<UpcomingTab> {
  RunsSummary _summary = RunsSummary.empty;
  StreamSubscription<RunsSummary>? _regSub;

  @override
  void initState() {
    super.initState();
    _regSub = RegistrationRepository().watchRunsSummary().listen((summary) {
      if (mounted) setState(() => _summary = summary);
    });
  }

  @override
  void dispose() {
    _regSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('runs')
          .where('date', isGreaterThanOrEqualTo: Timestamp.now())
          .orderBy('date')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Erro ao carregar corridas: ${snapshot.error}'),
          );
        }

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return const Center(
            child: Text('Nenhuma corrida por aqui ainda.'),
          );
        }

        final runs =
            docs.map((d) => Run.fromFirestore(d.id, d.data())).toList();

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
          children: [
            // Cabeçalho do mês
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SectionLabel(text: 'JUNHO 2026'),
                Text(
                  '${runs.length} corrida${runs.length == 1 ? '' : 's'}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            for (final run in runs) ...[
              RunCard(
                day: run.day,
                month: run.month,
                title: run.title,
                time: run.time,
                location: run.location,
                km: Run.formatKm(_summary.totalKm[run.id] ?? 0),
                statusType: _summary.myRunIds.contains(run.id)
                    ? StatusType.registered
                    : StatusType.notRegistered,
                statusText: _summary.myRunIds.contains(run.id)
                    ? 'Inscrito'
                    : 'Não inscrito',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RunDetails(run: run),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ],
        );
      },
    );
  }
}
