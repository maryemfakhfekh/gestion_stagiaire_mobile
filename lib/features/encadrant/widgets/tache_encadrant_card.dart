// lib/features/encadrant/widgets/tache_encadrant_card.dart

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../data/models/tache_encadrant_model.dart';

class TacheEncadrantCard extends StatelessWidget {
  final TacheEncadrantModel tache;
  final VoidCallback? onDelete;

  const TacheEncadrantCard({
    super.key,
    required this.tache,
    this.onDelete,
  });

  Color get _statutColor => switch (tache.statut) {
    StatutTacheEncadrant.termine => AppTheme.success,
    StatutTacheEncadrant.enCours => AppTheme.primary,
    StatutTacheEncadrant.aFaire  => AppTheme.textLight,
  };

  Color get _statutBg => switch (tache.statut) {
    StatutTacheEncadrant.termine => const Color(0xFFF0FDF4),
    StatutTacheEncadrant.enCours => AppTheme.primarySoft,
    StatutTacheEncadrant.aFaire  => AppTheme.background,
  };

  IconData get _statutIcon => switch (tache.statut) {
    StatutTacheEncadrant.termine => Icons.check_circle_rounded,
    StatutTacheEncadrant.enCours => Icons.radio_button_checked_rounded,
    StatutTacheEncadrant.aFaire  => Icons.circle_outlined,
  };

  Color get _prioriteColor => switch (tache.priorite) {
    PrioriteTacheEncadrant.basse    => const Color(0xFF166534),
    PrioriteTacheEncadrant.moyenne  => const Color(0xFFED6C02),
    PrioriteTacheEncadrant.haute    => const Color(0xFFD32F2F),
    PrioriteTacheEncadrant.critique => const Color(0xFF9C27B0),
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.shadowSM,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icône statut
              Icon(_statutIcon, color: _statutColor, size: 18),
              const SizedBox(width: 10),
              // Titre
              Expanded(
                child: Text(tache.titre,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                        decoration: tache.statut ==
                            StatutTacheEncadrant.termine
                            ? TextDecoration.lineThrough
                            : null),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(width: 8),
              // Badge statut
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _statutBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(tache.statut.uiLabel,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: _statutColor)),
              ),
              // Supprimer
              if (onDelete != null) ...[
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () => _confirmDelete(context),
                  child: Container(
                    width: 28, height: 28,
                    decoration: BoxDecoration(
                      color: AppTheme.error.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: const Icon(Icons.delete_outline_rounded,
                        color: AppTheme.error, size: 15),
                  ),
                ),
              ],
            ],
          ),

          if (tache.description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(tache.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecond,
                    height: 1.4)),
          ],

          const SizedBox(height: 10),
          Row(
            children: [
              // Priorité
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: _prioriteColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(tache.priorite.uiLabel,
                    style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: _prioriteColor)),
              ),
              const Spacer(),
              // Date
              if (tache.dateEcheance != null) ...[
                const Icon(Icons.calendar_today_outlined,
                    size: 11, color: AppTheme.textLight),
                const SizedBox(width: 4),
                Text(tache.dateEcheance!,
                    style: const TextStyle(
                        fontSize: 11, color: AppTheme.textLight)),
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Text('Supprimer la tâche',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w800)),
        content: Text(
          'Voulez-vous supprimer "${tache.titre}" ?',
          style: const TextStyle(
              fontSize: 13, color: AppTheme.textSecond),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler',
                style: TextStyle(color: AppTheme.textSecond)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete?.call();
            },
            child: const Text('Supprimer',
                style: TextStyle(
                    color: AppTheme.error,
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}