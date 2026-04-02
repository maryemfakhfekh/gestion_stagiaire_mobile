// lib/features/stagiaire/pages/candidature_pending_page.dart

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
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
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700))
      ..forward();
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          const PendingHeader(),
          Container(height: 1, color: AppTheme.border),
          Expanded(
            child: FadeTransition(
              opacity: _anim,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                child: Column(
                  children: [
                    const PendingStatusCard(),
                    const SizedBox(height: 16),
                    const PendingInfoCard(),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(
                              color: AppTheme.background,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppTheme.border),
                            ),
                            child: const Icon(Icons.notifications_outlined,
                                color: AppTheme.textLight, size: 18),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Vous recevrez un email dès que le RH aura pris une décision.',
                              style: TextStyle(color: AppTheme.textSecond, fontSize: 12, height: 1.5),
                            ),
                          ),
                        ],
                      ),
                    ),
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