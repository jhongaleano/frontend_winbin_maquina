import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'pixel_tree_icon.dart';

class PixelInfoCard extends StatelessWidget {
  const PixelInfoCard({
    super.key,
    required this.tabLabel,
    required this.title,
    required this.score,
    required this.progress,
    required this.accentColor,
    required this.treeType,
  });

  final String tabLabel;
  final String title;
  final String score;
  final double progress;
  final Color accentColor;
  final TreeType treeType;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          border: Border.all(color: accentColor, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: accentColor,
              child: Text(
                tabLabel,
                style: AppTheme.pixelBody(size: 7, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PixelTreeIcon(type: treeType, color: accentColor),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: AppTheme.pixelBody(size: 7),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  _PixelProgressBar(
                    progress: progress,
                    fillColor: accentColor,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    score,
                    style: AppTheme.pixelBody(size: 6, color: AppColors.scoreGrey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PixelProgressBar extends StatelessWidget {
  const _PixelProgressBar({
    required this.progress,
    required this.fillColor,
  });

  final double progress;
  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress.clamp(0.0, 1.0),
        child: ColoredBox(color: fillColor),
      ),
    );
  }
}
