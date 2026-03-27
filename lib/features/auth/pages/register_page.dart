import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/routes/app_router.dart';
import '../../../core/di/injection.dart';
import '../../../core/theme/app_theme.dart';
import '../data/models/user_model.dart';
import '../data/models/reference_model.dart';
import '../data/repositories/auth_repository.dart';
import '../logic/auth_bloc.dart';
import '../logic/auth_event.dart';
import '../logic/auth_state.dart';
import '../widgets/register/auth_background.dart';
import '../widgets/register/auth_button.dart';
import '../widgets/register/auth_footer.dart';
import '../widgets/register/dropdown_field.dart';
import '../widgets/register/input_field.dart';
import '../widgets/register/role_chip.dart';

@RoutePage()
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String selectedRole = "Stagiaire";

  final _nomController = TextEditingController();
  final _emailController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _dateNaissanceController = TextEditingController();
  final _passwordController = TextEditingController();
  final _etablissementController = TextEditingController();

  List<ReferenceModel> _filieres = [];
  List<ReferenceModel> _cycles = [];
  ReferenceModel? selectedFiliere;
  ReferenceModel? selectedCycle;

  bool _isPasswordHidden = true;

  String? _nomError;
  String? _emailError;
  String? _passwordError;
  String? _filiereError;
  String? _etablissementError;
  String? _cycleError;

  @override
  void initState() {
    super.initState();
    _loadReferences();
  }

  Future<void> _loadReferences() async {
    try {
      final repo = sl<AuthRepository>();
      final filieresData = await repo.getFilieres();
      final cyclesData = await repo.getCycles();

      if (!mounted) return;

      setState(() {
        _filieres = filieresData;
        _cycles = cyclesData;
      });
    } catch (e) {
      debugPrint("Erreur références : $e");
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
    _dateNaissanceController.dispose();
    _passwordController.dispose();
    _etablissementController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppTheme.primary),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        _dateNaissanceController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _register() {
    setState(() {
      _nomError = null;
      _emailError = null;
      _passwordError = null;
      _filiereError = null;
      _etablissementError = null;
      _cycleError = null;
    });

    bool hasError = false;

    if (_nomController.text.trim().isEmpty) {
      _nomError = "Le nom complet est requis";
      hasError = true;
    }

    if (_emailController.text.trim().isEmpty) {
      _emailError = "L'adresse email est requise";
      hasError = true;
    } else if (!_emailController.text.trim().contains('@')) {
      _emailError = "Adresse email invalide";
      hasError = true;
    }

    if (_passwordController.text.trim().isEmpty) {
      _passwordError = "Le mot de passe est requis";
      hasError = true;
    } else if (_passwordController.text.trim().length < 6) {
      _passwordError = "Minimum 6 caractères";
      hasError = true;
    }

    if (selectedRole == "Stagiaire") {
      if (selectedFiliere == null) {
        _filiereError = "Sélectionnez une filière";
        hasError = true;
      }

      if (_etablissementController.text.trim().isEmpty) {
        _etablissementError = "L'établissement est requis";
        hasError = true;
      }

      if (selectedCycle == null) {
        _cycleError = "Sélectionnez un cycle";
        hasError = true;
      }
    }

    if (hasError) {
      setState(() {});
      return;
    }

    final user = UserModel(
      nomComplet: _nomController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      telephone: _telephoneController.text.trim(),
      dateNaissance: _dateNaissanceController.text.trim(),
      role: selectedRole.toUpperCase(),
      etablissement:
      selectedRole == "Stagiaire" ? _etablissementController.text.trim() : null,
      filiereId: selectedRole == "Stagiaire" ? selectedFiliere?.id : null,
      cycleId: selectedRole == "Stagiaire" ? selectedCycle?.id : null,
    );

    context.read<AuthBloc>().add(RegisterSubmitted(user));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Compte créé avec succès !"),
              backgroundColor: AppTheme.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusSM),
              ),
            ),
          );

          context.router.replace(const LoginRoute());
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: AppTheme.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusSM),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F2F5),
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            const AuthBackground(),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Column(
                    children: [

                      const SizedBox(height: 32),

                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.surface,
                          borderRadius: BorderRadius.circular(AppTheme.radiusXL),
                          boxShadow: AppTheme.shadowMD,
                        ),
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    "Créer un compte",
                                    style: Theme.of(context).textTheme.displaySmall,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Rejoignez la plateforme ASM",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: AppTheme.textSecond),
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    width: 40,
                                    height: 3,
                                    decoration: BoxDecoration(
                                      color: AppTheme.primary,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 28),

                            const Text(
                              "Vous êtes",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                RoleChip(
                                  label: "Stagiaire",
                                  icon: Icons.school_rounded,
                                  selected: selectedRole == "Stagiaire",
                                  onTap: () => setState(() => selectedRole = "Stagiaire"),
                                ),
                                const SizedBox(width: 12),
                                RoleChip(
                                  label: "Encadrant",
                                  icon: Icons.person_rounded,
                                  selected: selectedRole == "Encadrant",
                                  onTap: () => setState(() => selectedRole = "Encadrant"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            const Text(
                              "Nom complet",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            InputField(
                              controller: _nomController,
                              hint: "Prénom Nom",
                              icon: Icons.person_outline_rounded,
                              iconColor: const Color(0xFF059669),
                              iconBg: const Color(0xFFF0FDF4),
                              errorText: _nomError,
                            ),
                            const SizedBox(height: 16),

                            const Text(
                              "Adresse email",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            InputField(
                              controller: _emailController,
                              hint: "votre@email.com",
                              icon: Icons.mail_outline_rounded,
                              iconColor: const Color(0xFF3B82F6),
                              iconBg: const Color(0xFFEFF6FF),
                              errorText: _emailError,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 16),

                            const Text(
                              "Téléphone",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            InputField(
                              controller: _telephoneController,
                              hint: "+216 XX XXX XXX",
                              icon: Icons.phone_outlined,
                              iconColor: const Color(0xFF0891B2),
                              iconBg: const Color(0xFFECFEFF),
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 16),

                            const Text(
                              "Date de naissance",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            InputField(
                              controller: _dateNaissanceController,
                              hint: "YYYY-MM-DD",
                              icon: Icons.cake_outlined,
                              iconColor: const Color(0xFFDB2777),
                              iconBg: const Color(0xFFFDF2F8),
                              readOnly: true,
                              onTap: () => _selectDate(context),
                            ),
                            const SizedBox(height: 16),

                            const Text(
                              "Mot de passe",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            InputField(
                              controller: _passwordController,
                              hint: "••••••••",
                              icon: Icons.lock_outline_rounded,
                              iconColor: const Color(0xFF8B5CF6),
                              iconBg: const Color(0xFFF5F3FF),
                              errorText: _passwordError,
                              obscure: _isPasswordHidden,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isPasswordHidden = !_isPasswordHidden;
                                  });
                                },
                                child: Icon(
                                  _isPasswordHidden
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppTheme.textLight,
                                  size: 20,
                                ),
                              ),
                            ),

                            if (selectedRole == "Stagiaire") ...[
                              const SizedBox(height: 16),
                              const Text(
                                "Filière",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              DropdownField(
                                hint: "Sélectionnez votre filière",
                                icon: Icons.book_outlined,
                                iconColor: const Color(0xFFF57C00),
                                iconBg: const Color(0xFFFFF4ED),
                                value: selectedFiliere?.nom,
                                items: _filieres.map((f) => f.nom).toList(),
                                onChanged: (val) {
                                  setState(() {
                                    selectedFiliere = _filieres.firstWhere((f) => f.nom == val);
                                  });
                                },
                                errorText: _filiereError,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "Établissement",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              InputField(
                                controller: _etablissementController,
                                hint: "Nom de votre établissement",
                                icon: Icons.business_outlined,
                                iconColor: const Color(0xFF0284C7),
                                iconBg: const Color(0xFFEFF6FF),
                                errorText: _etablissementError,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "Cycle d'études",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              DropdownField(
                                hint: "Sélectionnez votre cycle",
                                icon: Icons.history_edu_outlined,
                                iconColor: const Color(0xFF7C3AED),
                                iconBg: const Color(0xFFF5F3FF),
                                value: selectedCycle?.nom,
                                items: _cycles.map((c) => c.nom).toList(),
                                onChanged: (val) {
                                  setState(() {
                                    selectedCycle = _cycles.firstWhere((c) => c.nom == val);
                                  });
                                },
                                errorText: _cycleError,
                              ),
                            ],

                            const SizedBox(height: 28),

                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                final isLoading = state is AuthLoading;

                                return AuthButton(
                                  onPressed: isLoading ? null : _register,
                                  isLoading: isLoading,
                                  label: "S'inscrire",
                                  icon: Icons.person_add_rounded,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      AuthFooter(
                        question: "Déjà un compte ? ",
                        actionText: "Se connecter",
                        onAction: () => context.router.replace(const LoginRoute()),
                      ),
                      const SizedBox(height: 40),
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
}