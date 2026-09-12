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
    this.validator,
    this.textInputAction,
  });

  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? hint;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.pixelBody(size: 8, color: AppColors.oliveGreen),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 350,
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            validator: validator,
            style: AppTheme.pixelBody(size: 9),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTheme.pixelBody(
                size: 8,
                color: AppColors.scoreGrey,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 3),
                borderRadius: BorderRadius.zero,
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.oliveGreen, width: 3),
                borderRadius: BorderRadius.zero,
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.redAccent, width: 3),
                borderRadius: BorderRadius.zero,
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.redAccent, width: 3),
                borderRadius: BorderRadius.zero,
              ),
              errorStyle: AppTheme.pixelBody(size: 7, color: Colors.redAccent),
            ),
          ),
        ),
      ],
    );
  }
}
