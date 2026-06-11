import 'package:flutter/material.dart';
import 'package:the_fellows_run/screens/run_details.dart';
import '../theme/app_theme.dart';
import 'settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          titleSpacing: 20,
          title: Row(
            children: [
              // Logo: círculo preto com raio
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.bolt,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'The Fellows Run',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Settings()),
                );
              },
            ),
            const SizedBox(width: 8),
          ],
          // TabBar numa faixa escura abaixo do header verde, para que a label
          // ativa e o indicador verde-limão tenham contraste (verde sobre verde
          // ficava invisível).
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              color: AppColors.darkBg,
              child: const TabBar(
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.mutedFg,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.label,
                dividerColor: Color(0xFF222222),
                labelStyle:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                unselectedLabelStyle:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                tabs: [
                  Tab(text: 'Próximas'),
                  Tab(text: 'Percorridas'),
                ],
              ),
            ),
          ),
        ),
        body: const SafeArea(
          top: false,
          child: TabBarView(
            children: [
              _UpcomingTab(),
              _CompletedTab(),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ABA PRÓXIMAS
// ═══════════════════════════════════════════════════════════════

class _UpcomingTab extends StatelessWidget {
  const _UpcomingTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
      children: [
        // Cabeçalho do mês
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'JUNHO 2026',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.mutedFg,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              '3 corridas',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _RunCard(
          dia: '14',
          mes: 'JUN',
          titulo: 'Corrida da Lagoa',
          horario: '07:00',
          local: 'Lagoa Rodrigo de Freitas',
          km: '5 km',
          statusTipo: _StatusTipo.inscrito,
          statusTexto: 'Inscrito · Meta 5km',  
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RunDetails()),
            );
          },
        ),
        const SizedBox(height: 12),
        const _RunCard(
          dia: '19',
          mes: 'JUN',
          titulo: 'Corrida Ipanema',
          horario: '06:30',
          local: 'Praia de Ipanema',
          km: '10 km',
          statusTipo: _StatusTipo.deadline,
          statusTexto: 'Deadline próximo',
        ),
        const SizedBox(height: 12),
        const _RunCard(
          dia: '28',
          mes: 'JUN',
          titulo: 'Corrida do Parque',
          horario: '07:30',
          local: 'Parque Lage',
          km: '8 km',
          statusTipo: _StatusTipo.naoInscrito,
          statusTexto: 'Não inscrito',
        ),
        const SizedBox(height: 20),
        const _VerMaisButton(),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ABA PERCORRIDAS
// ═══════════════════════════════════════════════════════════════

class _CompletedTab extends StatelessWidget {
  const _CompletedTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
      children: const [
        _StatsCard(totalKm: '25.5', corridas: '3'),
        SizedBox(height: 20),
        Text(
          'ÚLTIMAS CORRIDAS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.mutedFg,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 12),
        _CompletedCard(
          titulo: 'Corrida da Lagoa',
          subtitulo: '5.2 km / meta 5 km',
          data: '14 mai 2026',
          km: '5.2 km',
          metaBatida: true,
        ),
        SizedBox(height: 12),
        _CompletedCard(
          titulo: 'Corrida Ipanema',
          subtitulo: '8.2 km / meta 10 km',
          data: '26 abr 2026',
          km: '8.2 km',
          metaBatida: false,
        ),
        SizedBox(height: 12),
        _CompletedCard(
          titulo: 'Corrida do Parque',
          subtitulo: '12.1 km / meta 12 km',
          data: '10 abr 2026',
          km: '12.1 km',
          metaBatida: true,
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// BOTÃO "VER MAIS CORRIDAS" (tracejado)
// ═══════════════════════════════════════════════════════════════

class _VerMaisButton extends StatelessWidget {
  const _VerMaisButton();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: DottedBorder(
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Ver mais corridas',
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

/// Borda tracejada desenhada com CustomPainter
/// (evita adicionar pacote externo dotted_border).
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

// ═══════════════════════════════════════════════════════════════
// CARD DE ESTATÍSTICAS (Histórico geral)
// ═══════════════════════════════════════════════════════════════

class _StatsCard extends StatelessWidget {
  final String totalKm;
  final String corridas;

  const _StatsCard({required this.totalKm, required this.corridas});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.show_chart, color: AppColors.primary, size: 16),
              SizedBox(width: 6),
              Text(
                'HISTÓRICO GERAL',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.mutedFg,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatItem(valor: totalKm, label: 'km percorridos'),
              ),
              Container(
                width: 1,
                height: 50,
                color: Colors.white.withOpacity(0.1),
              ),
              Expanded(
                child: _StatItem(valor: corridas, label: 'corridas'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String valor;
  final String label;

  const _StatItem({required this.valor, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          valor,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.mutedFg),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// CARD DE CORRIDA (aba Próximas)
// ═══════════════════════════════════════════════════════════════

enum _StatusTipo { inscrito, deadline, naoInscrito }

class _RunCard extends StatelessWidget {
  final String dia;
  final String mes;
  final String titulo;
  final String horario;
  final String local;
  final String km;
  final _StatusTipo statusTipo;
  final String statusTexto;
  final VoidCallback? onTap;

  const _RunCard({
    required this.dia,
    required this.mes,
    required this.titulo,
    required this.horario,
    required this.local,
    required this.km,
    required this.statusTipo,
    required this.statusTexto,
    this.onTap, 
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bloco de data
              SizedBox(
                width: 40,
                child: Column(
                  children: [
                    Text(
                      dia,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      mes,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.mutedFg,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Conteúdo principal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            titulo,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          km,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 13, color: AppColors.mutedFg),
                        const SizedBox(width: 4),
                        Text(
                          horario,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.mutedFg,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.place_outlined,
                            size: 13, color: AppColors.mutedFg),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            local,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.mutedFg,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _StatusBadge(tipo: statusTipo, texto: statusTexto),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final _StatusTipo tipo;
  final String texto;

  const _StatusBadge({required this.tipo, required this.texto});

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color bgColor;
    bool hasBorder = false;

    switch (tipo) {
      case _StatusTipo.inscrito:
        textColor = Colors.black;
        bgColor = AppColors.success;
        break;
      case _StatusTipo.deadline:
        textColor = Colors.black;
        bgColor = AppColors.alert;
        break;
      case _StatusTipo.naoInscrito:
        textColor = AppColors.mutedFg;
        bgColor = AppColors.secondary;
        hasBorder = true;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: hasBorder
            ? Border.all(color: Colors.white.withOpacity(0.08))
            : null,
      ),
      child: Text(
        texto,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// CARD DE CORRIDA COMPLETADA (aba Percorridas)
// ═══════════════════════════════════════════════════════════════

class _CompletedCard extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final String data;
  final String km;
  final bool metaBatida;

  const _CompletedCard({
    required this.titulo,
    required this.subtitulo,
    required this.data,
    required this.km,
    required this.metaBatida,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Troféu (contorno)
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.emoji_events_outlined,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          // Título + subtítulo + data
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitulo,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.mutedFg,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.mutedFg,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // km percorrido + badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                km,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 6),
              if (metaBatida)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.check, size: 13, color: AppColors.success),
                    SizedBox(width: 3),
                    Text(
                      'meta batida',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                )
              else
                const Text(
                  'parcial',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mutedFg,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}