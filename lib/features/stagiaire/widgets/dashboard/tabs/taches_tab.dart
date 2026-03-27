import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/tache_model.dart';
import '../taches/tache_card.dart';
import '../taches/add_task_dialog.dart';

class TachesTab extends StatefulWidget {
  const TachesTab({super.key});

  @override
  State<TachesTab> createState() => _TachesTabState();
}

class _TachesTabState extends State<TachesTab> {
  late List<Tache> _taches;
  bool _isDetailed = true; // toggle Detailed / List

  @override
  void initState() {
    super.initState();
    _taches = List.from(fakeTaches);
  }

  void _addTask(Tache newTask) {
    setState(() => _taches.add(newTask));
  }

  // ── Groupes par période ──────────────────────────────────
  Map<String, List<Tache>> _groupByPeriod() {
    final now = DateTime.now();
    final thisWeek = now.add(const Duration(days: 7));
    final thisMonth = DateTime(now.year, now.month + 1, 0);

    final groups = <String, List<Tache>>{
      'CETTE SEMAINE': [],
      'CE MOIS': [],
      'PLUS TARD': [],
    };

    for (final t in _taches) {
      if (t.dateEcheance.isBefore(thisWeek)) {
        groups['CETTE SEMAINE']!.add(t);
      } else if (t.dateEcheance.isBefore(thisMonth)) {
        groups['CE MOIS']!.add(t);
      } else {
        groups['PLUS TARD']!.add(t);
      }
    }

    // Supprime les groupes vides
    groups.removeWhere((key, value) => value.isEmpty);
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        // ── Header avec toggle + bouton ajouter ───────────
        _buildHeader(),
        Container(height: 1, color: AppTheme.border),

        // ── Liste ─────────────────────────────────────────
        Expanded(
          child: _isDetailed ? _buildDetailedView() : _buildListView(),
        ),
      ],
    );
  }

  // ── Header ────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [

          // Toggle Detailed / List
          Container(
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(AppTheme.radiusSM),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _toggleBtn('Détaillé', _isDetailed, () {
                  setState(() => _isDetailed = true);
                }),
                _toggleBtn('Liste', !_isDetailed, () {
                  setState(() => _isDetailed = false);
                }),
              ],
            ),
          ),

          const Spacer(),

          // Bouton ajouter
          GestureDetector(
            onTap: () => showDialog(
              context: context,
              builder: (_) => AddTaskDialog(onTaskCreated: _addTask),
            ),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(AppTheme.radiusSM),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleBtn(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: active ? AppTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusSM - 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : AppTheme.textLight,
          ),
        ),
      ),
    );
  }

  // ── Vue DÉTAILLÉE (cartes avec description) ───────────────
  Widget _buildDetailedView() {
    final groups = _groupByPeriod();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      itemCount: groups.length,
      itemBuilder: (context, i) {
        final groupTitle = groups.keys.elementAt(i);
        final taches = groups.values.elementAt(i);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Titre groupe ─────────────────────────────
            Padding(
              padding: EdgeInsets.only(bottom: 12, top: i == 0 ? 0 : 16),
              child: Text(
                groupTitle,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textLight,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            // ── Cartes ───────────────────────────────────
            ...taches.map((t) => TacheCard(
              tache: t,
              isDetailed: true,
              onTap: () => _showTaskDetails(context, t),
            )),
          ],
        );
      },
    );
  }

  // ── Vue LISTE (compact, style tableau Jira) ───────────────
  Widget _buildListView() {
    return Column(
      children: [
        // En-tête tableau
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: AppTheme.surface,
          child: Row(
            children: const [
              Expanded(
                flex: 5,
                child: Text(
                  'Work item',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textLight,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Key',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textLight,
                ),
              ),
              SizedBox(width: 24),
              Text(
                'Priorité',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textLight,
                ),
              ),
              SizedBox(width: 16),
              Text(
                'Statut',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textLight,
                ),
              ),
              SizedBox(width: 16),
            ],
          ),
        ),
        Container(height: 1, color: AppTheme.border),

        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 32),
            itemCount: _taches.length,
            separatorBuilder: (_, __) =>
                Container(height: 1, color: AppTheme.border),
            itemBuilder: (context, i) => TacheCard(
              tache: _taches[i],
              isDetailed: false,
              onTap: () => _showTaskDetails(context, _taches[i]),
            ),
          ),
        ),
      ],
    );
  }

  // ── Bottom sheet détail tâche ─────────────────────────────
  void _showTaskDetails(BuildContext context, Tache tache) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Center(
              child: Container(
                width: 36, height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  tache.issueKey,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                _StatutBadge(statut: tache.statut),
                const Spacer(),
                _PrioriteBadge(priorite: tache.priorite),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              tache.titre,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            if (tache.description != null) ...[
              const SizedBox(height: 8),
              Text(
                tache.description!,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecond,
                  height: 1.5,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined,
                    size: 14, color: AppTheme.textLight),
                const SizedBox(width: 6),
                Text(
                  'Échéance : ${tache.dateEcheance.day}/${tache.dateEcheance.month}/${tache.dateEcheance.year}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecond,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Badge statut ──────────────────────────────────────────────
class _StatutBadge extends StatelessWidget {
  final TacheStatut statut;
  const _StatutBadge({required this.statut});

  @override
  Widget build(BuildContext context) {
    final config = switch (statut) {
      TacheStatut.aFaire   => ('TO DO',      const Color(0xFF6B7280), const Color(0xFFF3F4F6)),
      TacheStatut.enCours  => ('EN COURS',   const Color(0xFF1D4ED8), const Color(0xFFEFF6FF)),
      TacheStatut.terminee => ('DONE',       const Color(0xFF166534), const Color(0xFFDCFCE7)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: config.$3,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        config.$1,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: config.$2,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

// ── Badge priorité ────────────────────────────────────────────
class _PrioriteBadge extends StatelessWidget {
  final TachePriorite priorite;
  const _PrioriteBadge({required this.priorite});

  @override
  Widget build(BuildContext context) {
    final config = switch (priorite) {
      TachePriorite.basse    => ('BASSE',    const Color(0xFF166534), const Color(0xFFDCFCE7)),
      TachePriorite.moyenne  => ('MOYENNE',  const Color(0xFFED6C02), const Color(0xFFFFF3E0)),
      TachePriorite.haute    => ('HAUTE',    const Color(0xFFD32F2F), const Color(0xFFFFEBEE)),
      TachePriorite.critique => ('CRITIQUE', const Color(0xFF9C27B0), const Color(0xFFF3E5F5)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: config.$3,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        config.$1,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: config.$2,
        ),
      ),
    );
  }
}