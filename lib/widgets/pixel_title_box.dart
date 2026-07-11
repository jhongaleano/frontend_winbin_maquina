import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class PixelTitleBox extends StatelessWidget {
  const PixelTitleBox({
    super.key,
    required this.title,
    this.subtitle,
  });

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.85),
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppTheme.pixelTitle(size: 14),
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 12),
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: AppTheme.pixelSubtitle(size: 7),
          ),
        ],
      ],
    );
  }
}
