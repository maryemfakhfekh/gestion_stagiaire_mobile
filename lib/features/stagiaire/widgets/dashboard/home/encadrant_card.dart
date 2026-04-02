// lib/features/stagiaire/widgets/dashboard/home/encadrant_card.dart

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/stagiaire_model.dart';

class EncadrantCard extends StatelessWidget {
  final EncadrantModel? encadrant;
  const EncadrantCard({super.key, this.encadrant});

  String get _initials {
    if (encadrant == null) return '?';
    final parts = encadrant!.nomComplet.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return encadrant!.nomComplet.substring(0, 2).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('MON ENCADRANT',
            style: TextStyle(
                color: AppTheme.textLight,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2)),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.border),
            boxShadow: AppTheme.shadowSM,
          ),
          child: encadrant == null ? _buildEmpty() : _buildEncadrant(),
        ),
      ],
    );
  }

  Widget _buildEmpty() {
    return Row(
      children: [
        Container(
          width: 46, height: 46,
          decoration: BoxDecoration(
            color: AppTheme.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border),
          ),
          child: const Icon(Icons.person_outline_rounded,
              color: AppTheme.textLight, size: 22),
        ),
        const SizedBox(width: 14),
        const Text('Aucun encadrant affecté',
            style: TextStyle(
                color: AppTheme.textLight,
                fontSize: 13,
                fontStyle: FontStyle.italic)),
      ],
    );
  }

  Widget _buildEncadrant() {
    return Row(
      children: [
        Container(
          width: 46, height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFF1E3A5F),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(_initials,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800)),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(encadrant!.nomComplet,
                  style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    width: 6, height: 6,
                    decoration: const BoxDecoration(
                        color: AppTheme.success, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(encadrant!.email,
                        style: const TextStyle(
                            color: AppTheme.textSecond, fontSize: 12),
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: AppTheme.primarySoft,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.mail_outline_rounded,
              color: AppTheme.primary, size: 18),
        ),
      ],
    );
  }
}