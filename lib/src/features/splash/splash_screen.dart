import 'dart:async';
import 'package:donate_me_app/src/common_widgets/app_logo.dart';
import 'package:donate_me_app/src/providers/auth_provider.dart';
import 'package:donate_me_app/src/router/router_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthenticationStatus();
  }

  Future<void> _checkAuthenticationStatus() async {
    // Load user data if available
    final authProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );
    await authProvider.loadUser();

    // Wait for 2 seconds for splash effect
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      if (authProvider.isAuthenticated) {
        context.go(RouterNames.home);
      } else {
        context.go(RouterNames.signin);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: AppLogo()),
    );
  }
}
