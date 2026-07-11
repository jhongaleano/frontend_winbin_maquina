import 'package:flutter/material.dart';

enum TreeType { pine, leafy }

class PixelTreeIcon extends StatelessWidget {
  const PixelTreeIcon({
    super.key,
    required this.type,
    required this.color,
    this.size = 24,
  });

  final TreeType type;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: type == TreeType.pine
          ? _PineTreePainter(color: color)
          : _LeafyTreePainter(color: color),
    );
  }
}

class _PineTreePainter extends CustomPainter {
  _PineTreePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final trunk = Paint()..color = const Color(0xFF5C4033);
    final pixel = size.width / 8;

    canvas.drawRect(
      Rect.fromLTWH(pixel * 3, pixel * 5, pixel * 2, pixel * 3),
      trunk,
    );
    canvas.drawRect(Rect.fromLTWH(pixel, pixel * 4, pixel * 6, pixel), paint);
    canvas.drawRect(Rect.fromLTWH(pixel * 1.5, pixel * 2.5, pixel * 5, pixel), paint);
    canvas.drawRect(Rect.fromLTWH(pixel * 2, pixel, pixel * 4, pixel), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LeafyTreePainter extends CustomPainter {
  _LeafyTreePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final trunk = Paint()..color = const Color(0xFF5C4033);
    final pixel = size.width / 8;

    canvas.drawRect(
      Rect.fromLTWH(pixel * 3.5, pixel * 5, pixel * 1.5, pixel * 3),
      trunk,
    );
    canvas.drawRect(Rect.fromLTWH(pixel * 2, pixel * 2, pixel * 4, pixel * 3.5), paint);
    canvas.drawRect(Rect.fromLTWH(pixel * 1, pixel * 3, pixel, pixel), paint);
    canvas.drawRect(Rect.fromLTWH(pixel * 6, pixel * 3, pixel, pixel), paint);
    canvas.drawRect(Rect.fromLTWH(pixel * 2.5, pixel, pixel * 3, pixel * 1.5), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
