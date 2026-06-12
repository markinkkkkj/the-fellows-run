import 'package:flutter/material.dart';

import 'package:the_fellows_run/theme/app_colors.dart';
import 'package:the_fellows_run/widgets/dotted_border.dart';

/// Botão tracejado "Ver mais corridas" usado nas abas da home.
class SeeMoreButton extends StatelessWidget {
  const SeeMoreButton({super.key});

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
