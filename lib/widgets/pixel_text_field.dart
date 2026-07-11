import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class PixelTextField extends StatelessWidget {
  const PixelTextField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.hint,
  });

  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTheme.pixelBody(size: 8, color: AppColors.oliveGreen)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: AppTheme.pixelBody(size: 9),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTheme.pixelBody(size: 8, color: AppColors.scoreGrey),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black, width: 3),
              borderRadius: BorderRadius.zero,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.oliveGreen, width: 3),
              borderRadius: BorderRadius.zero,
            ),
          ),
        ),
      ],
    );
  }
}
