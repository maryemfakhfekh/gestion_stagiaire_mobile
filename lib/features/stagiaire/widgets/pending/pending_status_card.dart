import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class PendingStatusCard extends StatefulWidget {
  const PendingStatusCard({super.key});

  @override
  State<PendingStatusCard> createState() => _PendingStatusCardState();
}

class _PendingStatusCardState extends State<PendingStatusCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.shadowSM,
      ),
      child: Column(
        children: [

          // ── Icône animée ──────────────────────────────
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) => Transform.scale(
              scale: _pulseAnimation.value,
              child: child,
            ),
            child: Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.warning.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.hourglass_top_rounded,
                color: AppTheme.warning,
                size: 32,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── Titre ─────────────────────────────────────
          const Text(
            'Candidature en cours d\'examen',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),

          const SizedBox(height: 8),

          // ── Description ───────────────────────────────
          const Text(
            'Votre dossier a bien été reçu.\nLe service RH l\'examine actuellement.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textSecond,
              fontSize: 13,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 20),

          // ── Divider ───────────────────────────────────
          Container(height: 1, color: AppTheme.border),

          const SizedBox(height: 16),

          // ── Étapes du processus ───────────────────────
          _buildStep(
            icon: Icons.check_circle_rounded,
            color: AppTheme.success,
            label: 'Candidature déposée',
            done: true,
          ),
          const SizedBox(height: 12),
          _buildStep(
            icon: Icons.radio_button_checked_rounded,
            color: AppTheme.warning,
            label: 'Examen par le service RH',
            done: false,
            isActive: true,
          ),
          const SizedBox(height: 12),
          _buildStep(
            icon: Icons.radio_button_unchecked_rounded,
            color: AppTheme.textLight,
            label: 'Décision finale',
            done: false,
          ),
        ],
      ),
    );
  }

  Widget _buildStep({
    required IconData icon,
    required Color color,
    required String label,
    required bool done,
    bool isActive = false,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            color: done
                ? AppTheme.textPrimary
                : isActive
                ? AppTheme.warning
                : AppTheme.textLight,
            fontSize: 13,
            fontWeight: done || isActive
                ? FontWeight.w600
                : FontWeight.w400,
          ),
        ),
        if (isActive) ...[
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8, vertical: 3,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(AppTheme.radiusXS),
            ),
            child: const Text(
              'En cours',
              style: TextStyle(
                color: AppTheme.warning,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ],
    );
  }
}