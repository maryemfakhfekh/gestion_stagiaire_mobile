// lib/features/stagiaire/widgets/dashboard/tabs/home_tab.dart

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/stagiaire_model.dart';
import '../home/progress_card.dart';
import '../home/encadrant_card.dart';
import '../home/recent_tasks_card.dart';

class HomeTab extends StatelessWidget {
  final StagiaireModel dossier;
  const HomeTab({super.key, required this.dossier});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSujetCard(),
          const SizedBox(height: 24),
          const ProgressCard(),
          const SizedBox(height: 24),
          EncadrantCard(encadrant: dossier.encadrant),
          const SizedBox(height: 24),
          const RecentTasksCard(),
        ],
      ),
    );
  }

  Widget _buildSujetCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.shadowSM,
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.primarySoft,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6, height: 6,
                                  decoration: const BoxDecoration(
                                      color: AppTheme.primary, shape: BoxShape.circle),
                                ),
                                const SizedBox(width: 6),
                                const Text('STAGE EN COURS',
                                    style: TextStyle(
                                        color: AppTheme.primary, fontSize: 10,
                                        fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(dossier.sujet.titre.trim(),
                              style: const TextStyle(
                                  color: AppTheme.textPrimary, fontSize: 15,
                                  fontWeight: FontWeight.w800, letterSpacing: -0.3),
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined,
                                  size: 12, color: AppTheme.textSecond),
                              const SizedBox(width: 5),
                              Text('${dossier.dateDebut} → ${dossier.dateFin ?? '—'}',
                                  style: const TextStyle(
                                      color: AppTheme.textSecond, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: AppTheme.primarySoft,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.work_outline_rounded,
                          color: AppTheme.primary, size: 22),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}