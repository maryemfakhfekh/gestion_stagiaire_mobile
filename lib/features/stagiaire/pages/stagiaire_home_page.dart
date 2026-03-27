import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'candidature_pending_page.dart';
import 'stagiaire_dashboard_page.dart';

@RoutePage()
class StagiaireHomePage extends StatelessWidget {
  const StagiaireHomePage({super.key});

  // ── 🔧 Change cette valeur pour tester les deux interfaces ──
  // "EN_ATTENTE" → page d'attente
  // "ACCEPTEE"   → dashboard complet
  // TODO: remplacer par la vraie valeur provenant du BLoC (Phase 6)
  static const String _statutTest = "ACCEPTEE";  // ← modifie ici pour basculer

  @override
  Widget build(BuildContext context) {
    return switch (_statutTest) {
      "ACCEPTEE"   => const StaigaireDashboardPage(),  // ← nom corrigé avec la faute de frappe
      _            => const CandidaturePendingPage(),
    };
  }
}