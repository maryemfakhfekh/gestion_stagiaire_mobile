// lib/features/stagiaire/pages/stagiaire_dashboard_page.dart

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../data/models/stagiaire_model.dart';
import '../widgets/dashboard/dashboard_header.dart';
import '../widgets/dashboard/tabs/home_tab.dart';
import '../widgets/dashboard/tabs/taches_tab.dart';
import '../widgets/dashboard/tabs/rapport_tab.dart';
import '../widgets/dashboard/tabs/profil_tab.dart';

class StaigaireDashboardPage extends StatefulWidget {
  final StagiaireModel dossier;
  const StaigaireDashboardPage({super.key, required this.dossier});

  @override
  State<StaigaireDashboardPage> createState() => _StaigaireDashboardPageState();
}

class _StaigaireDashboardPageState extends State<StaigaireDashboardPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      HomeTab(dossier: widget.dossier),
      const TachesTab(),
      const RapportTab(),
      ProfilTab(dossier: widget.dossier),
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          DashboardHeader(dossier: widget.dossier),
          Container(height: 1, color: AppTheme.border),
          Expanded(
            child: IndexedStack(index: _currentIndex, children: tabs),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.border)),
        boxShadow: AppTheme.shadowMD,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(0, Icons.home_outlined,      Icons.home_rounded,         'Accueil'),
              _navItem(1, Icons.checklist_outlined,  Icons.checklist_rounded,    'Tâches'),
              _navItem(2, Icons.description_outlined,Icons.description_rounded,  'Rapport'),
              _navItem(3, Icons.person_outline_rounded, Icons.person_rounded,    'Profil'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, IconData activeIcon, String label) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isActive ? activeIcon : icon,
                color: isActive ? AppTheme.primary : AppTheme.textLight, size: 22),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    color: isActive ? AppTheme.primary : AppTheme.textLight,
                    fontSize: 11,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}