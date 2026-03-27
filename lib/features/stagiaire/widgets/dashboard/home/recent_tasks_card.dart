import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/tache_model.dart';

class RecentTasksCard extends StatelessWidget {
  const RecentTasksCard({super.key});

  @override
  Widget build(BuildContext context) {
    final recent = fakeTaches.take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // ── Titre section style Jira ──────────────────
        Row(
          children: [
            const Text(
              'ACTIVITÉ RÉCENTE',
              style: TextStyle(
                color: AppTheme.textLight,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const Spacer(),
            Text(
              'Voir tout',
              style: TextStyle(
                color: AppTheme.primary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // ── Liste activité style Jira ─────────────────
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusMD),
            border: Border.all(color: AppTheme.border),
          ),
          child: Column(
            children: recent.asMap().entries.map((entry) {
              final index = entry.key;
              final tache = entry.value;
              final isLast = index == recent.length - 1;
              return _JiraTaskRow(tache: tache, isLast: isLast);
            }).toList(),
          ),
        ),

        const SizedBox(height: 14),

        // ── Quick access style Jira ───────────────────
        const Text(
          'ACCÈS RAPIDE',
          style: TextStyle(
            color: AppTheme.textLight,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            _buildQuickAccess(
              icon: Icons.dashboard_rounded,
              label: 'GS Board',
              subtitle: 'Kanban',
              color: const Color(0xFF6366F1),
            ),
            const SizedBox(width: 10),
            _buildQuickAccess(
              icon: Icons.description_outlined,
              label: 'Rapport',
              subtitle: 'PDF',
              color: AppTheme.primary,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAccess({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusXS),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppTheme.textLight,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Row tâche style Jira ───────────────────────────────────────────
class _JiraTaskRow extends StatelessWidget {
  final Tache tache;
  final bool isLast;
  const _JiraTaskRow({required this.tache, required this.isLast});

  Color get _statutColor {
    switch (tache.statut) {
      case TacheStatut.terminee:  return AppTheme.success;
      case TacheStatut.enCours:   return AppTheme.warning;
      default:                    return AppTheme.textLight;
    }
  }

  String get _statutLabel {
    switch (tache.statut) {
      case TacheStatut.terminee:  return 'DONE';
      case TacheStatut.enCours:   return 'IN PROGRESS';
      default:                    return 'TO DO';
    }
  }

  IconData get _statutIcon {
    switch (tache.statut) {
      case TacheStatut.terminee:
        return Icons.check_circle_rounded;
      case TacheStatut.enCours:
        return Icons.radio_button_checked_rounded;
      default:
        return Icons.circle_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [

              // Icône statut style Jira
              Icon(_statutIcon, color: _statutColor, size: 16),

              const SizedBox(width: 10),

              // Titre tâche
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tache.titre,
                      style: TextStyle(
                        color: tache.statut == TacheStatut.terminee
                            ? AppTheme.textLight
                            : AppTheme.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        decoration: tache.statut == TacheStatut.terminee
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'GS-${tache.id} · Mis à jour récemment',
                      style: const TextStyle(
                        color: AppTheme.textLight,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Badge statut style Jira
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6, vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: _statutColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusXS),
                  border: Border.all(
                    color: _statutColor.withOpacity(0.2),
                  ),
                ),
                child: Text(
                  _statutLabel,
                  style: TextStyle(
                    color: _statutColor,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast) Container(height: 1, color: AppTheme.border),
      ],
    );
  }
}