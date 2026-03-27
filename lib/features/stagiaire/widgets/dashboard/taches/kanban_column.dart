import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/tache_model.dart';
import 'tache_card.dart';

class KanbanColumn extends StatelessWidget {
  final String title;
  final List<Tache> tasks;
  final TacheStatut statut;
  final Color? accentColor;
  final bool showAddButton;
  final VoidCallback? onAddTask;

  const KanbanColumn({
    super.key,
    required this.title,
    required this.tasks,
    required this.statut,
    this.accentColor,
    this.showAddButton = false,
    this.onAddTask,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header de colonne (style Jira)
          Padding(
            padding: const EdgeInsets.only(bottom: 12, left: 4),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: accentColor ?? AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppTheme.textPrimary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.border,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${tasks.length}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecond,
                    ),
                  ),
                ),
                const Spacer(),
                if (showAddButton)
                  IconButton(
                    icon: const Icon(Icons.add, size: 18),
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                    onPressed: onAddTask,
                    tooltip: 'Ajouter une tâche',
                  ),
              ],
            ),
          ),
          // Liste des cartes
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return TacheCard(
                  tache: tasks[index],
                  onTap: () => _showTaskDetails(context, tasks[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showTaskDetails(BuildContext context, Tache tache) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    tache.issueKey,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textLight,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getPrioriteColor(tache.priorite).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tache.priorite.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _getPrioriteColor(tache.priorite),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                tache.titre,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (tache.description != null) ...[
                const SizedBox(height: 12),
                Text(
                  tache.description!,
                  style: const TextStyle(color: AppTheme.textSecond),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 8),
                  Text('Échéance : ${_formatDate(tache.dateEcheance)}'),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Fermer'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getPrioriteColor(TachePriorite priorite) {
    switch (priorite) {
      case TachePriorite.basse:
        return const Color(0xFF2E7D32);
      case TachePriorite.moyenne:
        return const Color(0xFFED6C02);
      case TachePriorite.haute:
        return const Color(0xFFD32F2F);
      case TachePriorite.critique:
        return const Color(0xFF9C27B0);
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}