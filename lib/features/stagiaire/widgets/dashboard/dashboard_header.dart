import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      color: AppTheme.surface,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, topPadding + 12, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          // ── Ligne 1 : Avatar + Nom + Notif ───────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // Avatar circulaire style Jira
              Container(
                width: 36, height: 36,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primary, Color(0xFFFF9800)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'AS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // Nom + projet
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'Ahmed Stagiaire',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    Text(
                      'Gestion de Stages · GS board',
                      style: TextStyle(
                        color: AppTheme.textLight,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Bouton notif
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: AppTheme.textSecond,
                      size: 18,
                    ),
                  ),
                  Positioned(
                    top: 6, right: 6,
                    child: Container(
                      width: 8, height: 8,
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 8),

              // Bouton +
              Container(
                width: 36, height: 36,
                decoration: const BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ── Ligne 2 : Search bar ──────────────────────
          Container(
            height: 42,
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              children: const [
                SizedBox(width: 12),
                Icon(
                  Icons.search_rounded,
                  color: AppTheme.textLight,
                  size: 18,
                ),
                SizedBox(width: 8),
                Text(
                  'Rechercher tâches, projets...',
                  style: TextStyle(
                    color: AppTheme.textLight,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}