// lib/features/stagiaire/widgets/pending/pending_status_card.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class PendingStatusCard extends StatefulWidget {
  const PendingStatusCard({super.key});

  @override
  State<PendingStatusCard> createState() => _PendingStatusCardState();
}

class _PendingStatusCardState extends State<PendingStatusCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1600))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.88, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.shadowSM,
      ),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _anim,
            builder: (_, child) =>
                Transform.scale(scale: _anim.value, child: child),
            child: Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFF4ED), Color(0xFFFFE0C4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppTheme.warning.withOpacity(0.25), width: 2),
              ),
              child: const Icon(Icons.hourglass_top_rounded,
                  color: AppTheme.warning, size: 36),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Candidature en cours d\'examen',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4)),
          const SizedBox(height: 8),
          const Text(
            'Votre dossier a bien été reçu.\nLe service RH l\'examine actuellement.',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: AppTheme.textSecond, fontSize: 13, height: 1.6),
          ),
          const SizedBox(height: 24),
          Container(height: 1, color: AppTheme.border),
          const SizedBox(height: 20),
          _step(Icons.check_circle_rounded, AppTheme.success,
              'Candidature déposée', done: true),
          const SizedBox(height: 14),
          _step(Icons.radio_button_checked_rounded, AppTheme.warning,
              'Examen par le service RH', active: true),
          const SizedBox(height: 14),
          _step(Icons.radio_button_unchecked_rounded, AppTheme.textLight,
              'Décision finale'),
        ],
      ),
    );
  }

  Widget _step(IconData icon, Color color, String label,
      {bool done = false, bool active = false}) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label,
              style: TextStyle(
                  color: done
                      ? AppTheme.textPrimary
                      : active
                      ? AppTheme.warning
                      : AppTheme.textLight,
                  fontSize: 13,
                  fontWeight:
                  done || active ? FontWeight.w600 : FontWeight.w400)),
        ),
        if (active)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4ED),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.warning.withOpacity(0.2)),
            ),
            child: const Text('En cours',
                style: TextStyle(
                    color: AppTheme.warning,
                    fontSize: 10,
                    fontWeight: FontWeight.w700)),
          ),
      ],
    );
  }
}