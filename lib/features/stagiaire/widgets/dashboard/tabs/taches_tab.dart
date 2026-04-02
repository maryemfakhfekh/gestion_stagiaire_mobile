// lib/features/stagiaire/widgets/dashboard/tabs/taches_tab.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/tache_model.dart';
import '../../../logic/tache_bloc.dart';
import '../taches/tache_card.dart';

class TachesTab extends StatelessWidget {
  const TachesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TacheBloc>()..add(LoadTaches()),
      child: const _TachesView(),
    );
  }
}

class _TachesView extends StatefulWidget {
  const _TachesView();
  @override
  State<_TachesView> createState() => _TachesViewState();
}

class _TachesViewState extends State<_TachesView> {
  bool _isDetailed = true;

  int _count(List<TacheModel> t, TacheStatut s) =>
      t.where((x) => x.statut == s).length;

  Map<String, List<TacheModel>> _groupByPeriod(List<TacheModel> taches) {
    final now = DateTime.now();
    final groups = <String, List<TacheModel>>{
      'CETTE SEMAINE': [],
      'CE MOIS':       [],
      'PLUS TARD':     [],
    };
    for (final t in taches) {
      final due = DateTime.tryParse(t.dateEcheance);
      if (due == null) { groups['PLUS TARD']!.add(t); continue; }
      final diff = due.difference(now).inDays;
      if (diff <= 7)       groups['CETTE SEMAINE']!.add(t);
      else if (diff <= 30) groups['CE MOIS']!.add(t);
      else                 groups['PLUS TARD']!.add(t);
    }
    groups.removeWhere((_, v) => v.isEmpty);
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TacheBloc, TacheState>(
      builder: (context, state) {
        if (state is TacheLoading || state is TacheInitial) {
          return const Center(
              child: CircularProgressIndicator(color: AppTheme.primary));
        }
        if (state is TacheError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wifi_off_rounded,
                    color: AppTheme.textLight, size: 40),
                const SizedBox(height: 12),
                const Text('Impossible de charger les tâches',
                    style: TextStyle(color: AppTheme.textSecond)),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () =>
                      context.read<TacheBloc>().add(LoadTaches()),
                  child: const Text('Réessayer',
                      style: TextStyle(color: AppTheme.primary)),
                ),
              ],
            ),
          );
        }

        final taches = state is TacheLoaded ? state.taches : <TacheModel>[];
        final terminees = _count(taches, TacheStatut.terminee);
        final enCours   = _count(taches, TacheStatut.enCours);
        final aFaire    = _count(taches, TacheStatut.aFaire);

        return Column(
          children: [
            _buildHeader(context, terminees, enCours, aFaire),
            Container(height: 1, color: AppTheme.border),
            Expanded(
              child: _isDetailed
                  ? _buildDetailed(context, taches)
                  : _buildList(context, taches),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(
      BuildContext ctx, int terminees, int enCours, int aFaire) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _miniStat(terminees.toString(), 'Terminées', AppTheme.success),
              const SizedBox(width: 8),
              _miniStat(enCours.toString(),   'En cours',  AppTheme.primary),
              const SizedBox(width: 8),
              _miniStat(aFaire.toString(),    'À faire',   AppTheme.textLight),
              const Spacer(),
              GestureDetector(
                onTap: () => ctx.read<TacheBloc>().add(LoadTaches()),
                child: Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: const Icon(Icons.refresh_rounded,
                      color: AppTheme.textSecond, size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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
                  color: color, fontSize: 13, fontWeight: FontWeight.w800)),
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

  Widget _buildDetailed(BuildContext ctx, List<TacheModel> taches) {
    if (taches.isEmpty) return _buildEmpty();
    final groups = _groupByPeriod(taches);
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      itemCount: groups.length,
      itemBuilder: (context, i) {
        final title = groups.keys.elementAt(i);
        final list  = groups.values.elementAt(i);
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
                        borderRadius: BorderRadius.circular(2)),
                  ),
                  const SizedBox(width: 8),
                  Text(title,
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
                    child: Text('${list.length}',
                        style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textSecond)),
                  ),
                ],
              ),
            ),
            ...list.map((t) => TacheCard(
              tache: t,
              isDetailed: true,
              onTap: () => _showDetails(ctx, t),
              onStatutChange: (s) =>
                  ctx.read<TacheBloc>().add(UpdateStatutTache(t.id, s)),
            )),
          ],
        );
      },
    );
  }

  Widget _buildList(BuildContext ctx, List<TacheModel> taches) {
    if (taches.isEmpty) return _buildEmpty();
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          color: Colors.white,
          child: const Row(
            children: [
              Expanded(flex: 5,
                  child: Text('Tâche',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textLight))),
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
            itemCount: taches.length,
            separatorBuilder: (_, __) =>
                Container(height: 1, color: AppTheme.border),
            itemBuilder: (context, i) => TacheCard(
              tache: taches[i],
              isDetailed: false,
              onTap: () => _showDetails(ctx, taches[i]),
              onStatutChange: (s) =>
                  ctx.read<TacheBloc>().add(UpdateStatutTache(taches[i].id, s)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.border),
            ),
            child: const Icon(Icons.checklist_rounded,
                color: AppTheme.textLight, size: 28),
          ),
          const SizedBox(height: 16),
          const Text('Aucune tâche assignée',
              style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          const Text('Votre encadrant n\'a pas encore créé de tâches',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textLight, fontSize: 13)),
        ],
      ),
    );
  }

  void _showDetails(BuildContext ctx, TacheModel tache) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (bsCtx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36, height: 4,
                decoration: BoxDecoration(
                    color: AppTheme.border,
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 20),
            Text(tache.titre,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary)),
            if (tache.description != null) ...[
              const SizedBox(height: 8),
              Text(tache.description!,
                  style: const TextStyle(
                      fontSize: 13, color: AppTheme.textSecond, height: 1.6)),
            ],
            const SizedBox(height: 16),
            if (tache.dateEcheance.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(children: [
                  const Icon(Icons.calendar_today_outlined,
                      size: 14, color: AppTheme.textLight),
                  const SizedBox(width: 8),
                  Text('Échéance : ${tache.dateEcheance}',
                      style: const TextStyle(
                          fontSize: 13, color: AppTheme.textSecond)),
                ]),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                _actionBtn(ctx, bsCtx, tache, TacheStatut.aFaire,  'À faire'),
                const SizedBox(width: 8),
                _actionBtn(ctx, bsCtx, tache, TacheStatut.enCours, 'En cours'),
                const SizedBox(width: 8),
                _actionBtn(ctx, bsCtx, tache, TacheStatut.terminee,'Terminée'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionBtn(BuildContext ctx, BuildContext bsCtx,
      TacheModel tache, TacheStatut statut, String label) {
    final isActive = tache.statut == statut;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          ctx.read<TacheBloc>().add(UpdateStatutTache(tache.id, statut));
          Navigator.pop(bsCtx);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
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