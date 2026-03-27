import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../core/routes/app_router.dart';
import '../../../../core/theme/app_theme.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Pas de compte ? ",
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: AppTheme.textSecond),
        ),
        GestureDetector(
          onTap: () => context.pushRoute(const RegisterRoute()),
          child: Text(
            "Créer un compte",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}