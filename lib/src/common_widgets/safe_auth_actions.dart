import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../router/router_names.dart';

/// Utility class for safe authentication operations
class SafeAuthActions {
  /// Safely sign out the user with proper error handling and navigation
  static Future<void> signOut(BuildContext context) async {
    // Store context-dependent objects before async operations
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);

    final authProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      await authProvider.signOut();

      // Close loading dialog if still mounted
      if (navigator.canPop()) {
        navigator.pop();
      }

      // Show success message
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text("Logged out successfully"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate to sign-in screen
      router.go(RouterNames.signin);
    } catch (e) {
      // Close loading dialog if still mounted
      if (navigator.canPop()) {
        navigator.pop();
      }

      // Show error message
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text("Failed to sign out: ${e.toString()}"),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  /// Show confirmation dialog before signing out
  static Future<void> showSignOutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Sign Out'),
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // Close dialog first
                await signOut(
                  context,
                ); // Use the original context, not dialog context
              },
            ),
          ],
        );
      },
    );
  }
}
