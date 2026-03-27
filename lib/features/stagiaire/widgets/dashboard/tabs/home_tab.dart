import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../home/progress_card.dart';
import '../home/encadrant_card.dart';
import '../home/recent_tasks_card.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Salutation style Jira ─────────────────────
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Bonjour, Ahmed 👋',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Gestion de Stages · Sprint 1',
                      style: TextStyle(
                        color: AppTheme.textSecond,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Badge sprint style Jira
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                  border: Border.all(
                    color: const Color(0xFF3B82F6).withOpacity(0.3),
                  ),
                ),
                child: const Text(
                  'ACTIF',
                  style: TextStyle(
                    color: Color(0xFF3B82F6),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ── Stats + Progression ───────────────────────
          const ProgressCard(progress: 0.6),

          const SizedBox(height: 20),

          // ── Encadrant ─────────────────────────────────
          const EncadrantCard(),

          const SizedBox(height: 20),

          // ── Activité récente + Quick access ───────────
          const RecentTasksCard(),
        ],
      ),
    );
  }
}