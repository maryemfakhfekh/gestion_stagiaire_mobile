// lib/features/stagiaire/widgets/dashboard/taches/tache_card.dart

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/tache_model.dart';

class TacheCard extends StatelessWidget {
  final TacheModel tache;
  final VoidCallback? onTap;
  final bool isDetailed;
  final void Function(TacheStatut)? onStatutChange;

  const TacheCard({
    super.key,
    required this.tache,
    this.onTap,
    this.isDetailed = true,
    this.onStatutChange,
  });

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

  (String, Color, Color) get _statutCfg => switch (tache.statut) {
    TacheStatut.aFaire   => ('TO DO',    const Color(0xFF6B7280), const Color(0xFFF3F4F6)),
    TacheStatut.enCours  => ('EN COURS', const Color(0xFF1D4ED8), const Color(0xFFEFF6FF)),
    TacheStatut.terminee => ('DONE',     const Color(0xFF166534), const Color(0xFFDCFCE7)),
  };

  bool get _isOverdue {
    if (tache.statut == TacheStatut.terminee) return false;
    final due = DateTime.tryParse(tache.dateEcheance);
    return due != null && due.isBefore(DateTime.now());
  }

  String get _dateLabel {
    final due = DateTime.tryParse(tache.dateEcheance);
    if (due == null) return tache.dateEcheance;
    final now = DateTime.now();
    if (due.year == now.year && due.month == now.month && due.day == now.day) {
      return "Aujourd'hui";
    }
    return '${due.day}/${due.month}';
  }

  @override
  Widget build(BuildContext context) =>
      isDetailed ? _buildDetailed(context) : _buildListRow(context);

  Widget _buildDetailed(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.border),
          boxShadow: AppTheme.shadowSM,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Checkbox
                GestureDetector(
                  onTap: () => onStatutChange?.call(
                    tache.statut == TacheStatut.terminee
                        ? TacheStatut.aFaire
                        : TacheStatut.terminee,
                  ),
                  child: Container(
                    width: 18, height: 18,
                    decoration: BoxDecoration(
                      color: tache.statut == TacheStatut.terminee
                          ? AppTheme.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: tache.statut == TacheStatut.terminee
                            ? AppTheme.primary : AppTheme.border,
                        width: 1.5,
                      ),
                    ),
                    child: tache.statut == TacheStatut.terminee
                        ? const Icon(Icons.check, size: 11, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
                Text(tache.issueKey,
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textLight)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                      color: _prioriteBg,
                      borderRadius: BorderRadius.circular(4)),
                  child: Text(_prioriteLabel,
                      style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: _prioriteColor)),
                ),
                const Spacer(),
                // Badge statut cliquable
                GestureDetector(
                  onTap: () => _showStatutMenu(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: _statutCfg.$3,
                        borderRadius: BorderRadius.circular(6)),
                    child: Text(_statutCfg.$1,
                        style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: _statutCfg.$2,
                            letterSpacing: 0.3)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(tache.titre,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppTheme.textPrimary,
                    decoration: tache.statut == TacheStatut.terminee
                        ? TextDecoration.lineThrough : null)),
            if (tache.description != null) ...[
              const SizedBox(height: 4),
              Text(tache.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 12, color: AppTheme.textSecond, height: 1.4)),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    size: 11,
                    color: _isOverdue ? AppTheme.error : AppTheme.textLight),
                const SizedBox(width: 4),
                Text(_dateLabel,
                    style: TextStyle(
                        fontSize: 11,
                        color: _isOverdue ? AppTheme.error : AppTheme.textLight,
                        fontWeight: _isOverdue
                            ? FontWeight.w600 : FontWeight.normal)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListRow(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => onStatutChange?.call(
                tache.statut == TacheStatut.terminee
                    ? TacheStatut.aFaire : TacheStatut.terminee,
              ),
              child: Container(
                width: 16, height: 16,
                decoration: BoxDecoration(
                  color: tache.statut == TacheStatut.terminee
                      ? AppTheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(
                    color: tache.statut == TacheStatut.terminee
                        ? AppTheme.primary : AppTheme.border,
                    width: 1.5,
                  ),
                ),
                child: tache.statut == TacheStatut.terminee
                    ? const Icon(Icons.check, size: 10, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 5,
              child: Text(tache.titre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textPrimary,
                      decoration: tache.statut == TacheStatut.terminee
                          ? TextDecoration.lineThrough : null)),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 48,
              child: Center(
                child: Icon(Icons.drag_handle_rounded,
                    size: 16, color: _prioriteColor),
              ),
            ),
            SizedBox(
              width: 88,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                    color: _statutCfg.$3,
                    borderRadius: BorderRadius.circular(4)),
                child: Text(_statutCfg.$1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: _statutCfg.$2,
                        letterSpacing: 0.3)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStatutMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Changer le statut',
                style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            Row(
              children: [
                _statBtn(context, TacheStatut.aFaire,  'À faire'),
                const SizedBox(width: 8),
                _statBtn(context, TacheStatut.enCours, 'En cours'),
                const SizedBox(width: 8),
                _statBtn(context, TacheStatut.terminee,'Terminée'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statBtn(BuildContext ctx, TacheStatut statut, String label) {
    final isActive = tache.statut == statut;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onStatutChange?.call(statut);
          Navigator.pop(ctx);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? AppTheme.primary : AppTheme.background,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: isActive ? AppTheme.primary : AppTheme.border),
          ),
          child: Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: isActive ? Colors.white : AppTheme.textSecond,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}