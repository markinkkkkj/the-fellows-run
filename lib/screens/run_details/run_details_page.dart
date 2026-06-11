import 'package:flutter/material.dart';

import 'package:the_fellows_run/theme/app_colors.dart';

import 'widgets/estado_inscricao.dart';
import 'widgets/inscricoes_card.dart';
import 'widgets/participantes.dart';
import 'widgets/run_hero.dart';

class RunDetails extends StatefulWidget {
  const RunDetails({super.key});

  @override
  State<RunDetails> createState() => _RunDetailsState();
}

class _RunDetailsState extends State<RunDetails> {
  // Mock — trocar por dados reais vindos do Firestore depois.
  // Quando conectar, use isto pra escolher entre o estado A e o B.
  // ignore: unused_field
  final bool _inscrito = true;

  @override
  Widget build(BuildContext context) {
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
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
          children: const [
            RunHero(),
            SizedBox(height: 24),
            InscricoesCard(),
            SizedBox(height: 16),
            // ── Estado A: usuário NÃO inscrito ──
            EstadoNaoInscrito(),
            SizedBox(height: 16),
            // ── Estado B: usuário INSCRITO ──
            EstadoInscrito(),
            SizedBox(height: 24),
            Participantes(),
          ],
        ),
      ),
    );
  }
}
