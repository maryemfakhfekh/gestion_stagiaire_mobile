// lib/features/stagiaire/widgets/dashboard/tabs/rapport_tab.dart

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/injection.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/rapport_model.dart';
import '../../../logic/rapport_bloc.dart';

class RapportTab extends StatelessWidget {
  const RapportTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RapportBloc>()..add(LoadRapport()),
      child: const _RapportView(),
    );
  }
}

class _RapportView extends StatelessWidget {
  const _RapportView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RapportBloc, RapportState>(
      listener: (context, state) {
        if (state is RapportUploadSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Rapport déposé avec succès ✓'),
              backgroundColor: AppTheme.success,
            ),
          );
        }
        if (state is RapportError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is RapportLoading || state is RapportInitial) {
          return const Center(
              child: CircularProgressIndicator(color: AppTheme.primary));
        }

        final rapport = state is RapportLoaded
            ? state.rapport
            : state is RapportUploadSuccess
            ? state.rapport
            : null;
        final isUploading = state is RapportUploading;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre
              Row(
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: AppTheme.primarySoft,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.description_rounded,
                        color: AppTheme.primary, size: 22),
                  ),
                  const SizedBox(width: 14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Rapport de stage',
                          style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.4)),
                      Text('Déposez votre rapport final en PDF',
                          style: TextStyle(
                              color: AppTheme.textSecond, fontSize: 13)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Statut
              _StatusCard(rapport: rapport),
              const SizedBox(height: 20),

              if (rapport == null && !isUploading) ...[
                const Text('Sélectionner votre rapport',
                    style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                const Text('Format PDF uniquement · Max 20 MB',
                    style: TextStyle(
                        color: AppTheme.textLight, fontSize: 12)),
                const SizedBox(height: 12),
                _UploadZone(
                  onUpload: (path, name) => context
                      .read<RapportBloc>()
                      .add(DeposerRapport(path, name)),
                ),
              ],

              if (isUploading)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: const Row(
                    children: [
                      CircularProgressIndicator(
                          color: AppTheme.primary, strokeWidth: 2),
                      SizedBox(width: 16),
                      Text('Envoi en cours...',
                          style: TextStyle(
                              color: AppTheme.textSecond, fontSize: 13)),
                    ],
                  ),
                ),

              const SizedBox(height: 20),

              // Note info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primarySoft,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: AppTheme.primary.withOpacity(0.15)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.info_outline_rounded,
                          color: AppTheme.primary, size: 16),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Votre rapport sera consulté par votre encadrant et le service RH. Assurez-vous qu\'il est complet avant de le soumettre.',
                        style: TextStyle(
                            color: AppTheme.textSecond,
                            fontSize: 12,
                            height: 1.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatusCard extends StatelessWidget {
  final RapportModel? rapport;
  const _StatusCard({this.rapport});

  @override
  Widget build(BuildContext context) {
    final estDepose = rapport != null;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: estDepose ? const Color(0xFFF0FDF4) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: estDepose
                ? AppTheme.success.withOpacity(0.3) : AppTheme.border),
        boxShadow: AppTheme.shadowSM,
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: estDepose
                  ? AppTheme.success.withOpacity(0.12) : AppTheme.primarySoft,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              estDepose
                  ? Icons.check_circle_outline_rounded
                  : Icons.upload_file_rounded,
              color: estDepose ? AppTheme.success : AppTheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  estDepose ? 'Rapport déposé ✓' : 'Rapport non déposé',
                  style: TextStyle(
                      color: estDepose
                          ? AppTheme.success : AppTheme.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  estDepose
                      ? 'Déposé le ${rapport!.dateDepot ?? ''} · En attente encadrant'
                      : 'Déposez votre rapport avant la fin du stage',
                  style: const TextStyle(
                      color: AppTheme.textSecond, fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadZone extends StatefulWidget {
  final void Function(String path, String name) onUpload;
  const _UploadZone({required this.onUpload});

  @override
  State<_UploadZone> createState() => _UploadZoneState();
}

class _UploadZoneState extends State<_UploadZone>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  String? _fileName;
  String? _filePath;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1600))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.97, end: 1.03)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _filePath = result.files.single.path;
        _fileName = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_fileName != null && _filePath != null) {
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.picture_as_pdf_rounded,
                      color: AppTheme.error, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_fileName!,
                          style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.w700),
                          overflow: TextOverflow.ellipsis),
                      const Text('Prêt à être soumis',
                          style: TextStyle(
                              color: AppTheme.success,
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      setState(() { _fileName = null; _filePath = null; }),
                  child: Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: const Icon(Icons.close_rounded,
                        color: AppTheme.textLight, size: 16),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () => widget.onUpload(_filePath!, _fileName!),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send_rounded, size: 18),
                  SizedBox(width: 10),
                  Text('Soumettre le rapport',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return AnimatedBuilder(
      animation: _anim,
      builder: (_, child) =>
          Transform.scale(scale: _anim.value, child: child),
      child: GestureDetector(
        onTap: _pickFile,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 36),
          decoration: BoxDecoration(
            color: AppTheme.primarySoft,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: AppTheme.primary.withOpacity(0.25), width: 1.5),
          ),
          child: const Column(
            children: [
              Icon(Icons.cloud_upload_rounded,
                  color: AppTheme.primary, size: 40),
              SizedBox(height: 16),
              Text('Appuyez pour sélectionner',
                  style: TextStyle(
                      color: AppTheme.primary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700)),
              SizedBox(height: 6),
              Text('Format PDF uniquement · Max 20 MB',
                  style: TextStyle(
                      color: AppTheme.textLight, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}