import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class PendingInfoCard extends StatelessWidget {
  const PendingInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.shadowSM,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Titre section ─────────────────────────────
          Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.primarySoft,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                ),
                child: const Icon(
                  Icons.work_outline_rounded,
                  color: AppTheme.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Sujet de stage choisi',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Container(height: 1, color: AppTheme.border),
          const SizedBox(height: 16),

          // ── Titre du sujet ────────────────────────────
          const Text(
            'Développement d\'une application de gestion des stagiaires',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 16),

          // ── Infos ─────────────────────────────────────
          _buildInfoRow(
            icon: Icons.school_outlined,
            label: 'Filière',
            value: 'Informatique — Master',
          ),
          const SizedBox(height: 10),
          _buildInfoRow(
            icon: Icons.calendar_today_rounded,
            label: 'Date de dépôt',
            value: '18 mars 2025',
          ),
          const SizedBox(height: 10),
          _buildInfoRow(
            icon: Icons.timer_outlined,
            label: 'Durée',
            value: '3 mois',
          ),

          const SizedBox(height: 16),

          // ── Compétences requises ──────────────────────
          const Text(
            'Compétences requises',
            style: TextStyle(
              color: AppTheme.textSecond,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: const [
              'Flutter', 'Dart', 'Spring Boot', 'REST API', 'SQL',
            ].map((skill) => _SkillChip(label: skill)).toList(),
          ),

          const SizedBox(height: 16),

          // ── Note CV ───────────────────────────────────
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primarySoft,
              borderRadius: BorderRadius.circular(AppTheme.radiusSM),
              border: Border.all(
                color: AppTheme.primary.withOpacity(0.15),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusXS),
                  ),
                  child: const Icon(
                    Icons.picture_as_pdf_rounded,
                    color: AppTheme.primary,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'CV déposé avec succès',
                    style: TextStyle(
                      color: AppTheme.textSecond,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppTheme.success,
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Info row ───────────────────────────────────────────────────
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: AppTheme.background,
            borderRadius: BorderRadius.circular(AppTheme.radiusXS),
            border: Border.all(color: AppTheme.border),
          ),
          child: Icon(icon, size: 15, color: AppTheme.textSecond),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.textLight,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Skill chip ─────────────────────────────────────────────────────
class _SkillChip extends StatelessWidget {
  final String label;
  const _SkillChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
        border: Border.all(color: AppTheme.border),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppTheme.textSecond,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
