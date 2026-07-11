import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class NatureBackground extends StatelessWidget {
  const NatureBackground({
    super.key,
    required this.child,
    this.showSilhouettes = true,
  });

  final Widget child;
  final bool showSilhouettes;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: _ChevronPattern()),
        if (showSilhouettes) const Positioned.fill(child: _CitySilhouettes()),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: MediaQuery.of(context).size.height * 0.28,
          child: const ColoredBox(color: AppColors.groundGreen),
        ),
        child,
      ],
    );
  }
}

class _ChevronPattern extends StatelessWidget {
  const _ChevronPattern();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ChevronPainter(),
      size: Size.infinite,
    );
  }
}

class _ChevronPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    const spacing = 28.0;
    const chevronSize = 10.0;

    for (double y = 0; y < size.height; y += spacing) {
      for (double x = 0; x < size.width; x += spacing) {
        final path = Path()
          ..moveTo(x, y + chevronSize)
          ..lineTo(x + chevronSize / 2, y)
          ..lineTo(x + chevronSize, y + chevronSize);
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CitySilhouettes extends StatelessWidget {
  const _CitySilhouettes();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _SilhouettePainter(
            groundHeight: constraints.maxHeight * 0.28,
          ),
        );
      },
    );
  }
}

class _SilhouettePainter extends CustomPainter {
  _SilhouettePainter({required this.groundHeight});

  final double groundHeight;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.silhouette.withValues(alpha: 0.4);
    final groundY = size.height - groundHeight;

    final buildings = [
      Rect.fromLTWH(size.width * 0.08, groundY - 40, 18, 40),
      Rect.fromLTWH(size.width * 0.18, groundY - 55, 14, 55),
      Rect.fromLTWH(size.width * 0.32, groundY - 35, 20, 35),
      Rect.fromLTWH(size.width * 0.55, groundY - 50, 16, 50),
      Rect.fromLTWH(size.width * 0.72, groundY - 38, 22, 38),
      Rect.fromLTWH(size.width * 0.85, groundY - 48, 12, 48),
    ];

    for (final rect in buildings) {
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
