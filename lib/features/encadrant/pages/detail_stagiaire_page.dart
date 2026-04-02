// lib/features/encadrant/pages/detail_stagiaire_page.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../data/models/stagiaire_encadrant_model.dart';
import '../data/models/tache_encadrant_model.dart';
import '../logic/encadrant_bloc.dart';
import '../widgets/tache_encadrant_card.dart';

@RoutePage()
class DetailStagiairePage extends StatefulWidget {
  final StagiaireEncadrantModel stagiaire;

  const DetailStagiairePage({super.key, required this.stagiaire});

  @override
  State<DetailStagiairePage> createState() => _DetailStagiairePageState();
}

class _DetailStagiairePageState extends State<DetailStagiairePage> {
  @override
  void initState() {
    super.initState();
    context.read<EncadrantBloc>().add(LoadTaches(widget.stagiaire.id));
    context.read<EncadrantBloc>().add(LoadEvaluation(widget.stagiaire.id));
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.stagiaire;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: BlocBuilder<EncadrantBloc, EncadrantState>(
          builder: (context, state) {
            final taches = state.tachesByStagiaire[s.id] ?? [];
            final eval = state.evaluationsByStagiaire[s.id];
            final terminees = taches
                .where((t) => t.statut == StatutTacheEncadrant.termine)
                .length;

            return Column(
              children: [
                // ── Header ────────────────────────────────
                _buildHeader(context, s),
                Container(height: 1, color: AppTheme.border),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Profil stagiaire ───────────────
                        _buildProfilCard(s),
                        const SizedBox(height: 16),

                        // ── Stats ──────────────────────────
                        _buildStatsRow(taches.length, terminees, eval),
                        const SizedBox(height: 16),

                        // ── Actions rapides ────────────────
                        _buildActions(context, s, eval),
                        const SizedBox(height: 20),

                        // ── Tâches ─────────────────────────
                        Row(
                          children: [
                            const Text('Tâches assignées',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: AppTheme.textPrimary)),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppTheme.primarySoft,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text('${taches.length}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.primary)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        if (taches.isEmpty)
                          _buildEmptyTaches()
                        else
                          ...taches.map((t) => TacheEncadrantCard(
                            tache: t,
                            onDelete: () => context
                                .read<EncadrantBloc>()
                                .add(DeleteTache(
                              stagiaireId: s.id,
                              tacheId: t.id,
                            )),
                          )),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),

      // ── FAB Créer tâche ───────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router
            .push(CreerTacheRoute(stagiaire: widget.stagiaire)),
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.add_task_rounded, color: Colors.white),
        label: const Text('Créer une tâche',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700)),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, StagiaireEncadrantModel s) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.router.back(),
            child: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 16, color: AppTheme.textPrimary),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.nomComplet,
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.3)),
                Text(s.sujetTitre,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 12, color: AppTheme.textSecond)),
              ],
            ),
          ),
          // Badge statut
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: s.estEnCours
                  ? const Color(0xFFF0FDF4)
                  : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6, height: 6,
                  decoration: BoxDecoration(
                    color: s.estEnCours
                        ? AppTheme.success
                        : AppTheme.textLight,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  s.estEnCours ? 'Actif' : 'Terminé',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: s.estEnCours
                          ? AppTheme.success
                          : AppTheme.textLight),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilCard(StagiaireEncadrantModel s) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.shadowSM,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50, height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF57C00), Color(0xFFFFB74D)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(s.initiale,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.nomComplet,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary)),
                    const SizedBox(height: 3),
                    Text(s.email,
                        style: const TextStyle(
                            fontSize: 12, color: AppTheme.textSecond)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: AppTheme.border),
          const SizedBox(height: 14),
          _infoRow(Icons.work_outline_rounded, 'Sujet', s.sujetTitre),
          const SizedBox(height: 10),
          _infoRow(Icons.school_outlined, 'Filière · Cycle',
              '${s.filiere} · ${s.cycle}'),
          const SizedBox(height: 10),
          _infoRow(Icons.calendar_today_outlined, 'Début', s.dateDebut),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppTheme.textLight),
        const SizedBox(width: 8),
        Text('$label : ',
            style: const TextStyle(
                fontSize: 12, color: AppTheme.textSecond)),
        Expanded(
          child: Text(value,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary),
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  Widget _buildStatsRow(
      int total, int terminees, dynamic eval) {
    return Row(
      children: [
        _statCard('$total', 'Tâches', AppTheme.primary,
            AppTheme.primarySoft),
        const SizedBox(width: 10),
        _statCard('$terminees', 'Terminées', AppTheme.success,
            const Color(0xFFF0FDF4)),
        const SizedBox(width: 10),
        _statCard(
          eval != null ? '${eval.note}/20' : '—',
          'Note',
          AppTheme.warning,
          const Color(0xFFFFFBEB),
        ),
      ],
    );
  }

  Widget _statCard(
      String value, String label, Color color, Color bg) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: color)),
            const SizedBox(height: 3),
            Text(label,
                style: const TextStyle(
                    fontSize: 11, color: AppTheme.textSecond)),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context,
      StagiaireEncadrantModel s, dynamic eval) {
    return Row(
      children: [
        Expanded(
          child: _actionBtn(
            icon: Icons.star_rate_rounded,
            label: eval != null ? 'Voir évaluation' : 'Évaluer',
            color: AppTheme.warning,
            bg: const Color(0xFFFFFBEB),
            onTap: () => context.router
                .push(EvaluationRoute(stagiaire: s)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _actionBtn(
            icon: Icons.description_outlined,
            label: 'Rapport PDF',
            color: AppTheme.primary,
            bg: AppTheme.primarySoft,
            onTap: () => context.router
                .push(RapportDetailRoute(stagiaire: s)),
          ),
        ),
      ],
    );
  }

  Widget _actionBtn({
    required IconData icon,
    required String label,
    required Color color,
    required Color bg,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(label,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyTaches() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: const Center(
        child: Column(
          children: [
            Icon(Icons.checklist_rounded,
                color: AppTheme.textLight, size: 32),
            SizedBox(height: 10),
            Text('Aucune tâche créée',
                style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700)),
            SizedBox(height: 4),
            Text('Appuyez sur le bouton + pour créer une tâche',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppTheme.textSecond, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}