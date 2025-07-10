import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/constants.dart';
import '../router/router_names.dart';

class AccountCheck extends StatelessWidget {
  final bool login;
  const AccountCheck({
    super.key,
    this.login = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          login ? "Don't have account? " : "Already have account? ",
          style: const TextStyle(color: kTextColor),
        ),
        GestureDetector(
          onTap: () {
            login
                ? context.push(RouterNames.signup)
                : context.push(RouterNames.signin);
          },
          child: Text(
            login ? "Signup" : "Login",
            style: const TextStyle(
                color: kPrimaryColor, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
