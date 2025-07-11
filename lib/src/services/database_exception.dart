import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseException implements Exception {
  final String message;
  final String? code;
  final dynamic originalException;

  DatabaseException({required this.message, this.code, this.originalException});

  factory DatabaseException.fromSupabaseException(dynamic exception) {
    if (exception is PostgrestException) {
      return DatabaseException(
        message: exception.message,
        code: exception.code,
        originalException: exception,
      );
    } else if (exception is AuthException) {
      return DatabaseException(
        message: exception.message,
        code: null,
        originalException: exception,
      );
    } else {
      return DatabaseException(
        message: exception.toString(),
        code: null,
        originalException: exception,
      );
    }
  }

  @override
  String toString() {
    return 'DatabaseException: $message${code != null ? ' (Code: $code)' : ''}';
  }
}
