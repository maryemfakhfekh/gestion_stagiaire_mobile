import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../data/models/tache_encadrant_model.dart';
import '../logic/encadrant_bloc.dart';

import '../data/models/stagiaire_encadrant_model.dart';

@RoutePage()
class CreerTachePage extends StatefulWidget {
  final StagiaireEncadrantModel stagiaire;

  const CreerTachePage({
    super.key,
    required this.stagiaire,
  });

  @override
  State<CreerTachePage> createState() => _CreerTachePageState();
}

class _CreerTachePageState extends State<CreerTachePage> {

  final _formKey = GlobalKey<FormState>();
  final _titreController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _dateEcheance;
  String _statut = 'À faire';
  bool _isLoading = false;

  final List<String> _statuts = ['À faire', 'En cours', 'Terminé'];

  final Map<String, Color> _statutColors = {
    'À faire': AppTheme.warning,
    'En cours': AppTheme.primary,
    'Terminé': AppTheme.success,
  };

  final Map<String, Color> _statutBgColors = {
    'À faire': const Color(0xFFFFFBEB),
    'En cours': AppTheme.primarySoft,
    'Terminé': const Color(0xFFF0FDF4),
  };

  final Map<String, IconData> _statutIcons = {
    'À faire': Icons.radio_button_unchecked_rounded,
    'En cours': Icons.timelapse_rounded,
    'Terminé': Icons.check_circle_rounded,
  };

