import 'package:flutter/material.dart';

import 'package:the_fellows_run/theme/app_colors.dart';

enum StatusTipo { inscrito, deadline, naoInscrito }

/// Card de corrida exibido na aba "Próximas".
class RunCard extends StatelessWidget {
  final String dia;
  final String mes;
  final String titulo;
  final String horario;
  final String local;
  final String km;
  final StatusTipo statusTipo;
  final String statusTexto;
  final VoidCallback? onTap;

  const RunCard({
    super.key,
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
  final StatusTipo tipo;
  final String texto;

  const _StatusBadge({required this.tipo, required this.texto});

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color bgColor;
    bool hasBorder = false;

    switch (tipo) {
      case StatusTipo.inscrito:
        textColor = Colors.black;
        bgColor = AppColors.success;
        break;
      case StatusTipo.deadline:
        textColor = Colors.black;
        bgColor = AppColors.alert;
        break;
      case StatusTipo.naoInscrito:
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
