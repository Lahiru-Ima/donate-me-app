import 'package:donate_me_app/src/models/user_model.dart';
import 'package:donate_me_app/src/services/session_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Sign in method
  Future<UserModel?> signIn(String email, String password) async {
    try {
      final AuthResponse response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        SharedPref.setUserId(response.user!.id);

        try {
          final userDoc = await _supabase
              .from('users')
              .select()
              .eq('id', response.user!.id)
              .single();
          return UserModel.fromMap(userDoc);
        } catch (e) {
          // If user data doesn't exist in users table, create it
          if (e.toString().contains('relation "public.users" does not exist') ||
              e.toString().contains('No rows found')) {
            throw AuthException(
              'Database setup incomplete. Please contact support to set up the users table.',
            );
          }
          // For other database errors, still allow sign in but with limited user data
          return UserModel(
            id: response.user!.id,
            email: response.user!.email ?? email,
            name: response.user!.userMetadata?['name'] ?? 'User',
            phoneNumber: response.user!.userMetadata?['phone_number'] ?? '',
            dateOfBirth: response.user!.userMetadata?['date_of_birth'],
            gender: response.user!.userMetadata?['gender'],
          );
        }
      }
      return null;
    } on AuthException catch (error) {
      String errorMessage;
      switch (error.message.toLowerCase()) {
        case "invalid login credentials":
        case "invalid credentials":
          errorMessage = "Your email or password is incorrect.";
          break;
        case "email not confirmed":
          errorMessage = "Please confirm your email address.";
          break;
        case "too many requests":
          errorMessage = "Too many requests. Please try again later.";
          break;
        default:
          errorMessage = error.message;
      }
      throw AuthException(errorMessage);
    } catch (e) {
      if (e.toString().contains('relation "public.users" does not exist')) {
        throw AuthException(
          'Database setup incomplete. Please contact support to set up the database.',
        );
      }
      throw AuthException('Failed to sign in: ${e.toString()}');
    }
  }

  // Sign up method
  Future<UserModel?> signUp(
    String name,
    String phoneNumber,
    String email,
    String password,
    String dob,
    String gender,
  ) async {
    try {
      final AuthResponse response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
          'phone_number': phoneNumber,
          'date_of_birth': dob,
          'gender': gender,
        },
      );

      if (response.user != null) {
        UserModel newUser = UserModel(
          id: response.user!.id,
          name: name,
          email: email,
          phoneNumber: phoneNumber,
          dateOfBirth: dob,
          gender: gender,
        );

        // Note: The user record should be automatically created by the database trigger
        // We don't need to manually insert into users table as the trigger handles it

        // Wait a moment for the trigger to complete
        await Future.delayed(const Duration(milliseconds: 500));

        // Verify the user was created in the users table
        try {
          final userRecord = await _supabase
              .from('users')
              .select()
              .eq('id', response.user!.id)
              .single();

          print(
            'User successfully created with trigger: ${userRecord['email']}',
          );
        } catch (e) {
          print(
            'Warning: User may not have been created by trigger: ${e.toString()}',
          );

          // If trigger failed, try manual creation as fallback
          try {
            await _supabase.from('users').insert(newUser.toMap());
            print('User created manually as fallback');
          } catch (insertError) {
            if (insertError.toString().contains(
              'relation "public.users" does not exist',
            )) {
              print(
                'Users table does not exist. User created in auth but not in users table.',
              );
            } else {
              print('Failed to insert user data: ${insertError.toString()}');
            }
          }
        }

        return newUser;
      }
      return null;
    } on AuthException catch (error) {
      String errorMessage;
      switch (error.message.toLowerCase()) {
        case "user already registered":
          errorMessage = "Email already in use.";
          break;
        case "password should be at least 6 characters":
          errorMessage = "Password should be at least 6 characters.";
          break;
        case "signup is disabled":
          errorMessage = "Sign up is currently disabled.";
          break;
        default:
          errorMessage = error.message;
      }
      throw AuthException(errorMessage);
    } catch (e) {
      if (e.toString().contains('relation "public.users" does not exist')) {
        throw AuthException(
          'Database setup incomplete. Please contact support to set up the database.',
        );
      }
      throw AuthException('Failed to sign up: ${e.toString()}');
    }
  }

  // Sign out method
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      print('User signed out successfully');
    } catch (e) {
      print('Sign out error: ${e.toString()}');
      throw AuthException('Failed to sign out: ${e.toString()}');
    }
  }

  // Reset password method
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'your-app://reset-password', 
      );
    } catch (e) {
      throw AuthException(
        'Failed to send reset password email: ${e.toString()}',
      );
    }
  }

  // Fetch user role from Supabase
  Future<UserModel?> fetchUserModel(String userId) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single();
      return UserModel.fromMap(response);
    } catch (e) {
      if (e.toString().contains('relation "public.users" does not exist')) {
        throw AuthException(
          'Database setup incomplete. Please contact support to set up the database.',
        );
      }
      throw AuthException('Failed to fetch user data: ${e.toString()}');
    }
  }

  // Update user data
  Future<void> updateUser(UserModel user) async {
    try {
      await _supabase.from('users').update(user.toMap()).eq('id', user.id);
    } catch (e) {
      if (e.toString().contains('relation "public.users" does not exist')) {
        throw AuthException(
          'Database setup incomplete. Please contact support to set up the database.',
        );
      }
      throw AuthException('Failed to update user: ${e.toString()}');
    }
  }

  // Get current user
  User? get currentUser => _supabase.auth.currentUser;

  // Check if user is signed in
  bool get isSignedIn => _supabase.auth.currentUser != null;
}

class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() => message;
}
