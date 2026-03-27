import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class ProfilInfoCard extends StatelessWidget {
  const ProfilInfoCard({super.key});

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

          // ── Avatar + nom ──────────────────────────────
          Row(
            children: [
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primary, Color(0xFFFF9800)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                ),
                child: const Center(
                  child: Text(
                    'AS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Ahmed Stagiaire',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Master Informatique — 2ème année',
                    style: TextStyle(
                      color: AppTheme.textSecond,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),
          Container(height: 1, color: AppTheme.border),
          const SizedBox(height: 16),

          // ── Infos stage ───────────────────────────────
          const Text(
            'Informations du stage',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 12),

          _buildRow(
            icon: Icons.work_outline_rounded,
            label: 'Sujet',
            value: 'Gestion des stagiaires',
          ),
          const SizedBox(height: 10),
          _buildRow(
            icon: Icons.calendar_today_rounded,
            label: 'Début',
            value: '1 avril 2025',
          ),
          const SizedBox(height: 10),
          _buildRow(
            icon: Icons.event_rounded,
            label: 'Fin',
            value: '30 juin 2025',
          ),
          const SizedBox(height: 10),
          _buildRow(
            icon: Icons.timer_outlined,
            label: 'Durée',
            value: '3 mois',
          ),
        ],
      ),
    );
  }

  Widget _buildRow({
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