import 'package:donate_me_app/src/common_widgets/app_logo.dart';
import 'package:donate_me_app/src/common_widgets/primary_button.dart';
import 'package:donate_me_app/src/common_widgets/snackbar_util.dart';
import 'package:donate_me_app/src/common_widgets/text_input_field.dart';
import 'package:donate_me_app/src/constants/constants.dart';
import 'package:donate_me_app/src/router/router_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: keyboardHeight),
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
                  const SizedBox(height: 24),

                  // Back Button and Title Row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey[200]!,
                              width: 1,
                            ),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.black87,
                            ),
                            onPressed: () {
                              context.pop();
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Forgot Password',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Logo Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Center(child: AppLogo()),
                  ),
                  const SizedBox(height: 32),

                  // Content Section
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title and Description
                          const Text(
                            'Reset Your Password',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Enter your email address and we\'ll send you a password reset link.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Form Section
                          FormBuilder(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Email Address',
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
                                const SizedBox(height: 32),

                                // Reset Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: isLoading
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
                                          text: "Send Reset Link",
                                          press: _handlePasswordReset,
                                        ),
                                ),
                                const SizedBox(height: 24),

                                // Back to Sign In
                                Center(
                                  child: TextButton(
                                    onPressed: () {
                                      context.push(RouterNames.signin);
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        style: const TextStyle(fontSize: 14),
                                        children: [
                                          TextSpan(
                                            text: 'Remember your password? ',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          const TextSpan(
                                            text: 'Sign In',
                                            style: TextStyle(
                                              color: kPrimaryColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Wave Image at Bottom
                  if (keyboardHeight ==
                      0) // Only show when keyboard is not visible
                    Container(
                      width: double.infinity,
                      child: Image.asset(
                        'assets/images/wave.png',
                        fit: BoxFit.cover,
                        height: 120,
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

  void _handlePasswordReset() async {
    if (_formKey.currentState!.saveAndValidate()) {
      setState(() => isLoading = true);

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        SnackBarUtil.showSuccessSnackBar(
          context,
          'Password reset link has been sent to your email.',
        );

        // Show service limitation message after success
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            SnackBarUtil.showErrorSnackBar(
              context,
              'To activate this service, buy a plan',
            );
          }
        });
      }

      setState(() => isLoading = false);
    }
  }
}
