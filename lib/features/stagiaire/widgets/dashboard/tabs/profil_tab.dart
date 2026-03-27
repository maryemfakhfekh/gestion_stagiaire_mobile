import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../profil/profil_info_card.dart';
import '../profil/profil_encadrant_card.dart';

class ProfilTab extends StatelessWidget {
  const ProfilTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Titre ─────────────────────────────────────
          const Text(
            'Mon Profil',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Informations de votre stage',
            style: TextStyle(
              color: AppTheme.textSecond,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 20),

          // ── Infos personnelles ────────────────────────
          const ProfilInfoCard(),

          const SizedBox(height: 16),

          // ── Encadrant ─────────────────────────────────
          const ProfilEncadrantCard(),

          const SizedBox(height: 16),

          // ── Bouton déconnexion ────────────────────────
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.error,
                side: BorderSide(
                  color: AppTheme.error.withOpacity(0.4),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout_rounded, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Se déconnecter',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}