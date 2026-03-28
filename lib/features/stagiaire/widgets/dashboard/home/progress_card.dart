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
        .animate(CurvedAnimation(
        parent: _controller, curve: Curves.easeOut));
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
        const Text('VUE D\'ENSEMBLE',
            style: TextStyle(
                color: AppTheme.textLight,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2)),
        const SizedBox(height: 12),

        // Stats row
        Row(
          children: [
            _buildStat('3', 'Terminées', AppTheme.success,
                Icons.check_circle_rounded),
            const SizedBox(width: 10),
            _buildStat('2', 'En cours', AppTheme.primary,
                Icons.radio_button_checked_rounded),
            const SizedBox(width: 10),
            _buildStat('2', 'À faire', AppTheme.textLight,
                Icons.circle_outlined),
          ],
        ),

        const SizedBox(height: 12),

        // Progress bar card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.border),
            boxShadow: AppTheme.shadowSM,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8, height: 8,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('Progression du sprint',
                      style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700)),
                  const Spacer(),
                  AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (context, _) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primarySoft,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${(_progressAnimation.value * 100).toInt()}%',
                        style: const TextStyle(
                            color: AppTheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, _) => ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: LinearProgressIndicator(
                    value: _progressAnimation.value,
                    backgroundColor: AppTheme.border,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppTheme.primary),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text('Sprint 1 · 3 sur 7 tâches complétées',
                  style: TextStyle(
                      color: AppTheme.textLight, fontSize: 11)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStat(String value, String label, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border),
          boxShadow: AppTheme.shadowSM,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(height: 10),
            Text(value,
                style: TextStyle(
                    color: color,
                    fontSize: 26,
                    fontWeight: FontWeight.w900)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    color: AppTheme.textLight,
                    fontSize: 11,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}