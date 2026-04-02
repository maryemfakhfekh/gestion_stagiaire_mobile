// lib/features/stagiaire/widgets/dashboard/home/recent_tasks_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/tache_model.dart';
import '../../../logic/tache_bloc.dart';

class RecentTasksCard extends StatelessWidget {
  const RecentTasksCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TacheBloc>()..add(LoadTaches()),
      child: const _RecentTasksView(),
    );
  }
}

class _RecentTasksView extends StatelessWidget {
  const _RecentTasksView();

  Color _color(TacheStatut s) {
    switch (s) {
      case TacheStatut.terminee: return AppTheme.success;
      case TacheStatut.enCours:  return AppTheme.primary;
      default:                   return AppTheme.textLight;
    }
  }

  String _label(TacheStatut s) {
    switch (s) {
      case TacheStatut.terminee: return 'DONE';
      case TacheStatut.enCours:  return 'EN COURS';
      default:                   return 'TO DO';
    }
  }

  IconData _icon(TacheStatut s) {
    switch (s) {
      case TacheStatut.terminee: return Icons.check_circle_rounded;
      case TacheStatut.enCours:  return Icons.radio_button_checked_rounded;
      default:                   return Icons.circle_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TacheBloc, TacheState>(
      builder: (context, state) {
        final taches = state is TacheLoaded
            ? state.taches.take(4).toList()
            : <TacheModel>[];

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
                if (state is TacheLoading)
                  const SizedBox(
                    width: 14, height: 14,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppTheme.primary),
                  )
                else
                  const Text('Voir tout',
                      style: TextStyle(
                          color: AppTheme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
                boxShadow: AppTheme.shadowSM,
              ),
              child: taches.isEmpty
                  ? Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    state is TacheLoading
                        ? 'Chargement...'
                        : 'Aucune tâche récente',
                    style: const TextStyle(
                        color: AppTheme.textLight, fontSize: 13),
                  ),
                ),
              )
                  : Column(
                children: taches.asMap().entries.map((e) {
                  final isLast = e.key == taches.length - 1;
                  final t = e.value;
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 13),
                        child: Row(
                          children: [
                            Icon(_icon(t.statut),
                                color: _color(t.statut), size: 18),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(t.titre,
                                      style: TextStyle(
                                          color: t.statut ==
                                              TacheStatut.terminee
                                              ? AppTheme.textLight
                                              : AppTheme.textPrimary,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          decoration: t.statut ==
                                              TacheStatut.terminee
                                              ? TextDecoration.lineThrough
                                              : null),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 2),
                                  Text('${t.issueKey} · Récemment mis à jour',
                                      style: const TextStyle(
                                          color: AppTheme.textLight,
                                          fontSize: 10)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: _color(t.statut).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(_label(t.statut),
                                  style: TextStyle(
                                      color: _color(t.statut),
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
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            const Text('ACCÈS RAPIDE',
                style: TextStyle(
                    color: AppTheme.textLight,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2)),
            const SizedBox(height: 12),
            Row(
              children: [
                _quickCard(Icons.dashboard_rounded, 'GS Board',
                    'Kanban', const Color(0xFF6366F1)),
                const SizedBox(width: 12),
                _quickCard(Icons.description_outlined, 'Rapport',
                    'PDF', AppTheme.primary),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _quickCard(IconData icon, String label, String sub, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border),
          boxShadow: AppTheme.shadowSM,
        ),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
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