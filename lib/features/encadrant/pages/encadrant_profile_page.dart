// lib/features/encadrant/pages/encadrant_profile_page.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../logic/encadrant_bloc.dart';

@RoutePage()
class EncadrantProfilePage extends StatelessWidget {
  const EncadrantProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return BlocBuilder<EncadrantBloc, EncadrantState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F7),
          body: SingleChildScrollView(
            child: Column(
              children: [

                // ── HERO HEADER DARK ──────────────────────────
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF1A1A1A),
                  ),
                  padding: EdgeInsets.fromLTRB(22, top + 20, 22, 32),
                  child: Column(
                    children: [
                      // top label
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
                          const Text('MON ESPACE',
                              style: TextStyle(
                                  color: Color(0xFF999999),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 2.0)),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Avatar
                      Container(
                        width: 76, height: 76,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFF57C00), Color(0xFFFFB74D)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFF57C00).withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(Icons.person_rounded,
                              color: Colors.white, size: 36),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('Encadrant',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF57C00).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: const Color(0xFFF57C00).withOpacity(0.3)),
                        ),
                        child: const Text('Responsable de stage',
                            style: TextStyle(
                                color: Color(0xFFFFB74D),
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),

                // ── STATS ROW ─────────────────────────────────
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      vertical: 20, horizontal: 22),
                  child: Row(
                    children: [
                      _stat('${state.stagiaires.length}',
                          'Stagiaires', const Color(0xFFF57C00)),
                      _statDivider(),
                      _stat('${state.dashboard.tachesCreees}',
                          'Tâches', const Color(0xFF10B981)),
                      _statDivider(),
                      _stat('${state.evaluationsByStagiaire.length}',
                          'Évaluations', const Color(0xFF6366F1)),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── MENU ──────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _menuItem(
                          context,
                          icon: Icons.people_rounded,
                          label: 'Mes stagiaires',
                          sub: '${state.stagiaires.length} assigné(s)',
                          color: const Color(0xFFF57C00),
                          bg: const Color(0xFFFFF4ED),
                          isFirst: true,
                          onTap: () {},
                        ),
                        _divider(),
                        _menuItem(
                          context,
                          icon: Icons.checklist_rounded,
                          label: 'Toutes les tâches',
                          sub: '${state.dashboard.tachesCreees} créées · ${state.dashboard.tachesEnAttente} en attente',
                          color: const Color(0xFF10B981),
                          bg: const Color(0xFFECFDF5),
                          onTap: () {},
                        ),
                        _divider(),
                        _menuItem(
                          context,
                          icon: Icons.star_rounded,
                          label: 'Évaluations',
                          sub: '${state.evaluationsByStagiaire.length} soumise(s)',
                          color: const Color(0xFF6366F1),
                          bg: const Color(0xFFEEF2FF),
                          isLast: true,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ── DÉCONNEXION ───────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GestureDetector(
                    onTap: () async {
                      const storage = FlutterSecureStorage();
                      await storage.deleteAll();
                      if (context.mounted) {
                        context.router.replace(const LoginRoute());
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout_rounded,
                              color: Colors.white70, size: 18),
                          SizedBox(width: 10),
                          Text('Se déconnecter',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _stat(String value, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: color,
                  letterSpacing: -1)),
          const SizedBox(height: 3),
          Text(label,
              style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _statDivider() {
    return Container(
      width: 1, height: 36,
      color: const Color(0xFFF3F4F6),
    );
  }

  Widget _divider() =>
      Container(height: 1, color: const Color(0xFFF9FAFB),
          margin: const EdgeInsets.symmetric(horizontal: 16));

  Widget _menuItem(
      BuildContext context, {
        required IconData icon,
        required String label,
        required String sub,
        required Color color,
        required Color bg,
        bool isFirst = false,
        bool isLast = false,
        VoidCallback? onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111827))),
                  const SizedBox(height: 2),
                  Text(sub,
                      style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9CA3AF))),
                ],
              ),
            ),
            Container(
              width: 28, height: 28,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.arrow_forward_ios_rounded,
                  size: 12, color: Color(0xFF9CA3AF)),
            ),
          ],
        ),
      ),
    );
  }
}