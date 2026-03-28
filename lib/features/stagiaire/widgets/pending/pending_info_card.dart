import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class PendingInfoCard extends StatelessWidget {
  const PendingInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.shadowSM,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppTheme.primarySoft,
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(Icons.work_outline_rounded,
                      color: AppTheme.primary, size: 20),
                ),
                const SizedBox(width: 12),
                const Text('Sujet de stage choisi',
                    style: TextStyle(
                        color: AppTheme.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w800)),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Développement d\'une application de gestion des stagiaires',
                  style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      height: 1.4,
                      letterSpacing: -0.3),
                ),

                const SizedBox(height: 20),

                _buildInfoRow(Icons.school_outlined,
                    'Filière', 'Informatique — Master'),
                _buildDivider(),
                _buildInfoRow(Icons.calendar_today_rounded,
                    'Date de dépôt', '18 mars 2025'),
                _buildDivider(),
                _buildInfoRow(Icons.timer_outlined,
                    'Durée', '3 mois'),

                const SizedBox(height: 20),

                const Text('Compétences requises',
                    style: TextStyle(
                        color: AppTheme.textSecond,
                        fontSize: 12,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: const [
                    'Flutter', 'Dart', 'Spring Boot', 'REST API', 'SQL',
                  ].map((s) => _SkillChip(label: s)).toList(),
                ),

                const SizedBox(height: 20),

                // CV déposé
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppTheme.success.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          color: AppTheme.success.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.picture_as_pdf_rounded,
                            color: AppTheme.success, size: 16),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text('CV déposé avec succès',
                            style: TextStyle(
                                color: AppTheme.success,
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                      ),
                      const Icon(Icons.check_circle_rounded,
                          color: AppTheme.success, size: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() =>
      Container(height: 1, color: AppTheme.border,
          margin: const EdgeInsets.symmetric(vertical: 12));

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 34, height: 34,
          decoration: BoxDecoration(
            color: AppTheme.background,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: AppTheme.border),
          ),
          child: Icon(icon, size: 16, color: AppTheme.textSecond),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    color: AppTheme.textLight,
                    fontSize: 11,
                    fontWeight: FontWeight.w500)),
            Text(value,
                style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String label;
  const _SkillChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primarySoft,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
      ),
      child: Text(label,
          style: const TextStyle(
              color: AppTheme.primary,
              fontSize: 12,
              fontWeight: FontWeight.w600)),
    );
  }
}