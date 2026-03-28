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
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Titre ─────────────────────────────────────
          Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.primarySoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.description_rounded,
                    color: AppTheme.primary, size: 22),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Rapport de stage',
                      style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.4)),
                  Text('Déposez votre rapport final en PDF',
                      style: TextStyle(
                          color: AppTheme.textSecond, fontSize: 13)),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ── Statut ────────────────────────────────────
          RapportStatusCard(estDepose: _estDepose),

          const SizedBox(height: 20),

          if (!_estDepose) ...[
            // ── Upload ───────────────────────────────────
            const Text('Sélectionner votre rapport',
                style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            const Text('Format PDF uniquement · Max 10 MB',
                style: TextStyle(
                    color: AppTheme.textLight, fontSize: 12)),
            const SizedBox(height: 12),
            const RapportUploadZone(),
            const SizedBox(height: 20),

            // ── Bouton soumettre ──────────────────────────
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () => setState(() => _estDepose = true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.send_rounded, size: 18),
                    SizedBox(width: 10),
                    Text('Soumettre le rapport',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 20),

          // ── Note info ─────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primarySoft,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: AppTheme.primary.withOpacity(0.15)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.info_outline_rounded,
                      color: AppTheme.primary, size: 16),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Votre rapport sera consulté par votre encadrant et le service RH. Assurez-vous qu\'il est complet avant de le soumettre.',
                    style: TextStyle(
                        color: AppTheme.textSecond,
                        fontSize: 12,
                        height: 1.6),
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