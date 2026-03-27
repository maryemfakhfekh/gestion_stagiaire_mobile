import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class RapportStatusCard extends StatelessWidget {
  final bool estDepose;
  const RapportStatusCard({super.key, this.estDepose = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
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
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: estDepose
                  ? AppTheme.success.withOpacity(0.1)
                  : AppTheme.primarySoft,
              borderRadius: BorderRadius.circular(AppTheme.radiusSM),
            ),
            child: Icon(
              estDepose
                  ? Icons.check_circle_outline_rounded
                  : Icons.upload_file_rounded,
              color: estDepose ? AppTheme.success : AppTheme.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  estDepose ? 'Rapport déposé' : 'Rapport non déposé',
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  estDepose
                      ? 'Soumis le 15 juin 2025 · En attente de validation'
                      : 'Déposez votre rapport avant la fin du stage',
                  style: const TextStyle(
                    color: AppTheme.textSecond,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}