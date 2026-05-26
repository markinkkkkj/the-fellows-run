import 'package:flutter/material.dart';
import 'settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "The Fellows Run",
            style: TextStyle(
              color: theme.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          backgroundColor: theme.primary,
          actions: [
            IconButton(
              icon: Icon(Icons.settings_outlined, color: theme.onPrimary),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Settings(),
                  ),
                );
              },
            ),
          ],
          bottom: TabBar(
            labelColor: theme.onPrimary,
            unselectedLabelColor: theme.onPrimary.withOpacity(0.5),
            indicatorColor: theme.onPrimary,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
            tabs: const [
              Tab(text: 'Próximas'),
              Tab(text: 'Percorridas'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _UpcomingTab(),
            _CompletedTab(),
          ],
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
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      children: const [
        _RunCard(
          dia: '30',
          mes: 'MAI',
          titulo: 'Corrida da Lagoa',
          info: '8 km · 07:00',
          statusTipo: _StatusTipo.inscrito,
          statusTexto: 'Inscrito · Meta 5km',
        ),
        SizedBox(height: 12),
        _RunCard(
          dia: '05',
          mes: 'JUN',
          titulo: 'Trilha PUC',
          info: '5 km · 06:30',
          statusTipo: _StatusTipo.deadline,
          statusTexto: 'Deadline próximo',
        ),
        SizedBox(height: 12),
        _RunCard(
          dia: '15',
          mes: 'JUN',
          titulo: 'Maratona dos Fellows',
          info: '10 km · 07:00',
          statusTipo: _StatusTipo.naoInscrito,
          statusTexto: 'Não inscrito',
        ),
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
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      children: const [
        _StatsCard(totalKm: '5.2', corridas: '1'),
        SizedBox(height: 16),
        _CompletedCard(
          titulo: 'Corrida de Abertura',
          data: '20 de abril',
          meta: '5.0 km',
          percorrido: '5.2 km',
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// CARDS (sem mudança da versão anterior)
// ═══════════════════════════════════════════════════════════════

class _StatsCard extends StatelessWidget {
  final String totalKm;
  final String corridas;

  const _StatsCard({required this.totalKm, required this.corridas});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              valor: totalKm,
              unidade: 'km',
              label: 'Total percorrido',
              cor: theme.primary,
            ),
          ),
          Container(
            width: 1,
            height: 50,
            color: Colors.white.withOpacity(0.1),
          ),
          Expanded(
            child: _StatItem(
              valor: corridas,
              unidade: '',
              label: 'Corridas',
              cor: theme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String valor;
  final String unidade;
  final String label;
  final Color cor;

  const _StatItem({
    required this.valor,
    required this.unidade,
    required this.label,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: valor,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: cor,
                ),
              ),
              if (unidade.isNotEmpty)
                TextSpan(
                  text: ' $unidade',
                  style: TextStyle(fontSize: 14, color: cor),
                ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF777777)),
        ),
      ],
    );
  }
}

enum _StatusTipo { inscrito, deadline, naoInscrito }

class _RunCard extends StatelessWidget {
  final String dia;
  final String mes;
  final String titulo;
  final String info;
  final _StatusTipo statusTipo;
  final String statusTexto;

  const _RunCard({
    required this.dia,
    required this.mes,
    required this.titulo,
    required this.info,
    required this.statusTipo,
    required this.statusTexto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Column(
                children: [
                  Text(
                    dia,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    mes,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF777777),
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Container(
                width: 1,
                height: 50,
                color: Colors.white.withOpacity(0.08),
              ),
              const SizedBox(width: 16),
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
                    const SizedBox(height: 4),
                    Text(
                      info,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF777777),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _StatusBadge(tipo: statusTipo, texto: statusTexto),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFF777777)),
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
        textColor = const Color(0xFF22C55E);
        bgColor = const Color(0xFF22C55E).withOpacity(0.15);
        break;
      case _StatusTipo.deadline:
        textColor = const Color(0xFFF59E0B);
        bgColor = const Color(0xFFF59E0B).withOpacity(0.15);
        break;
      case _StatusTipo.naoInscrito:
        textColor = const Color(0xFF777777);
        bgColor = Colors.transparent;
        hasBorder = true;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: hasBorder
            ? Border.all(color: const Color(0xFF777777).withOpacity(0.5))
            : null,
      ),
      child: Text(
        texto,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

class _CompletedCard extends StatelessWidget {
  final String titulo;
  final String data;
  final String meta;
  final String percorrido;

  const _CompletedCard({
    required this.titulo,
    required this.data,
    required this.meta,
    required this.percorrido,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: Color(0xFF22C55E),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
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
                    Text(
                      data,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF777777),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF252525),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _MiniInfo(label: 'META', valor: meta),
                ),
                Container(
                  width: 1,
                  height: 30,
                  color: Colors.white.withOpacity(0.1),
                ),
                Expanded(
                  child: _MiniInfo(
                    label: 'PERCORRIDO',
                    valor: percorrido,
                    cor: theme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniInfo extends StatelessWidget {
  final String label;
  final String valor;
  final Color? cor;

  const _MiniInfo({required this.label, required this.valor, this.cor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Color(0xFF777777),
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          valor,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: cor ?? Colors.white,
          ),
        ),
      ],
    );
  }
}