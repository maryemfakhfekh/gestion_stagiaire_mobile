import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/dashboard/dashboard_header.dart';
import '../widgets/dashboard/tabs/home_tab.dart';
import '../widgets/dashboard/tabs/taches_tab.dart';
import '../widgets/dashboard/tabs/rapport_tab.dart';
import '../widgets/dashboard/tabs/profil_tab.dart';

class StaigaireDashboardPage extends StatefulWidget {
  const StaigaireDashboardPage({super.key});

  @override
  State<StaigaireDashboardPage> createState() =>
      _StaigaireDashboardPageState();
}

class _StaigaireDashboardPageState extends State<StaigaireDashboardPage> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    HomeTab(),
    TachesTab(),
    RapportTab(),
    ProfilTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      // ── Body complet ──────────────────────────────────
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          // ── Header (inclut safe area) ─────────────────
          const DashboardHeader(),

          // ── Divider ───────────────────────────────────
          Container(height: 1, color: AppTheme.border),

          // ── Contenu tab actif ─────────────────────────
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: _tabs,
            ),
          ),
        ],
      ),

      // ── Bottom Navigation Bar ─────────────────────────
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          border: Border(
            top: BorderSide(color: AppTheme.border),
          ),
          boxShadow: AppTheme.shadowMD,
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: 'Accueil',
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.checklist_outlined,
                  activeIcon: Icons.checklist_rounded,
                  label: 'Tâches',
                ),
                _buildNavItem(
                  index: 2,
                  icon: Icons.description_outlined,
                  activeIcon: Icons.description_rounded,
                  label: 'Rapport',
                ),
                _buildNavItem(
                  index: 3,
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: 'Profil',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primarySoft : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusSM),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppTheme.primary : AppTheme.textLight,
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppTheme.primary : AppTheme.textLight,
                fontSize: 11,
                fontWeight:
                isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}