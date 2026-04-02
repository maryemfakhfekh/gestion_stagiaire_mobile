// lib/features/encadrant/pages/encadrant_home_page.dart

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection.dart';
import '../../../core/theme/app_theme.dart';
import '../logic/encadrant_bloc.dart';
import 'mes_stagiaires_page.dart';
import 'encadrant_profile_page.dart';

@RoutePage()
class EncadrantHomePage extends StatefulWidget {
  const EncadrantHomePage({super.key});

  @override
  State<EncadrantHomePage> createState() => _EncadrantHomePageState();
}

class _EncadrantHomePageState extends State<EncadrantHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<EncadrantBloc>()..add(LoadStagiaires()),
      child: _EncadrantHomeView(
        currentIndex: _currentIndex,
        onTabChanged: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

class _EncadrantHomeView extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTabChanged;

  const _EncadrantHomeView({
    required this.currentIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final pages = const [
      MesStagiairesPage(),
      EncadrantProfilePage(),
    ];

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppTheme.border)),
          boxShadow: AppTheme.shadowMD,
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(context, 0, Icons.people_outline_rounded,
                    Icons.people_rounded, 'Stagiaires'),
                _navItem(context, 1, Icons.person_outline_rounded,
                    Icons.person_rounded, 'Profil'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(BuildContext ctx, int index, IconData icon,
      IconData activeIcon, String label) {
    final isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => onTabChanged(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppTheme.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isActive ? activeIcon : icon,
                color: isActive ? AppTheme.primary : AppTheme.textLight,
                size: 22),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    color:
                    isActive ? AppTheme.primary : AppTheme.textLight,
                    fontSize: 11,
                    fontWeight: isActive
                        ? FontWeight.w700
                        : FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}