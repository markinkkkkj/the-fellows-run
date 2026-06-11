import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

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
            _Hero(),
            SizedBox(height: 24),
            _InscricoesCard(),
            SizedBox(height: 16),
            // ── Estado A: usuário NÃO inscrito ──
            _EstadoNaoInscrito(),
            SizedBox(height: 16),
            // ── Estado B: usuário INSCRITO ──
            _EstadoInscrito(),
            SizedBox(height: 24),
            _Participantes(),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// HERO (cabeçalho da corrida)
// ═══════════════════════════════════════════════════════════════

class _Hero extends StatelessWidget {
  const _Hero();

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

// ═══════════════════════════════════════════════════════════════
// CARD DE INSCRIÇÕES (deadline + status)
// ═══════════════════════════════════════════════════════════════

class _InscricoesCard extends StatelessWidget {
  const _InscricoesCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'INSCRIÇÕES',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.mutedFg,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded,
                  size: 16, color: AppColors.alert),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Encerram em 14 de junho · 06:00',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Aberta',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ESTADO A — NÃO INSCRITO
// ═══════════════════════════════════════════════════════════════

class _EstadoNaoInscrito extends StatelessWidget {
  const _EstadoNaoInscrito();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _LabelEstado(texto: 'ESTADO A · NÃO INSCRITO'),
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

class _EstadoInscrito extends StatelessWidget {
  const _EstadoInscrito();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _LabelEstado(texto: 'ESTADO B · INSCRITO'),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.check, size: 13, color: Colors.black),
                    SizedBox(width: 3),
                    Text(
                      'Inscrito',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'SUA META',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.mutedFg,
              letterSpacing: 1.2,
            ),
          ),
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

class _LabelEstado extends StatelessWidget {
  final String texto;
  const _LabelEstado({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          texto,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.mutedFg,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// PARTICIPANTES
// ═══════════════════════════════════════════════════════════════

class _Participantes extends StatelessWidget {
  const _Participantes();

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
              _ParticipanteRow(
                iniciais: 'MF',
                nome: 'Mateus Ferreira',
                meta: 'Meta 5 km',
                ehVoce: true,
              ),
              _DividerSutil(),
              _ParticipanteRow(
                iniciais: 'JS',
                nome: 'João Silva',
                meta: 'Meta 5 km',
              ),
              _DividerSutil(),
              _ParticipanteRow(
                iniciais: 'AC',
                nome: 'Ana Costa',
                meta: 'Meta 10 km',
              ),
              _DividerSutil(),
              _ParticipanteRow(
                iniciais: 'RM',
                nome: 'Rafael Mendes',
                meta: 'Meta 5 km',
              ),
              _DividerSutil(),
              _ParticipanteRow(
                iniciais: 'BL',
                nome: 'Beatriz Lima',
                meta: 'Meta 8 km',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const _VerMaisParticipantes(),
      ],
    );
  }
}

class _ParticipanteRow extends StatelessWidget {
  final String iniciais;
  final String nome;
  final String meta;
  final bool ehVoce;

  const _ParticipanteRow({
    required this.iniciais,
    required this.nome,
    required this.meta,
    this.ehVoce = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: ehVoce
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
              color: ehVoce
                  ? AppColors.primary.withOpacity(0.15)
                  : AppColors.secondary,
              shape: BoxShape.circle,
            ),
            child: Text(
              iniciais,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: ehVoce ? AppColors.primary : AppColors.mutedFg,
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
                    nome,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (ehVoce) ...[
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
            meta,
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

class _DividerSutil extends StatelessWidget {
  const _DividerSutil();

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

class _VerMaisParticipantes extends StatelessWidget {
  const _VerMaisParticipantes();

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

// ═══════════════════════════════════════════════════════════════
// BORDA TRACEJADA (mesma usada na home — duplicada aqui pra a tela
// ser autocontida. Se preferir, mova pra um arquivo compartilhado.)
// ═══════════════════════════════════════════════════════════════

class DottedBorder extends StatelessWidget {
  final Widget child;
  const DottedBorder({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedRectPainter(),
      child: child,
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF3A3A3A)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashWidth = 6.0;
    const dashSpace = 5.0;
    const radius = Radius.circular(16);

    final rrect = RRect.fromRectAndRadius(Offset.zero & size, radius);
    final path = Path()..addRRect(rrect);
    final dashed = Path();

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        dashed.addPath(
          metric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }

    canvas.drawPath(dashed, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}