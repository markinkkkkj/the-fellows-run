import 'package:flutter/material.dart';

import 'package:the_fellows_run/theme/app_colors.dart';
import 'package:the_fellows_run/widgets/app_card.dart';
import 'package:the_fellows_run/widgets/status_badge.dart';

enum StatusType { registered, deadline, notRegistered }

/// Card de corrida exibido na aba "Próximas".
class RunCard extends StatelessWidget {
  final String day;
  final String month;
  final String title;
  final String time;
  final String location;
  final String km;
  final StatusType statusType;
  final String statusText;
  final VoidCallback? onTap;

  const RunCard({
    super.key,
    required this.day,
    required this.month,
    required this.title,
    required this.time,
    required this.location,
    required this.km,
    required this.statusType,
    required this.statusText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      radius: 20,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bloco de data
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Text(
                  day,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  month,
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
                        title,
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
                      time,
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
                        location,
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
                _StatusBadge(type: statusType, text: statusText),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final StatusType type;
  final String text;

  const _StatusBadge({required this.type, required this.text});

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color bgColor;
    bool hasBorder = false;

    switch (type) {
      case StatusType.registered:
        textColor = Colors.black;
        bgColor = AppColors.success;
        break;
      case StatusType.deadline:
        textColor = Colors.black;
        bgColor = AppColors.alert;
        break;
      case StatusType.notRegistered:
        textColor = AppColors.mutedFg;
        bgColor = AppColors.secondary;
        hasBorder = true;
        break;
    }

    return StatusBadge(
      text: text,
      background: bgColor,
      foreground: textColor,
      border: hasBorder,
    );
  }
}
