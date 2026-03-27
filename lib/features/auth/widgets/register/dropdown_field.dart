import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class DropdownField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? errorText;

  const DropdownField({
    super.key,
    required this.hint,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    this.value,
    required this.items,
    required this.onChanged,
    this.errorText,
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
          child: DropdownButtonFormField<String>(
            value: items.contains(value) ? value : null,
            isExpanded: true,
            decoration: InputDecoration(
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
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 4,
              ),
            ),
            hint: Text(hint,
                style: const TextStyle(
                    color: AppTheme.textLight, fontSize: 14)),
            icon: const Icon(Icons.keyboard_arrow_down_rounded,
                color: AppTheme.textLight),
            dropdownColor: AppTheme.surface,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimary,
            ),
            items: items.isEmpty
                ? [
              const DropdownMenuItem(
                value: null,
                enabled: false,
                child: Text(
                  "Chargement...",
                  style: TextStyle(
                      color: AppTheme.textLight, fontSize: 14),
                ),
              )
            ]
                : items
                .map((item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            ))
                .toList(),
            onChanged: items.isEmpty ? null : onChanged,
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