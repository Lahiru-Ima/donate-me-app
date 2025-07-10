import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:donate_me_app/src/router/router_names.dart';

class ShellNavigation extends StatelessWidget {
  final Widget child;

  const ShellNavigation({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _getCurrentIndex(context),
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: (index) => _onTap(context, index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Jobs'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).fullPath;
    if (location?.startsWith('/home/dashboard') == true) return 0;
    if (location?.startsWith('/home/wishlist') == true) return 1;
    if (location?.startsWith('/home/schedule') == true) return 2;
    if (location?.startsWith('/home/jobs') == true) return 3;
    if (location?.startsWith('/home/profile') == true) return 4;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(RouterNames.home);
        break;
      case 1:
        context.go(RouterNames.wishlist);
        break;
      case 2:
        context.go(RouterNames.schedule);
        break;
      case 3:
        context.go(RouterNames.jobs);
        break;
      case 4:
        context.go(RouterNames.profile);
        break;
    }
  }
}
