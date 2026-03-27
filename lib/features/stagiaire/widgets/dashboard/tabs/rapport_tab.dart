import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../rapport/rapport_status_card.dart';
import '../rapport/rapport_upload_zone.dart';

class RapportTab extends StatefulWidget {
  const RapportTab({super.key});

  @override
  State<RapportTab> createState() => _RapportTabState();
}

class _RapportTabState extends State<RapportTab> {
  bool _estDepose = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Titre ─────────────────────────────────────
          const Text(
            'Rapport de stage',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Déposez votre rapport final en PDF',
            style: TextStyle(
              color: AppTheme.textSecond,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 20),

          // ── Statut ────────────────────────────────────
          RapportStatusCard(estDepose: _estDepose),

          const SizedBox(height: 16),

          // ── Zone upload ───────────────────────────────
          if (!_estDepose) ...[
            const Text(
              'Sélectionner votre rapport',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Format PDF uniquement · Max 10 MB',
              style: TextStyle(
                color: AppTheme.textLight,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),
            const RapportUploadZone(),
            const SizedBox(height: 20),

            // ── Bouton soumettre ──────────────────────
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => setState(() => _estDepose = true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.send_rounded, size: 18),
                    SizedBox(width: 10),
                    Text(
                      'Soumettre le rapport',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          // ── Note info ─────────────────────────────────
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.primarySoft,
              borderRadius: BorderRadius.circular(AppTheme.radiusSM),
              border: Border.all(
                color: AppTheme.primary.withOpacity(0.15),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusXS),
                  ),
                  child: const Icon(
                    Icons.info_outline_rounded,
                    color: AppTheme.primary,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Votre rapport sera consulté par votre encadrant et le service RH. Assurez-vous qu\'il est complet avant de le soumettre.',
                    style: TextStyle(
                      color: AppTheme.textSecond,
                      fontSize: 12,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}