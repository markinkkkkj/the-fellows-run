import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:the_fellows_run/models/registration.dart';
import 'package:the_fellows_run/models/run.dart';
import 'package:the_fellows_run/services/registration_repository.dart';
import 'package:the_fellows_run/theme/app_colors.dart';

import 'widgets/goal_dialog.dart';
import 'widgets/registration_state.dart';
import 'widgets/registrations_card.dart';
import 'widgets/participants.dart';
import 'widgets/run_hero.dart';

class RunDetails extends StatefulWidget {
  final Run run;

  const RunDetails({super.key, required this.run});

  @override
  State<RunDetails> createState() => _RunDetailsState();
}

class _RunDetailsState extends State<RunDetails> {
  final _repo = RegistrationRepository();

  String get _runId => widget.run.id;

  Future<void> _register() async {
    final goal = await showGoalDialog(context, 5);
    if (goal == null) return;
    try {
      await _repo.register(_runId, goal);
    } catch (error) {
      _showError(error);
    }
  }

  Future<void> _editGoal(num current) async {
    final goal = await showGoalDialog(context, current);
    if (goal == null) return;
    try {
      await _repo.updateGoal(_runId, goal);
    } catch (error) {
      _showError(error);
    }
  }

  Future<void> _cancel() async {
    try {
      await _repo.cancel(_runId);
    } catch (error) {
      _showError(error);
    }
  }

  void _showError(Object error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Algo deu errado: $error')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final myUid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detalhes da corrida',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: StreamBuilder<List<Registration>>(
          stream: _repo.watchParticipants(_runId),
          builder: (context, snapshot) {
            final participants = snapshot.data ?? const <Registration>[];
            final totalKm =
                participants.fold<num>(0, (sum, r) => sum + r.goal);
            Registration? mine;
            for (final r in participants) {
              if (r.uid == myUid) {
                mine = r;
                break;
              }
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
              children: [
                RunHero(run: widget.run, totalKm: totalKm),
                const SizedBox(height: 24),
                RegistrationsCard(run: widget.run),
                const SizedBox(height: 16),

                // Estado da minha inscrição (A: não inscrito / B: inscrito)
                if (mine == null)
                  NotRegisteredState(onRegister: _register)
                else
                  RegisteredState(
                    goal: mine.goal,
                    onEditGoal: () => _editGoal(mine!.goal),
                    onCancel: _cancel,
                  ),
                const SizedBox(height: 24),

                // Lista de participantes
                Participants(
                  participants: participants,
                  currentUid: myUid,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
