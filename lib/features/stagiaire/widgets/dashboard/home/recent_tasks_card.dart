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
        Row(
          children: [
            const Text('ACTIVITÉ RÉCENTE',
                style: TextStyle(
                    color: AppTheme.textLight,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2)),
            const Spacer(),
            Text('Voir tout',
                style: TextStyle(
                    color: AppTheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 12),

        // Liste tâches
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.border),
            boxShadow: AppTheme.shadowSM,
          ),
          child: Column(
            children: recent.asMap().entries.map((entry) {
              final isLast = entry.key == recent.length - 1;
              return _TaskRow(tache: entry.value, isLast: isLast);
            }).toList(),
          ),
        ),

        const SizedBox(height: 20),

        // Accès rapide
        const Text('ACCÈS RAPIDE',
            style: TextStyle(
                color: AppTheme.textLight,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2)),
        const SizedBox(height: 12),

        Row(
          children: [
            _quickAccess(
              Icons.dashboard_rounded,
              'GS Board',
              'Kanban',
              const Color(0xFF6366F1),
            ),
            const SizedBox(width: 12),
            _quickAccess(
              Icons.description_outlined,
              'Rapport',
              'PDF',
              AppTheme.primary,
            ),
          ],
        ),
      ],
    );
  }

  Widget _quickAccess(
      IconData icon, String label, String sub, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border),
          boxShadow: AppTheme.shadowSM,
        ),
        child: Row(
          children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700)),
                Text(sub,
                    style: const TextStyle(
                        color: AppTheme.textLight, fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  final Tache tache;
  final bool isLast;
  const _TaskRow({required this.tache, required this.isLast});

  Color get _color {
    switch (tache.statut) {
      case TacheStatut.terminee: return AppTheme.success;
      case TacheStatut.enCours: return AppTheme.primary;
      default: return AppTheme.textLight;
    }
  }

  String get _label {
    switch (tache.statut) {
      case TacheStatut.terminee: return 'DONE';
      case TacheStatut.enCours: return 'EN COURS';
      default: return 'TO DO';
    }
  }

  IconData get _icon {
    switch (tache.statut) {
      case TacheStatut.terminee: return Icons.check_circle_rounded;
      case TacheStatut.enCours: return Icons.radio_button_checked_rounded;
      default: return Icons.circle_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 13),
          child: Row(
            children: [
              Icon(_icon, color: _color, size: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tache.titre,
                        style: TextStyle(
                            color: tache.statut == TacheStatut.terminee
                                ? AppTheme.textLight
                                : AppTheme.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            decoration:
                            tache.statut == TacheStatut.terminee
                                ? TextDecoration.lineThrough
                                : null),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text('${tache.issueKey} · Mis à jour récemment',
                        style: const TextStyle(
                            color: AppTheme.textLight, fontSize: 10)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: _color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(_label,
                    style: TextStyle(
                        color: _color,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3)),
              ),
            ],
          ),
        ),
        if (!isLast)
          Container(height: 1, color: AppTheme.border),
      ],
    );
  }
}