import 'package:donate_me_app/src/common_widgets/app_logo.dart';
import 'package:donate_me_app/src/common_widgets/snackbar_util.dart';
import 'package:donate_me_app/src/router/router_names.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../common_widgets/account_check.dart';
import '../../common_widgets/primary_button.dart';
import '../../common_widgets/text_input_field.dart';
import '../../constants/constants.dart';
import '../../providers/auth_provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;
  bool isPasswordVisible = true;
  bool isConfirmPasswordVisible = true;
  final _dobController = TextEditingController();
  String gender = 'female';

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
                  const SizedBox(height: 32),

                  // Logo Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Center(child: AppLogo()),
                  ),
                  const SizedBox(height: 24),

                  // Welcome Text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Join us to make a difference today',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Form Section
                  Expanded(
                    child: FormBuilder(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Full Name
                            const Text(
                              'Full Name',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextInputField(
                              name: "name",
                              labelText: 'Enter your full name',
                              keyboard: TextInputType.name,
                              validator: FormBuilderValidators.required(
                                errorText: "Full name is required",
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Email
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
                              labelText: 'Enter your email address',
                              keyboard: TextInputType.emailAddress,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "Email is required",
                                ),
                                FormBuilderValidators.email(
                                  errorText:
                                      "Please enter a valid email address",
                                ),
                              ]),
                            ),
                            const SizedBox(height: 20),

                            // Mobile Number
                            const Text(
                              'Mobile Number',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextInputField(
                              name: "phonenumber",
                              labelText: 'Enter your mobile number',
                              keyboard: TextInputType.phone,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "Mobile number is required",
                                ),
                                FormBuilderValidators.minLength(
                                  10,
                                  errorText:
                                      "Please enter a valid mobile number",
                                ),
                              ]),
                            ),
                            const SizedBox(height: 20),

                            // Date of Birth
                            const Text(
                              'Date of Birth',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            FormBuilderDateTimePicker(
                              name: 'date_of_birth',
                              controller: _dobController,
                              inputType: InputType.date,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                    width: 1,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey[300]!,
                                    width: 1,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: kPrimaryColor,
                                    width: 2,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 1,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                hintText: 'Select your date of birth',
                                hintStyle: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 16.0,
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                              ),
                              validator: FormBuilderValidators.required(
                                errorText: "Date of birth is required",
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Gender
                            const Text(
                              'Gender',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          gender = 'male';
                                        });
                                      },
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        child: Row(
                                          children: [
                                            Radio<String>(
                                              value: 'male',
                                              groupValue: gender,
                                              activeColor: kPrimaryColor,
                                              onChanged: (value) {
                                                setState(() {
                                                  gender = value.toString();
                                                });
                                              },
                                            ),
                                            const Text(
                                              'Male',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          gender = 'female';
                                        });
                                      },
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        child: Row(
                                          children: [
                                            Radio<String>(
                                              value: 'female',
                                              groupValue: gender,
                                              activeColor: kPrimaryColor,
                                              onChanged: (value) {
                                                setState(() {
                                                  gender = value.toString();
                                                });
                                              },
                                            ),
                                            const Text(
                                              'Female',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
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
                            const SizedBox(height: 20),

                            // Password
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
                              labelText: 'Create a password',
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
                              keyboard: TextInputType.visiblePassword,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "Password is required",
                                ),
                                FormBuilderValidators.minLength(
                                  6,
                                  errorText:
                                      "Password must be at least 6 characters",
                                ),
                              ]),
                            ),
                            const SizedBox(height: 20),

                            // Confirm Password
                            const Text(
                              'Confirm Password',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextInputField(
                              name: "confirmpassword",
                              labelText: 'Confirm your password',
                              obscureText: isConfirmPasswordVisible,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isConfirmPasswordVisible
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.grey[600],
                                ),
                                onPressed: () {
                                  setState(() {
                                    isConfirmPasswordVisible =
                                        !isConfirmPasswordVisible;
                                  });
                                },
                              ),
                              keyboard: TextInputType.visiblePassword,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "Please confirm your password",
                                ),
                                (val) {
                                  if (val !=
                                      _formKey
                                          .currentState
                                          ?.fields['password']
                                          ?.value) {
                                    return "Passwords do not match";
                                  }
                                  return null;
                                },
                              ]),
                            ),
                            const SizedBox(height: 32),

                            // Sign Up Button
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
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
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
                                      text: "Create Account",
                                      press: () {
                                        if (_formKey.currentState!
                                            .saveAndValidate()) {
                                          createAccount(context);
                                        }
                                      },
                                    ),
                            ),
                            const SizedBox(height: 24),

                            // Account Check
                            const Center(child: AccountCheck(login: false)),
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

  void createAccount(BuildContext context) async {
    if (mounted) setState(() => isLoading = true);

    final email = _formKey.currentState!.fields['email']!.value.trim();
    final password = _formKey.currentState!.fields['password']!.value.trim();
    final name = _formKey.currentState!.fields['name']!.value.trim();
    final phoneNumber = _formKey.currentState!.fields['phonenumber']!.value
        .trim();
    final dob = _dobController.text;
    final gender = this.gender;
    final authProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );

    try {
      await authProvider.signUp(
        name,
        phoneNumber,
        email,
        password,
        dob,
        gender,
      );
      SnackBarUtil.showSuccessSnackBar(context, 'Sign up successful');
      final user = authProvider.userModel;
      if (user != null) {
        context.push(RouterNames.signin);
      }
    } catch (e) {
      String errorMessage = 'An error occurred. Please try again.';
      if (e is AuthException) {
        errorMessage = e.message;
      } else {
        errorMessage = e.toString();
      }
      if (mounted) {
        SnackBarUtil.showErrorSnackBar(context, errorMessage);
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }
}
