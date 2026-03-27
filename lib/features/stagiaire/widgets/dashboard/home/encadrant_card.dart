import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class EncadrantCard extends StatelessWidget {
  const EncadrantCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // ── Titre section style Jira ──────────────────
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            'MON ÉQUIPE',
            style: TextStyle(
              color: AppTheme.textLight,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),

        // ── Card encadrant ────────────────────────────
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusMD),
            border: Border.all(color: AppTheme.border),
          ),
          child: Row(
            children: [

              // Avatar circulaire style Jira
              Container(
                width: 40, height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF0052CC),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'MB',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dr. Mohamed Ben Ali',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          width: 7, height: 7,
                          decoration: const BoxDecoration(
                            color: AppTheme.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'En ligne · Encadrant',
                          style: TextStyle(
                            color: AppTheme.textSecond,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Actions style Jira
              Row(
                children: [
                  _buildAction(Icons.mail_outline_rounded),
                  const SizedBox(width: 8),
                  _buildAction(Icons.more_horiz_rounded),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAction(IconData icon) {
    return Container(
      width: 32, height: 32,
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(AppTheme.radiusXS),
        border: Border.all(color: AppTheme.border),
      ),
      child: Icon(icon, size: 15, color: AppTheme.textSecond),
    );
  }
}