import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/pending/pending_header.dart';
import '../widgets/pending/pending_status_card.dart';
import '../widgets/pending/pending_info_card.dart';

class CandidaturePendingPage extends StatefulWidget {
  const CandidaturePendingPage({super.key});

  @override
  State<CandidaturePendingPage> createState() => _CandidaturePendingPageState();
}

class _CandidaturePendingPageState extends State<CandidaturePendingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [

          // ── Header ────────────────────────────────────
          const PendingHeader(),
          Container(height: 1, color: AppTheme.border),

          // ── Contenu ───────────────────────────────────
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [

                    const SizedBox(height: 8),

                    // ── Card statut ───────────────────
                    const PendingStatusCard(),

                    const SizedBox(height: 16),

                    // ── Card infos sujet ──────────────
                    const PendingInfoCard(),

                    const SizedBox(height: 16),

                    // ── Note bas de page ──────────────
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.notifications_outlined,
                            color: AppTheme.textLight,
                            size: 18,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Vous recevrez un email dès que le RH aura pris une décision.',
                              style: TextStyle(
                                color: AppTheme.textSecond,
                                fontSize: 12,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}