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

      print(response.user);

      if (response.user != null) {
        SharedPref.setUserId(response.user!.id);
        final userDoc = await _supabase
            .from('users')
            .select()
            .eq('id', response.user!.id)
            .single();
        return UserModel.fromMap(userDoc);
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

        await _supabase.from('users').insert(newUser.toMap());

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
      throw AuthException('Failed to sign up: ${e.toString()}');
    }
  }

  // Sign out method
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw AuthException('Failed to sign out: ${e.toString()}');
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
      throw AuthException('Failed to fetch user data: ${e.toString()}');
    }
  }

  // Update user data
  Future<void> updateUser(UserModel user) async {
    try {
      await _supabase.from('users').update(user.toMap()).eq('id', user.id);
    } catch (e) {
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
