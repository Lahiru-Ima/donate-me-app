import 'package:donate_me_app/src/common_widgets/app_logo.dart';
import 'package:donate_me_app/src/common_widgets/snackbar_util.dart';
import 'package:donate_me_app/src/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../common_widgets/account_check.dart';
import '../../common_widgets/primary_button.dart';
import '../../common_widgets/text_input_field.dart';
import '../../constants/constants.dart';
import '../../router/router_names.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<StatefulWidget> createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool isPasswordVisible = true;

  @override
  void initState() {
    super.initState();
    // Clear any previous errors when entering the screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthenticationProvider>(context, listen: false).clearError();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // Logo Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Center(child: AppLogo()),
                  ),
                  const SizedBox(height: 32),

                  // Welcome Text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Text(
                          'Welcome Back!',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sign in to continue your journey',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Form Section
                  Expanded(
                    child: FormBuilder(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextInputField(
                              name: "email",
                              keyboard: TextInputType.emailAddress,
                              labelText: 'Enter your email address',
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: 'Email is required',
                                ),
                                FormBuilderValidators.email(
                                  errorText:
                                      'Please enter a valid email address',
                                ),
                              ]),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Password',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextInputField(
                              name: "password",
                              labelText: 'Enter your password',
                              keyboard: TextInputType.visiblePassword,
                              obscureText: isPasswordVisible,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.grey[600],
                                ),
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                              ),
                              validator: FormBuilderValidators.required(
                                errorText: "Password is required",
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Forgot Password
                            Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () {
                                  context.push(RouterNames.forgotPassword);
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Sign In Button
                            Consumer<AuthenticationProvider>(
                              builder: (context, authProvider, child) {
                                return SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: authProvider.isLoading
                                      ? ElevatedButton(
                                          onPressed: null,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: kPrimaryColor
                                                .withOpacity(0.7),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          ),
                                        )
                                      : PrimaryButton(
                                          text: "Sign In",
                                          press: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              final email = _formKey
                                                  .currentState!
                                                  .fields['email']
                                                  ?.value
                                                  ?.replaceAll(
                                                    RegExp(r"\s"),
                                                    "",
                                                  )
                                                  ?.trim();

                                              final password = _formKey
                                                  .currentState!
                                                  .fields['password']!
                                                  .value
                                                  .trim();

                                              _login(email, password);
                                            }
                                          },
                                        ),
                                );
                              },
                            ),
                            const SizedBox(height: 24),

                            // Account Check
                            const Center(child: AccountCheck(login: true)),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _login(String email, String password) async {
    try {
      final authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );
      await authProvider.signIn(email, password);

      if (mounted && authProvider.isAuthenticated) {
        context.go(RouterNames.home);
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'An error occurred. Please try again.';
        if (e is AuthException) {
          errorMessage = e.message;
        } else {
          errorMessage = e.toString();
        }

        SnackBarUtil.showErrorSnackBar(context, errorMessage);
      }
    }
  }
}
