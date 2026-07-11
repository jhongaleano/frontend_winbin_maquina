import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'pixel_tree_icon.dart';

class FormContainer extends StatelessWidget {
  const FormContainer({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(3, 3),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const PixelTreeIcon(
                type: TreeType.leafy,
                color: Color(0xFF5A7D2E),
                size: 20,
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTheme.pixelTitle(size: 11),
                ),
              ),
              const SizedBox(width: 10),
              const PixelTreeIcon(
                type: TreeType.pine,
                color: Color(0xFFF4A7B9),
                size: 20,
              ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: AppTheme.pixelSubtitle(size: 6),
            ),
          ],
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }
}
