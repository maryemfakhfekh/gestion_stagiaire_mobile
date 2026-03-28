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
  bool _isDetailed = true;

  @override
  void initState() {
    super.initState();
    _taches = List.from(fakeTaches);
  }

  void _addTask(Tache newTask) {
    setState(() => _taches.add(newTask));
  }

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

    groups.removeWhere((key, value) => value.isEmpty);
    return groups;
  }

  int get _terminees =>
      _taches.where((t) => t.statut == TacheStatut.terminee).length;
  int get _enCours =>
      _taches.where((t) => t.statut == TacheStatut.enCours).length;
  int get _aFaire =>
      _taches.where((t) => t.statut == TacheStatut.aFaire).length;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Container(height: 1, color: AppTheme.border),
        Expanded(
          child: _isDetailed ? _buildDetailedView() : _buildListView(),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Stats rapides
              _miniStat(_terminees.toString(), 'Terminées', AppTheme.success),
              const SizedBox(width: 8),
              _miniStat(_enCours.toString(), 'En cours', AppTheme.primary),
              const SizedBox(width: 8),
              _miniStat(_aFaire.toString(), 'À faire', AppTheme.textLight),
              const Spacer(),
              // Bouton ajouter
              GestureDetector(
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => AddTaskDialog(onTaskCreated: _addTask),
                ),
                child: Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(11),
                    boxShadow: AppTheme.shadowOrange,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 22),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Toggle
          Container(
            height: 38,
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _toggleBtn('Détaillé', _isDetailed,
                        () => setState(() => _isDetailed = true)),
                _toggleBtn('Liste', !_isDetailed,
                        () => setState(() => _isDetailed = false)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String val, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(val,
              style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w800)),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  color: color.withOpacity(0.7),
                  fontSize: 11,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _toggleBtn(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: active ? AppTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: active ? Colors.white : AppTheme.textLight)),
      ),
    );
  }

  Widget _buildDetailedView() {
    final groups = _groupByPeriod();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      itemCount: groups.length,
      itemBuilder: (context, i) {
        final groupTitle = groups.keys.elementAt(i);
        final taches = groups.values.elementAt(i);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 12, top: i == 0 ? 0 : 20),
              child: Row(
                children: [
                  Container(
                    width: 3, height: 14,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(groupTitle,
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textLight,
                          letterSpacing: 0.8)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Text('${taches.length}',
                        style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textSecond)),
                  ),
                ],
              ),
            ),
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

  Widget _buildListView() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          color: AppTheme.surface,
          child: Row(
            children: const [
              Expanded(
                flex: 5,
                child: Text('Work item',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textLight)),
              ),
              SizedBox(width: 8),
              Text('Key',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textLight)),
              SizedBox(width: 24),
              Text('Priorité',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textLight)),
              SizedBox(width: 16),
              Text('Statut',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textLight)),
              SizedBox(width: 16),
            ],
          ),
        ),
        Container(height: 1, color: AppTheme.border),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 40),
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

  void _showTaskDetails(BuildContext context, Tache tache) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 36, height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Text(tache.issueKey,
                      style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.textLight,
                          fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 8),
                _StatutBadge(statut: tache.statut),
                const Spacer(),
                _PrioriteBadge(priorite: tache.priorite),
              ],
            ),
            const SizedBox(height: 14),
            Text(tache.titre,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                    letterSpacing: -0.3)),
            if (tache.description != null) ...[
              const SizedBox(height: 10),
              Text(tache.description!,
                  style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecond,
                      height: 1.6)),
            ],
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined,
                      size: 15, color: AppTheme.textLight),
                  const SizedBox(width: 8),
                  Text(
                    'Échéance : ${tache.dateEcheance.day}/${tache.dateEcheance.month}/${tache.dateEcheance.year}',
                    style: const TextStyle(
                        fontSize: 13, color: AppTheme.textSecond),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatutBadge extends StatelessWidget {
  final TacheStatut statut;
  const _StatutBadge({required this.statut});

  @override
  Widget build(BuildContext context) {
    final config = switch (statut) {
      TacheStatut.aFaire => ('TO DO', const Color(0xFF6B7280), const Color(0xFFF3F4F6)),
      TacheStatut.enCours => ('EN COURS', const Color(0xFFF57C00), const Color(0xFFFFF4ED)),
      TacheStatut.terminee => ('DONE', const Color(0xFF16A34A), const Color(0xFFF0FDF4)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: config.$3,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(config.$1,
          style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: config.$2,
              letterSpacing: 0.3)),
    );
  }
}

class _PrioriteBadge extends StatelessWidget {
  final TachePriorite priorite;
  const _PrioriteBadge({required this.priorite});

  @override
  Widget build(BuildContext context) {
    final config = switch (priorite) {
      TachePriorite.basse => ('BASSE', const Color(0xFF16A34A), const Color(0xFFF0FDF4)),
      TachePriorite.moyenne => ('MOYENNE', const Color(0xFFF57C00), const Color(0xFFFFF4ED)),
      TachePriorite.haute => ('HAUTE', const Color(0xFFDC2626), const Color(0xFFFEF2F2)),
      TachePriorite.critique => ('CRITIQUE', const Color(0xFF7C3AED), const Color(0xFFF5F3FF)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: config.$3,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(config.$1,
          style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: config.$2)),
    );
  }
}