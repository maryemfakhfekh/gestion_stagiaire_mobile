import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/di/injection.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../data/repositories/auth_repository.dart';
import '../widgets/Login/login_background.dart';
import '../widgets/Login/login_button.dart';
import '../widgets/Login/login_footer.dart';
import '../widgets/Login/login_input_field.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordHidden = true;
  bool _isLoading = false;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    bool hasError = false;

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
    }

    if (hasError) {
      setState(() {});
      return;
    }

    setState(() => _isLoading = true);

    try {
      final token = await sl<AuthRepository>().login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (token.isNotEmpty) {
        final role = await sl<AuthRepository>().getRole() ?? '';
        print('>>> [LOGIN] Rôle: $role');

        if (!mounted) return;

        if (role == 'ROLE_STAGIAIRE') {
          await _checkStagiaireAccess(context);
        } else if (role == 'ROLE_ENCADRANT') {
          context.router.replace(const EncadrantHomeRoute());
        } else {
          context.router.replace(const SubjectListRoute());
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusSM),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _checkStagiaireAccess(BuildContext context) async {
    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'token') ?? '';
      print('>>> [CHECK] Token: $token');

      final dio = sl<DioClient>().dio;
      final response = await dio.get(
        '/stagiaires/has-dossier',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print('>>> [CHECK] has-dossier: ${response.data}');
      final hasDossier = response.data as bool;

      if (!context.mounted) return;

      if (hasDossier) {
        print('>>> [CHECK] Redirection → StagiaireHome');
        context.router.replace(const StagiaireHomeRoute());
      } else {
        print('>>> [CHECK] Redirection → SubjectList');
        context.router.replace(const SubjectListRoute());
      }
    } catch (e) {
      print('>>> [CHECK] ERREUR: $e');
      if (!context.mounted) return;
      context.router.replace(const SubjectListRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          const LoginBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius:
                        BorderRadius.circular(AppTheme.radiusXL),
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
                                  "Connexion",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Connexion à votre compte",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                      color: AppTheme.textSecond),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  width: 40,
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primary,
                                    borderRadius:
                                    BorderRadius.circular(10),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),
                          Text(
                            "Adresse email",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          LoginInputField(
                            controller: _emailController,
                            hint: "votre@email.com",
                            icon: Icons.mail_outline_rounded,
                            iconColor: const Color(0xFF3B82F6),
                            iconBg: const Color(0xFFEFF6FF),
                            errorText: _emailError,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Mot de passe",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          LoginInputField(
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
                          const SizedBox(height: 28),
                          LoginButton(
                            onPressed: _isLoading ? null : _login,
                            isLoading: _isLoading,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const LoginFooter(),
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