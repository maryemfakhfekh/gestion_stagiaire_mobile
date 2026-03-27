import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/tache_model.dart';

class TacheCard extends StatelessWidget {
  final Tache tache;
  final VoidCallback? onTap;
  final bool isDetailed; // true = carte, false = ligne liste

  const TacheCard({
    super.key,
    required this.tache,
    this.onTap,
    this.isDetailed = true,
  });

  // ── Couleurs ──────────────────────────────────────────────
  Color get _prioriteColor => switch (tache.priorite) {
    TachePriorite.basse    => const Color(0xFF166534),
    TachePriorite.moyenne  => const Color(0xFFED6C02),
    TachePriorite.haute    => const Color(0xFFD32F2F),
    TachePriorite.critique => const Color(0xFF9C27B0),
  };

  Color get _prioriteBg => switch (tache.priorite) {
    TachePriorite.basse    => const Color(0xFFDCFCE7),
    TachePriorite.moyenne  => const Color(0xFFFFF3E0),
    TachePriorite.haute    => const Color(0xFFFFEBEE),
    TachePriorite.critique => const Color(0xFFF3E5F5),
  };

  String get _prioriteLabel => switch (tache.priorite) {
    TachePriorite.basse    => 'BASSE',
    TachePriorite.moyenne  => 'MOYENNE',
    TachePriorite.haute    => 'HAUTE',
    TachePriorite.critique => 'CRITIQUE',
  };

  (String, Color, Color) get _statutConfig => switch (tache.statut) {
    TacheStatut.aFaire   => ('TO DO',    const Color(0xFF6B7280), const Color(0xFFF3F4F6)),
    TacheStatut.enCours  => ('EN COURS', const Color(0xFF1D4ED8), const Color(0xFFEFF6FF)),
    TacheStatut.terminee => ('DONE',     const Color(0xFF166534), const Color(0xFFDCFCE7)),
  };

  bool get _isOverdue =>
      tache.statut != TacheStatut.terminee &&
          tache.dateEcheance.isBefore(DateTime.now());

  String get _dateLabel {
    final d = tache.dateEcheance;
    final now = DateTime.now();
    if (d.year == now.year && d.month == now.month && d.day == now.day) {
      return "Aujourd'hui";
    }
    return '${d.day}/${d.month}';
  }

  @override
  Widget build(BuildContext context) {
    return isDetailed ? _buildDetailed() : _buildListRow();
  }

  // ── Mode DÉTAILLÉ (carte pleine) ──────────────────────────
  Widget _buildDetailed() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Ligne 1 : clé + priorité + avatar ────────
            Row(
              children: [
                // Checkbox style Jira
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: tache.statut == TacheStatut.terminee
                        ? AppTheme.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(
                      color: tache.statut == TacheStatut.terminee
                          ? AppTheme.primary
                          : AppTheme.border,
                      width: 1.5,
                    ),
                  ),
                  child: tache.statut == TacheStatut.terminee
                      ? const Icon(Icons.check, size: 10, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 8),

                // Clé
                Text(
                  tache.issueKey,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textLight,
                    decoration: tache.statut == TacheStatut.terminee
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                const SizedBox(width: 8),

                // Badge priorité
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: _prioriteBg,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _prioriteLabel,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: _prioriteColor,
                    ),
                  ),
                ),

                const Spacer(),

                // Avatar assigné
                if (tache.assigneeName != null)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        tache.assigneeName![0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 10),

            // ── Titre ─────────────────────────────────────
            Text(
              tache.titre,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppTheme.textPrimary,
                decoration: tache.statut == TacheStatut.terminee
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),

            // ── Description ───────────────────────────────
            if (tache.description != null) ...[
              const SizedBox(height: 4),
              Text(
                tache.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecond,
                  height: 1.4,
                ),
              ),
            ],

            const SizedBox(height: 10),

            // ── Pied : badge statut + date ─────────────────
            Row(
              children: [
                // Badge statut
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _statutConfig.$3,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _statutConfig.$1,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: _statutConfig.$2,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Date
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 11,
                      color: _isOverdue
                          ? AppTheme.error
                          : AppTheme.textLight,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _dateLabel,
                      style: TextStyle(
                        fontSize: 11,
                        color: _isOverdue
                            ? AppTheme.error
                            : AppTheme.textLight,
                        fontWeight: _isOverdue
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Commentaires
                const Icon(Icons.chat_bubble_outline,
                    size: 12, color: AppTheme.textLight),
                const SizedBox(width: 3),
                const Text(
                  '2',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.textLight,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Mode LISTE (ligne compacte style tableau) ─────────────
  Widget _buildListRow() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [

            // Checkbox + titre
            Expanded(
              flex: 5,
              child: Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: tache.statut == TacheStatut.terminee
                          ? AppTheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(
                        color: tache.statut == TacheStatut.terminee
                            ? AppTheme.primary
                            : AppTheme.border,
                        width: 1.5,
                      ),
                    ),
                    child: tache.statut == TacheStatut.terminee
                        ? const Icon(Icons.check,
                        size: 10, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      tache.titre,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textPrimary,
                        decoration: tache.statut == TacheStatut.terminee
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Clé
            SizedBox(
              width: 44,
              child: Text(
                tache.issueKey,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.textLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Priorité (icône =)
            SizedBox(
              width: 48,
              child: Center(
                child: Icon(
                  Icons.drag_handle_rounded,
                  size: 16,
                  color: _prioriteColor,
                ),
              ),
            ),

            // Statut badge
            SizedBox(
              width: 88,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: _statutConfig.$3,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _statutConfig.$1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: _statutConfig.$2,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}