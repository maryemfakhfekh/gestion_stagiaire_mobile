import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/models/tache_model.dart';

class AddTaskDialog extends StatefulWidget {
  final Function(Tache) onTaskCreated;
  const AddTaskDialog({super.key, required this.onTaskCreated});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _summaryController     = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime    _dateEcheance = DateTime.now().add(const Duration(days: 7));
  TachePriorite _priorite   = TachePriorite.moyenne;
  _WorkType   _workType     = _WorkType.task;

  // section toggles
  bool _descExpanded  = true;
  bool _moreExpanded  = false;

  @override
  void dispose() {
    _summaryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // ── Submit ────────────────────────────────────────────────
  void _submit() {
    if (_summaryController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Le résumé est requis'),
          backgroundColor: AppTheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusSM)),
        ),
      );
      return;
    }
    final issueKey = 'GS-${DateTime.now().millisecondsSinceEpoch % 100}';
    widget.onTaskCreated(Tache(
      id:           DateTime.now().millisecondsSinceEpoch.toString(),
      issueKey:     issueKey,
      titre:        _summaryController.text.trim(),
      description:  _descriptionController.text.isEmpty
          ? null : _descriptionController.text,
      statut:       TacheStatut.aFaire,
      priorite:     _priorite,
      dateEcheance: _dateEcheance,
      dateCreation: DateTime.now(),
      assigneeName: 'Moi',
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        backgroundColor: AppTheme.background,
        body: Column(
          children: [

            // ── Top bar ───────────────────────────────────
            _buildTopBar(),

            // ── Work type selector ────────────────────────
            _buildWorkTypeBar(),

            Container(height: 1, color: AppTheme.border),

            // ── Body ──────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    // ── Summary ───────────────────────────
                    _buildSummaryField(),

                    Container(height: 1, color: AppTheme.border),

                    // ── Description ───────────────────────
                    _buildCollapsibleSection(
                      title:    'Description',
                      expanded: _descExpanded,
                      onTap:    () => setState(
                              () => _descExpanded = !_descExpanded),
                      child:    _buildDescriptionField(),
                    ),

                    Container(height: 1, color: AppTheme.border),

                    // ── Attachments (décoratif) ────────────
                    _buildAttachmentsRow(),

                    Container(height: 1, color: AppTheme.border),

                    // ── More fields ───────────────────────
                    _buildCollapsibleSection(
                      title:    'More fields',
                      subtitle: 'Sprint, Parent, Priorité, Date...',
                      expanded: _moreExpanded,
                      onTap:    () => setState(
                              () => _moreExpanded = !_moreExpanded),
                      child:    _buildMoreFields(),
                    ),

                    Container(height: 1, color: AppTheme.border),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Top bar ───────────────────────────────────────────────
  Widget _buildTopBar() {
    return Container(
      color: AppTheme.surface,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 12,
        left: 8,
        right: 8,
      ),
      child: Row(
        children: [
          // ✕ Fermer
          _circleBtn(
            icon: Icons.close,
            onTap: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Create',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
          ),
          // ✓ Valider
          _circleBtn(
            icon: Icons.check,
            onTap: _submit,
            filled: true,
          ),
        ],
      ),
    );
  }

  Widget _circleBtn({
    required IconData icon,
    required VoidCallback onTap,
    bool filled = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: filled ? AppTheme.primary : AppTheme.background,
          border: Border.all(color: AppTheme.border),
        ),
        child: Icon(
          icon,
          size: 20,
          color: filled ? Colors.white : AppTheme.textPrimary,
        ),
      ),
    );
  }

  // ── Work type bar ─────────────────────────────────────────
  Widget _buildWorkTypeBar() {
    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Project pill
          _pill(
            icon: Icons.dashboard_outlined,
            iconColor: AppTheme.primary,
            label: 'Gestion de Sta...',
            onTap: () {},
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Icon(Icons.chevron_right,
                size: 16, color: AppTheme.textLight),
          ),
          // Work type pill
          GestureDetector(
            onTap: _showWorkTypeSheet,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius:
                BorderRadius.circular(AppTheme.radiusSM),
                border: Border.all(color: AppTheme.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_workType.icon,
                      size: 14, color: _workType.color),
                  const SizedBox(width: 6),
                  Text(
                    _workType.label,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down,
                      size: 14, color: AppTheme.textLight),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pill({
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.background,
          borderRadius: BorderRadius.circular(AppTheme.radiusSM),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: iconColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down,
                size: 14, color: AppTheme.textLight),
          ],
        ),
      ),
    );
  }

  // ── Summary ───────────────────────────────────────────────
  Widget _buildSummaryField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextField(
              controller: _summaryController,
              autofocus: false,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimary,
              ),
              decoration: const InputDecoration(
                hintText: 'Add a summary...',
                hintStyle: TextStyle(
                  fontSize: 18,
                  color: AppTheme.textLight,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              maxLines: null,
            ),
          ),
          const SizedBox(width: 12),
          // Avatar assigné
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.primarySoft,
              shape: BoxShape.circle,
              border: Border.all(
                  color: AppTheme.primary.withOpacity(0.2)),
            ),
            child: const Icon(
              Icons.person_outline,
              size: 16,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  // ── Section collapsible ───────────────────────────────────
  Widget _buildCollapsibleSection({
    required String title,
    String? subtitle,
    required bool expanded,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            color: AppTheme.surface,
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      if (subtitle != null && !expanded)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            subtitle,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textLight,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 20,
                  color: AppTheme.textLight,
                ),
              ],
            ),
          ),
        ),
        if (expanded) child,
      ],
    );
  }

  // ── Description ───────────────────────────────────────────
  Widget _buildDescriptionField() {
    return Container(
      color: AppTheme.background,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: TextField(
        controller: _descriptionController,
        maxLines: 4,
        style: const TextStyle(
          fontSize: 14,
          color: AppTheme.textPrimary,
          height: 1.5,
        ),
        decoration: const InputDecoration(
          hintText: 'Add a description...',
          hintStyle: TextStyle(
            color: AppTheme.textLight,
            fontSize: 14,
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  // ── Attachments row ───────────────────────────────────────
  Widget _buildAttachmentsRow() {
    return Container(
      color: AppTheme.surface,
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 14),
      child: Row(
        children: const [
          Expanded(
            child: Text(
              'Attachments',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          Icon(Icons.chevron_right,
              size: 20, color: AppTheme.textLight),
        ],
      ),
    );
  }

  // ── More fields ───────────────────────────────────────────
  Widget _buildMoreFields() {
    return Container(
      color: AppTheme.background,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        children: [

          // Priorité
          _moreFieldRow(
            label: 'Priorité',
            child: GestureDetector(
              onTap: _showPrioriteSheet,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _prioriteBg(_priorite),
                      borderRadius:
                      BorderRadius.circular(AppTheme.radiusXS),
                    ),
                    child: Text(
                      _prioriteLabel(_priorite),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _prioriteColor(_priorite),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down,
                      size: 14, color: AppTheme.textLight),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Date échéance
          _moreFieldRow(
            label: 'Date d\'échéance',
            child: GestureDetector(
              onTap: _pickDate,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.calendar_today_outlined,
                      size: 14, color: AppTheme.textLight),
                  const SizedBox(width: 6),
                  Text(
                    _formatDate(_dateEcheance),
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _moreFieldRow({
    required String label,
    required Widget child,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textLight,
            ),
          ),
        ),
        child,
      ],
    );
  }

  // ── Work type bottom sheet ────────────────────────────────
  void _showWorkTypeSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Center(
              child: Container(
                width: 36, height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
                vertical: 12, horizontal: 20),
            child: Row(
              children: [
                Text(
                  'Work Type',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: AppTheme.border),
          ..._WorkType.values.map((wt) => _workTypeItem(wt)),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _workTypeItem(_WorkType wt) {
    final isSelected = _workType == wt;
    return GestureDetector(
      onTap: () {
        setState(() => _workType = wt);
        Navigator.pop(context);
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: wt.color.withOpacity(0.1),
                borderRadius:
                BorderRadius.circular(AppTheme.radiusSM),
              ),
              child: Icon(wt.icon, size: 18, color: wt.color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    wt.label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    wt.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textLight,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check,
                  size: 18, color: AppTheme.primary),
          ],
        ),
      ),
    );
  }

  // ── Priorité bottom sheet ─────────────────────────────────
  void _showPrioriteSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: const [
                Text(
                  'Priorité',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: AppTheme.border),
          ...TachePriorite.values.map((p) {
            final isSelected = _priorite == p;
            return GestureDetector(
              onTap: () {
                setState(() => _priorite = p);
                Navigator.pop(context);
              },
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _prioriteColor(p),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        _prioriteLabel(p),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(Icons.check,
                          size: 18, color: AppTheme.primary),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ── Date picker ───────────────────────────────────────────
  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dateEcheance,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: AppTheme.primary),
        ),
        child: child!,
      ),
    );
    if (date != null) setState(() => _dateEcheance = date);
  }

  // ── Helpers ───────────────────────────────────────────────
  String _formatDate(DateTime d) =>
      '${d.day}/${d.month}/${d.year}';

  Color _prioriteColor(TachePriorite p) => switch (p) {
    TachePriorite.basse    => const Color(0xFF166534),
    TachePriorite.moyenne  => const Color(0xFFED6C02),
    TachePriorite.haute    => const Color(0xFFD32F2F),
    TachePriorite.critique => const Color(0xFF9C27B0),
  };

  Color _prioriteBg(TachePriorite p) => switch (p) {
    TachePriorite.basse    => const Color(0xFFDCFCE7),
    TachePriorite.moyenne  => const Color(0xFFFFF3E0),
    TachePriorite.haute    => const Color(0xFFFFEBEE),
    TachePriorite.critique => const Color(0xFFF3E5F5),
  };

  String _prioriteLabel(TachePriorite p) => switch (p) {
    TachePriorite.basse    => 'BASSE',
    TachePriorite.moyenne  => 'MOYENNE',
    TachePriorite.haute    => 'HAUTE',
    TachePriorite.critique => 'CRITIQUE',
  };
}

// ── Work type enum ────────────────────────────────────────────
enum _WorkType {
  task(
    label:       'Task',
    description: 'A task that needs to be done.',
    icon:        Icons.check_box_outlined,
    color:       Color(0xFF1D4ED8),
  ),
  story(
    label:       'Story',
    description: 'Stories track functionality or features.',
    icon:        Icons.bookmark_border_outlined,
    color:       Color(0xFF166534),
  ),
  bug(
    label:       'Bug',
    description: 'A problem or error.',
    icon:        Icons.bug_report_outlined,
    color:       Color(0xFFD32F2F),
  ),
  epic(
    label:       'Epic',
    description: 'A big user story to break down.',
    icon:        Icons.bolt_outlined,
    color:       Color(0xFF9C27B0),
  );

  const _WorkType({
    required this.label,
    required this.description,
    required this.icon,
    required this.color,
  });

  final String   label;
  final String   description;
  final IconData icon;
  final Color    color;
}