import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/donation_models/donation_registration_model.dart';

class DonationRegistrationService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Create a new donation registration
  Future<DonationRegistrationModel?> createDonationRegistration(
    DonationRegistrationModel registration,
  ) async {
    try {
      final response = await _supabase
          .from('donation_registrations')
          .insert(registration.toMap())
          .select()
          .single();

      return DonationRegistrationModel.fromMap(response);
    } catch (e) {
      print('Error creating donation registration: $e');
      return null;
    }
  }

  // Get donation registrations by donor user ID
  Future<List<DonationRegistrationModel>> getDonationRegistrationsByUserId(
    String userId,
  ) async {
    try {
      final response = await _supabase
          .from('donation_registrations')
          .select()
          .eq('donor_user_id', userId)
          .order('created_at', ascending: false);

      return response
          .map((data) => DonationRegistrationModel.fromMap(data))
          .toList();
    } catch (e) {
      print('Error fetching donation registrations: $e');
      return [];
    }
  }

  // Get donation registrations by donation request ID
  Future<List<DonationRegistrationModel>> getDonationRegistrationsByRequestId(
    String requestId,
  ) async {
    try {
      final response = await _supabase
          .from('donation_registrations')
          .select()
          .eq('donation_request_id', requestId)
          .order('created_at', ascending: false);

      return response
          .map((data) => DonationRegistrationModel.fromMap(data))
          .toList();
    } catch (e) {
      print('Error fetching donation registrations by request ID: $e');
      return [];
    }
  }

  // Get donation registrations by category
  Future<List<DonationRegistrationModel>> getDonationRegistrationsByCategory(
    String category,
  ) async {
    try {
      final response = await _supabase
          .from('donation_registrations')
          .select()
          .eq('category', category)
          .order('created_at', ascending: false);

      return response
          .map((data) => DonationRegistrationModel.fromMap(data))
          .toList();
    } catch (e) {
      print('Error fetching donation registrations by category: $e');
      return [];
    }
  }

  // Get donation registrations by status
  Future<List<DonationRegistrationModel>> getDonationRegistrationsByStatus(
    String status,
  ) async {
    try {
      final response = await _supabase
          .from('donation_registrations')
          .select()
          .eq('status', status)
          .order('created_at', ascending: false);

      return response
          .map((data) => DonationRegistrationModel.fromMap(data))
          .toList();
    } catch (e) {
      print('Error fetching donation registrations by status: $e');
      return [];
    }
  }

  // Update donation registration status
  Future<DonationRegistrationModel?> updateDonationRegistrationStatus(
    String registrationId,
    String newStatus,
  ) async {
    try {
      final response = await _supabase
          .from('donation_registrations')
          .update({
            'status': newStatus,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', registrationId)
          .select()
          .single();

      return DonationRegistrationModel.fromMap(response);
    } catch (e) {
      print('Error updating donation registration status: $e');
      return null;
    }
  }

  // Update scheduled date
  Future<DonationRegistrationModel?> updateScheduledDate(
    String registrationId,
    DateTime scheduledDate,
  ) async {
    try {
      final response = await _supabase
          .from('donation_registrations')
          .update({
            'scheduled_date': scheduledDate.toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', registrationId)
          .select()
          .single();

      return DonationRegistrationModel.fromMap(response);
    } catch (e) {
      print('Error updating scheduled date: $e');
      return null;
    }
  }

  // Delete donation registration
  Future<bool> deleteDonationRegistration(String registrationId) async {
    try {
      await _supabase
          .from('donation_registrations')
          .delete()
          .eq('id', registrationId);
      return true;
    } catch (e) {
      print('Error deleting donation registration: $e');
      return false;
    }
  }

  // Get a single donation registration by ID
  Future<DonationRegistrationModel?> getDonationRegistrationById(
    String registrationId,
  ) async {
    try {
      final response = await _supabase
          .from('donation_registrations')
          .select()
          .eq('id', registrationId)
          .single();

      return DonationRegistrationModel.fromMap(response);
    } catch (e) {
      print('Error fetching donation registration by ID: $e');
      return null;
    }
  }

  // Get all donation registrations (for admin)
  Future<List<DonationRegistrationModel>> getAllDonationRegistrations() async {
    try {
      final response = await _supabase
          .from('donation_registrations')
          .select()
          .order('created_at', ascending: false);

      return response
          .map((data) => DonationRegistrationModel.fromMap(data))
          .toList();
    } catch (e) {
      print('Error fetching all donation registrations: $e');
      return [];
    }
  }

  // Search donation registrations
  Future<List<DonationRegistrationModel>> searchDonationRegistrations(
    String searchTerm,
  ) async {
    try {
      final response = await _supabase
          .from('donation_registrations')
          .select()
          .or(
            'full_name.ilike.%$searchTerm%,email.ilike.%$searchTerm%,phone.ilike.%$searchTerm%,nic.ilike.%$searchTerm%',
          )
          .order('created_at', ascending: false);

      return response
          .map((data) => DonationRegistrationModel.fromMap(data))
          .toList();
    } catch (e) {
      print('Error searching donation registrations: $e');
      return [];
    }
  }

  // Count registrations by status
  Future<Map<String, int>> getRegistrationCountsByStatus() async {
    try {
      final pendingCount = await _supabase
          .from('donation_registrations')
          .select()
          .eq('status', 'pending');

      final approvedCount = await _supabase
          .from('donation_registrations')
          .select()
          .eq('status', 'approved');

      final rejectedCount = await _supabase
          .from('donation_registrations')
          .select()
          .eq('status', 'rejected');

      final completedCount = await _supabase
          .from('donation_registrations')
          .select()
          .eq('status', 'completed');

      return {
        'pending': pendingCount.length,
        'approved': approvedCount.length,
        'rejected': rejectedCount.length,
        'completed': completedCount.length,
      };
    } catch (e) {
      print('Error getting registration counts: $e');
      return {'pending': 0, 'approved': 0, 'rejected': 0, 'completed': 0};
    }
  }
}
