// lib/features/stagiaire/widgets/dashboard/dashboard_header.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/stagiaire_model.dart';

class DashboardHeader extends StatelessWidget {
  final StagiaireModel dossier;
  const DashboardHeader({super.key, required this.dossier});

  String get _initials {
    final parts = dossier.utilisateur.nomComplet.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return dossier.utilisateur.nomComplet.substring(0, 2).toUpperCase();
  }

  String get _prenom => dossier.utilisateur.nomComplet.trim().split(' ').first;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(24, top + 16, 24, 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bonjour, $_prenom 👋',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary, letterSpacing: -0.5)),
                const SizedBox(height: 3),
                const Text('Bienvenue sur votre espace',
                    style: TextStyle(fontSize: 13, color: AppTheme.textSecond)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Notif dot
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.border),
                ),
                child: const Icon(Icons.notifications_none_rounded,
                    color: AppTheme.textPrimary, size: 22),
              ),
              Positioned(
                top: 10, right: 10,
                child: Container(
                  width: 8, height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.primary, shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          // Avatar gradient
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF57C00), Color(0xFFFFB74D)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(_initials,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ),
    );
  }
}