import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String? errorText;
  final bool obscure;
  final bool readOnly;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;

  const InputField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    this.errorText,
    this.obscure = false,
    this.readOnly = false,
    this.suffixIcon,
    this.keyboardType,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(AppTheme.radiusMD),
            border: Border.all(
              color: errorText != null
                  ? AppTheme.error.withOpacity(0.5)
                  : AppTheme.border,
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            readOnly: readOnly,
            onTap: onTap,
            keyboardType: keyboardType,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: AppTheme.textLight,
                fontSize: 14,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(AppTheme.radiusXS),
                  ),
                  child: Icon(icon, color: iconColor, size: 16),
                ),
              ),
              suffixIcon: suffixIcon != null
                  ? Padding(
                padding: const EdgeInsets.only(right: 12),
                child: suffixIcon,
              )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 6),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded,
                    size: 12, color: AppTheme.error),
                const SizedBox(width: 4),
                Text(
                  errorText!,
                  style: const TextStyle(
                    color: AppTheme.error,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}