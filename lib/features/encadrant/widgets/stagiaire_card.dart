// lib/features/encadrant/widgets/stagiaire_card.dart

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../data/models/stagiaire_encadrant_model.dart';

class StagiaireCard extends StatelessWidget {
  final StagiaireEncadrantModel stagiaire;
  final int tachesCount;
  final VoidCallback onTap;

  const StagiaireCard({
    super.key,
    required this.stagiaire,
    required this.tachesCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final s = stagiaire;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [

              // ── Barre colorée gauche ──────────────────────
              Container(
                width: 5,
                decoration: BoxDecoration(
                  color: s.estEnCours
                      ? const Color(0xFFF57C00)
                      : const Color(0xFFCBD5E1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
              ),

              // ── Contenu ───────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Ligne 1 : avatar + nom + badge
                      Row(
                        children: [
                          // Avatar
                          Container(
                            width: 46, height: 46,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: Text(s.initiale,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(s.nomComplet,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF111827),
                                        letterSpacing: -0.3)),
                                const SizedBox(height: 2),
                                Text(s.email,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF9CA3AF))),
                              ],
                            ),
                          ),
                          // Badge statut
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: s.estEnCours
                                  ? const Color(0xFFECFDF5)
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
                                        ? const Color(0xFF10B981)
                                        : const Color(0xFF9CA3AF),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(s.estEnCours ? 'Actif' : 'Terminé',
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: s.estEnCours
                                            ? const Color(0xFF059669)
                                            : const Color(0xFF9CA3AF))),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),
                      Container(height: 1, color: const Color(0xFFF3F4F6)),
                      const SizedBox(height: 12),

                      // Sujet
                      Row(
                        children: [
                          Container(
                            width: 28, height: 28,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF4ED),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.work_outline_rounded,
                                size: 14, color: Color(0xFFF57C00)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(s.sujetTitre,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF374151))),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Footer : filière + tâches + flèche
                      Row(
                        children: [
                          // Filière
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 9, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Text(
                              '${s.filiere} · ${s.cycle}',
                              style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6B7280)),
                            ),
                          ),
                          const Spacer(),
                          // Tâches badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 9, vertical: 4),
                            decoration: BoxDecoration(
                              color: tachesCount > 0
                                  ? const Color(0xFFFFF4ED)
                                  : const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.checklist_rounded,
                                    size: 12,
                                    color: tachesCount > 0
                                        ? const Color(0xFFF57C00)
                                        : const Color(0xFF9CA3AF)),
                                const SizedBox(width: 4),
                                Text(
                                  '$tachesCount tâche${tachesCount > 1 ? 's' : ''}',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: tachesCount > 0
                                          ? const Color(0xFFF57C00)
                                          : const Color(0xFF9CA3AF)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 28, height: 28,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.arrow_forward_rounded,
                                size: 14, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}