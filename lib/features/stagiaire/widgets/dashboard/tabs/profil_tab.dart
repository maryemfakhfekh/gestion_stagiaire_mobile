import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../core/routes/app_router.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/stagiaire_model.dart';

class ProfilTab extends StatelessWidget {
  final StagiaireModel dossier;
  const ProfilTab({super.key, required this.dossier});

  @override
  Widget build(BuildContext context) {
    final u = dossier.utilisateur;
    final s = dossier.sujet;
    final e = dossier.encadrant;

    final initials = u.nomComplet.trim().split(' ').length >= 2
        ? '${u.nomComplet.trim().split(' ')[0][0]}${u.nomComplet.trim().split(' ')[1][0]}'.toUpperCase()
        : u.nomComplet.substring(0, 2).toUpperCase();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Titre ─────────────────────────────────────
          const Text('Mon Profil',
              style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5)),
          const SizedBox(height: 4),
          const Text('Informations de votre stage',
              style: TextStyle(
                  color: AppTheme.textSecond, fontSize: 13)),

          const SizedBox(height: 24),

          // ── Card profil ───────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.border),
              boxShadow: AppTheme.shadowSM,
            ),
            child: Column(
              children: [

                // Header card avec gradient
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF57C00), Color(0xFFFFB74D)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60, height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(initials,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(u.nomComplet,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.3)),
                            const SizedBox(height: 4),
                            Text(
                              '${u.cycle?.nom ?? ''} · ${u.filiere?.nom ?? ''}',
                              style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Infos stage
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Informations du stage',
                          style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 14),
                      _buildRow(Icons.work_outline_rounded,
                          'Sujet', s.titre.trim()),
                      _buildDivider(),
                      _buildRow(Icons.calendar_today_rounded,
                          'Début', dossier.dateDebut),
                      _buildDivider(),
                      _buildRow(Icons.school_outlined,
                          'Établissement', u.etablissement ?? '—'),
                      _buildDivider(),
                      _buildRow(Icons.email_outlined,
                          'Email', u.email),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Encadrant ─────────────────────────────────
          if (e != null)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
                boxShadow: AppTheme.shadowSM,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Encadrant assigné',
                      style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Container(
                        width: 46, height: 46,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E3A5F),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            e.nomComplet.trim().split(' ').length >= 2
                                ? '${e.nomComplet.trim().split(' ')[0][0]}${e.nomComplet.trim().split(' ')[1][0]}'.toUpperCase()
                                : e.nomComplet.substring(0, 2).toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.nomComplet,
                                style: const TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(height: 3),
                            Text(e.email,
                                style: const TextStyle(
                                    color: AppTheme.textSecond,
                                    fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          const SizedBox(height: 16),

          // ── Déconnexion ───────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: () async {
                const storage = FlutterSecureStorage();
                await storage.deleteAll();
                if (context.mounted) {
                  context.router.replace(const LoginRoute());
                }
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.error,
                side: BorderSide(
                    color: AppTheme.error.withOpacity(0.3)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout_rounded, size: 18),
                  SizedBox(width: 8),
                  Text('Se déconnecter',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() =>
      Container(height: 1, color: AppTheme.border,
          margin: const EdgeInsets.symmetric(vertical: 10));

  Widget _buildRow(IconData icon, String label, String value) {
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
        Expanded(
          child: Column(
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
                      fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }
}