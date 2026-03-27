import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/routes/app_router.dart'; // ✅ AJOUTER CET IMPORT
import '../../../core/theme/app_theme.dart';
import '../../auth/logic/auth_bloc.dart';
import '../../auth/logic/auth_event.dart';

@RoutePage()
class EncadrantHomePage extends StatelessWidget {
  const EncadrantHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("👨‍🏫 Espace Encadrant"),
        backgroundColor: AppTheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
              context.router.replaceAll([const LoginRoute()]);
            },
          ),
        ],
      ),
      body: const Center(
        child: Text("Bienvenue Encadrant !"),
      ),
    );
  }
}