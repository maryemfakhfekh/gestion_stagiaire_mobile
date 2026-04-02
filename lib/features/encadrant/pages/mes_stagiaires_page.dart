// lib/features/encadrant/pages/mes_stagiaires_page.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../data/models/stagiaire_encadrant_model.dart';
import '../logic/encadrant_bloc.dart';
import '../widgets/stagiaire_card.dart';

@RoutePage()
class MesStagiairesPage extends StatelessWidget {
  const MesStagiairesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return BlocBuilder<EncadrantBloc, EncadrantState>(
      builder: (context, state) {
        final total     = state.stagiaires.length;
        final actifs    = state.stagiaires.where((s) => s.estEnCours).length;
        final enAttente = state.dashboard.tachesEnAttente;

        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F7),
          body: Column(
            children: [

              // ── HEADER PREMIUM ─────────────────────────────
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1A1A1A), Color(0xFF2D2D2D)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: EdgeInsets.fromLTRB(22, top + 18, 22, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 8, height: 8,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFF57C00),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('TABLEAU DE BORD',
                                      style: TextStyle(
                                          color: Color(0xFF999999),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 2.0)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text('Mes Stagiaires',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -0.8,
                                      height: 1.1)),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context
                              .read<EncadrantBloc>()
                              .add(LoadStagiaires()),
                          child: Container(
                            width: 40, height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.15)),
                            ),
                            child: const Icon(Icons.refresh_rounded,
                                color: Colors.white70, size: 18),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ── KPI CARDS ────────────────────────────
                    Row(
                      children: [
                        _kpiDark('$total', 'Total', const Color(0xFFF57C00)),
                        const SizedBox(width: 10),
                        _kpiDark('$actifs', 'Actifs', const Color(0xFF34D399)),
                        const SizedBox(width: 10),
                        _kpiDark('$enAttente', 'En attente', const Color(0xFFFBBF24)),
                      ],
                    ),
                  ],
                ),
              ),

              // ── LISTE ──────────────────────────────────────
              Expanded(
                child: state.isLoading
                    ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
                    : state.error != null
                    ? _buildError(context)
                    : state.stagiaires.isEmpty
                    ? _buildEmpty()
                    : RefreshIndicator(
                  color: AppTheme.primary,
                  onRefresh: () async => context
                      .read<EncadrantBloc>()
                      .add(LoadStagiaires()),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                    itemCount: state.stagiaires.length,
                    itemBuilder: (context, i) {
                      final s = state.stagiaires[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: StagiaireCard(
                          stagiaire: s,
                          tachesCount: state.tachesByStagiaire[s.id]?.length ?? 0,
                          onTap: () => context.router.push(
                            DetailStagiaireRoute(stagiaire: s),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _kpiDark(String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: color,
                    letterSpacing: -0.5)),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: color.withOpacity(0.7))),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              color: AppTheme.error.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.wifi_off_rounded,
                color: AppTheme.error, size: 28),
          ),
          const SizedBox(height: 14),
          const Text('Connexion impossible',
              style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => context.read<EncadrantBloc>().add(LoadStagiaires()),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('Réessayer',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              color: AppTheme.primarySoft,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(Icons.people_outline_rounded,
                color: AppTheme.primary, size: 36),
          ),
          const SizedBox(height: 18),
          const Text('Aucun stagiaire assigné',
              style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          const Text('Le RH vous assignera des stagiaires bientôt',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textSecond, fontSize: 13)),
        ],
      ),
    );
  }
}