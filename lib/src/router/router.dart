import 'package:donate_me_app/src/common_widgets/error_404_screen.dart';
import 'package:donate_me_app/src/features/authentication/forgot_password_screen.dart';
import 'package:donate_me_app/src/features/authentication/sign_in_screen.dart';
import 'package:donate_me_app/src/features/authentication/sign_up_screen.dart';
import 'package:donate_me_app/src/features/main_navigation.dart';
import 'package:donate_me_app/src/features/splash/splash_screen.dart';
import 'package:donate_me_app/src/router/router_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class RouterClass {
  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    errorPageBuilder: (context, state) {
      return const MaterialPage(child: Error404Screen());
    },
    initialLocation: '/',
    routes: [
      GoRoute(
        path: RouterNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouterNames.signin,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: RouterNames.signup,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: RouterNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: RouterNames.home,
        builder: (context, state) => const MainNavigation(),
      ),
    ],
  );
}