  @override
  void dispose() {
    _titreController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // ── Sélecteur de date ─────────────────────────────────────
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2026, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _dateEcheance = picked);
    }
  }

  // ── Soumettre ─────────────────────────────────────────────
  Future<void> _soumettre() async {
    if (!_formKey.currentState!.validate()) return;
    if (_dateEcheance == null) {
      _showError("Veuillez choisir une date d'échéance.");
      return;
    }

    setState(() => _isLoading = true);

    StatutTacheEncadrant statut;
    switch (_statut) {
      case 'En cours':
        statut = StatutTacheEncadrant.enCours;
        break;
      case 'Terminé':
        statut = StatutTacheEncadrant.termine;
        break;
      case 'À faire':
      default:
        statut = StatutTacheEncadrant.aFaire;
        break;
    }

    final bloc = context.read<EncadrantBloc>();
    bloc.add(
      EncadrantTacheCreated(
        stagiaireId: widget.stagiaire.id,
        titre: _titreController.text.trim(),
        description: _descriptionController.text.trim(),
        dateEcheance: _dateEcheance!,
        statut: statut,
      ),
    );

    final EncadrantState result = await bloc.stream.firstWhere(
      (state) => !state.isLoading,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.error != null) {
      _showError(result.error!);
      return;
    }

    _showSuccess();
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) context.router.back();
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg,
            style: const TextStyle(fontFamily: 'Poppins', color: Colors.white)),
        backgroundColor: AppTheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMD)),
      ),
    );
  }

  void _showSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Tâche créée avec succès !',
            style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMD)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [

            // ── Header ──────────────────────────────────────
            _buildHeader(context),

            // ── Formulaire ──────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // ── Card Stagiaire ───────────────────
                      _buildStagiaireCard(),

                      const SizedBox(height: 20),

                      // ── Titre ────────────────────────────
                      _buildLabel('Titre de la tâche', required: true),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _titreController,
                        hint: 'Ex : Implémenter le module login',
                        icon: Icons.task_alt_rounded,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Le titre est obligatoire'
                            : null,
                      ),

                      const SizedBox(height: 20),

                      // ── Description ──────────────────────
                      _buildLabel('Description', required: false),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _descriptionController,
                        hint: 'Décrivez la tâche en détail...',
                        icon: Icons.description_outlined,
                        maxLines: 4,
                      ),

                      const SizedBox(height: 20),

                      // ── Date échéance ────────────────────
                      _buildLabel("Date d'échéance", required: true),
                      const SizedBox(height: 8),
                      _buildDatePicker(),

                      const SizedBox(height: 20),

                      // ── Statut initial ───────────────────
                      _buildLabel('Statut initial', required: true),
                      const SizedBox(height: 10),
                      _buildStatutSelector(),

                      const SizedBox(height: 32),

                      // ── Bouton Créer ─────────────────────
                      _buildSubmitButton(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.router.back(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                border: Border.all(color: AppTheme.border),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Créer une tâche',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                'Assignez une nouvelle tâche',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: AppTheme.textSecond,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Card Stagiaire ────────────────────────────────────────
  Widget _buildStagiaireCard() {
    final s = widget.stagiaire;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.primarySoft,
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
            ),
            child: Center(
              child: Text(
                s.nomComplet.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.nomComplet,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  s.sujetTitre,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: AppTheme.textSecond,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(AppTheme.radiusSM),
            ),
            child: const Text(
              'Stagiaire',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Label ─────────────────────────────────────────────────
  Widget _buildLabel(String text, {required bool required}) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        if (required) ...[
          const SizedBox(width: 4),
          const Text(
            '*',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.error,
            ),
          ),
        ],
      ],
    );
  }

  // ── TextField ─────────────────────────────────────────────
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        color: AppTheme.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          color: AppTheme.textLight,
        ),
        prefixIcon: maxLines == 1
            ? Icon(icon, color: AppTheme.textLight, size: 18)
            : null,
        filled: true,
        fillColor: AppTheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          borderSide: const BorderSide(color: AppTheme.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          borderSide: const BorderSide(color: AppTheme.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          borderSide: const BorderSide(color: AppTheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          borderSide: const BorderSide(color: AppTheme.error, width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: maxLines > 1 ? 14 : 0,
        ),
      ),
    );
  }

  // ── Date Picker ───────────────────────────────────────────
  Widget _buildDatePicker() {
    final formatted = _dateEcheance == null
        ? null
        : '${_dateEcheance!.day.toString().padLeft(2, '0')}/'
        '${_dateEcheance!.month.toString().padLeft(2, '0')}/'
        '${_dateEcheance!.year}';

    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          border: Border.all(
            color: _dateEcheance != null ? AppTheme.primary : AppTheme.border,
            width: _dateEcheance != null ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 18,
              color: _dateEcheance != null
                  ? AppTheme.primary
                  : AppTheme.textLight,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                formatted ?? "Choisir une date d'échéance",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: _dateEcheance != null
                      ? AppTheme.textPrimary
                      : AppTheme.textLight,
                  fontWeight: _dateEcheance != null
                      ? FontWeight.w500
                      : FontWeight.w400,
                ),
              ),
            ),
            if (_dateEcheance != null)
              GestureDetector(
                onTap: () => setState(() => _dateEcheance = null),
                child: const Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: AppTheme.textSecond,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ── Statut Selector ───────────────────────────────────────
  Widget _buildStatutSelector() {
    return Row(
      children: _statuts.map((statut) {
        final isSelected = _statut == statut;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _statut = statut),
            child: Container(
              margin: EdgeInsets.only(
                right: statut != _statuts.last ? 8 : 0,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? _statutBgColors[statut]
                    : AppTheme.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                border: Border.all(
                  color: isSelected
                      ? _statutColors[statut]!
                      : AppTheme.border,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _statutIcons[statut],
                    size: 20,
                    color: isSelected
                        ? _statutColors[statut]
                        : AppTheme.textLight,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    statut,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w400,
                      color: isSelected
                          ? _statutColors[statut]
                          : AppTheme.textSecond,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Submit Button ─────────────────────────────────────────
  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _soumettre,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: _isLoading
              ? AppTheme.primary.withOpacity(0.7)
              : AppTheme.primary,
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: _isLoading
              ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.5,
            ),
          )
              : const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_task_rounded,
                  color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text(
                'Créer la tâche',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}