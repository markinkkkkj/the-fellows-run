import 'package:flutter/material.dart';

import 'package:the_fellows_run/theme/app_colors.dart';

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
      ..color = AppColors.dottedLine
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
