import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class RapportStatusCard extends StatelessWidget {
  final bool estDepose;
  const RapportStatusCard({super.key, this.estDepose = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: estDepose
            ? const Color(0xFFF0FDF4)
            : AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: estDepose
              ? AppTheme.success.withOpacity(0.3)
              : AppTheme.border,
        ),
        boxShadow: AppTheme.shadowSM,
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: estDepose
                  ? AppTheme.success.withOpacity(0.12)
                  : AppTheme.primarySoft,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              estDepose
                  ? Icons.check_circle_outline_rounded
                  : Icons.upload_file_rounded,
              color: estDepose ? AppTheme.success : AppTheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  estDepose ? 'Rapport déposé ✓' : 'Rapport non déposé',
                  style: TextStyle(
                      color: estDepose
                          ? AppTheme.success
                          : AppTheme.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  estDepose
                      ? 'Soumis · En attente de validation RH'
                      : 'Déposez votre rapport avant la fin du stage',
                  style: const TextStyle(
                      color: AppTheme.textSecond,
                      fontSize: 12,
                      height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}