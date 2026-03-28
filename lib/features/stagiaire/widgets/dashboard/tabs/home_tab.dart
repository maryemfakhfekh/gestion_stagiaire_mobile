import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/stagiaire_model.dart';
import '../home/progress_card.dart';
import '../home/encadrant_card.dart';
import '../home/recent_tasks_card.dart';

class HomeTab extends StatelessWidget {
  final StagiaireModel dossier;
  const HomeTab({super.key, required this.dossier});

  String get _prenom => dossier.utilisateur.nomComplet.trim().split(' ').first;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Greeting ──────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bonjour, $_prenom 👋',
                        style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.6)),
                    const SizedBox(height: 4),
                    Text(dossier.sujet.titre.trim(),
                        style: const TextStyle(
                            color: AppTheme.textSecond,
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: dossier.statusStage == 'EN_COURS'
                      ? const Color(0xFFF0FDF4)
                      : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: dossier.statusStage == 'EN_COURS'
                        ? const Color(0xFF22C55E).withOpacity(0.3)
                        : AppTheme.border,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6, height: 6,
                      decoration: BoxDecoration(
                        color: dossier.statusStage == 'EN_COURS'
                            ? AppTheme.success
                            : AppTheme.textLight,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      dossier.statusStage == 'EN_COURS'
                          ? 'ACTIF'
                          : 'TERMINÉ',
                      style: TextStyle(
                        color: dossier.statusStage == 'EN_COURS'
                            ? AppTheme.success
                            : AppTheme.textLight,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // ── Bannière sujet ────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF57C00), Color(0xFFFFB74D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppTheme.shadowOrange,
            ),
            child: Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.work_outline_rounded,
                      color: Colors.white, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Sujet de stage',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 3),
                      Text(dossier.sujet.titre.trim(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Vue d'ensemble ────────────────────────────
          ProgressCard(progress: 0.6),

          const SizedBox(height: 24),

          // ── Encadrant ─────────────────────────────────
          EncadrantCard(encadrant: dossier.encadrant),

          const SizedBox(height: 24),

          // ── Activité récente ──────────────────────────
          const RecentTasksCard(),
        ],
      ),
    );
  }
}