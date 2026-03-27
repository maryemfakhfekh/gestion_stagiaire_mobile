import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class ProgressCard extends StatefulWidget {
  final double progress;
  const ProgressCard({super.key, this.progress = 0.6});

  @override
  State<ProgressCard> createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
    _progressAnimation = Tween<double>(begin: 0.0, end: widget.progress)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // ── Titre section style Jira ──────────────────
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            'VUE D\'ENSEMBLE',
            style: TextStyle(
              color: AppTheme.textLight,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),

        // ── Grid stats style Jira ─────────────────────
        Row(
          children: [
            _buildStatBox(
              value: '3',
              label: 'Terminées',
              color: AppTheme.success,
              icon: Icons.check_circle_rounded,
            ),
            const SizedBox(width: 10),
            _buildStatBox(
              value: '2',
              label: 'En cours',
              color: AppTheme.warning,
              icon: Icons.radio_button_checked_rounded,
            ),
            const SizedBox(width: 10),
            _buildStatBox(
              value: '2',
              label: 'À faire',
              color: AppTheme.textSecond,
              icon: Icons.circle_outlined,
            ),
          ],
        ),

        const SizedBox(height: 14),

        // ── Barre progression style Jira ──────────────
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusMD),
            border: Border.all(color: AppTheme.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Progression du sprint',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (context, _) => Text(
                      '${(_progressAnimation.value * 100).toInt()}%',
                      style: const TextStyle(
                        color: AppTheme.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, _) => ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: LinearProgressIndicator(
                    value: _progressAnimation.value,
                    backgroundColor: AppTheme.border,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppTheme.primary,
                    ),
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sprint 1 · 3 sur 7 tâches complétées',
                style: TextStyle(
                  color: AppTheme.textLight,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatBox({
    required String value,
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.textLight,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}