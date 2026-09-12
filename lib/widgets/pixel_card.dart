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
    this.avatarUrl,
  });

  final String tabLabel;
  final String title;
  final String score;
  final double progress;
  final Color accentColor;
  final TreeType treeType;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        border: Border.all(color: accentColor, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.30),
            offset: const Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: accentColor,
              border: Border(
                bottom: BorderSide(
                  color: accentColor.withValues(alpha: 1.0),
                  width: 2.5,
                ),
              ),
            ),
            child: Text(
              tabLabel.toUpperCase(),
              style: AppTheme.pixelBody(size: 11, color: Colors.white),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (avatarUrl != null && avatarUrl!.isNotEmpty)
                        Container(
                          width: 42,
                          height: 42,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            color: Colors.white,
                          ),
                          child: Image.network(
                            avatarUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                PixelTreeIcon(
                                  type: treeType,
                                  color: accentColor,
                                ),
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: PixelTreeIcon(
                            type: treeType,
                            color: accentColor,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          title,
                          style: AppTheme.pixelBody(
                            size: 14,
                          ).copyWith(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const SizedBox(height: 24),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _PixelProgressBar(
                        progress: progress,
                        fillColor: accentColor,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        score,
                        style: AppTheme.pixelBody(
                          size: 11,
                          color: AppColors.scoreGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PixelProgressBar extends StatelessWidget {
  const _PixelProgressBar({required this.progress, required this.fillColor});

  final double progress;
  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress.clamp(0.0, 1.0),
        child: Container(
          color: fillColor,
          child: const Align(
            alignment: Alignment.topCenter,
            child: ColoredBox(
              color: Colors.white24,
              child: SizedBox(width: double.infinity, height: 3),
            ),
          ),
        ),
      ),
    );
  }
}
