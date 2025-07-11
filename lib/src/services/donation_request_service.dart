import 'package:donate_me_app/src/models/request_models/blood_request_model.dart';
import 'package:donate_me_app/src/models/request_models/hair_request_model.dart';
import 'package:donate_me_app/src/models/request_models/kidney_request_model.dart';
import 'package:donate_me_app/src/models/request_models/fund_request_model.dart';
import 'package:donate_me_app/src/services/database_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DonationRequestService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ========== BLOOD REQUESTS ==========

  // Create a new blood donation request
  Future<void> createBloodRequest(BloodRequestModel request) async {
    try {
      await _supabase
          .from('blood_requests')
          .insert(request.toMap())
          .select()
          .single();
    } catch (e) {
      throw DatabaseException.fromSupabaseException(e);
    }
  }

  // Get all blood requests
  Future<List<BloodRequestModel>> getAllBloodRequests() async {
    try {
      final response = await _supabase
          .from('blood_requests')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => BloodRequestModel.fromMap(item))
          .toList();
    } catch (e) {
      throw DatabaseException.fromSupabaseException(e);
    }
  }

  // Get blood requests by user ID
  Future<List<BloodRequestModel>> getBloodRequestsByUserId(
    String userId,
  ) async {
    try {
      final response = await _supabase
          .from('blood_requests')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => BloodRequestModel.fromMap(item))
          .toList();
    } catch (e) {
      throw DatabaseException.fromSupabaseException(e);
    }
  }

  // ========== HAIR REQUESTS ==========

  // Create a new hair donation request
  Future<void> createHairRequest(HairRequestModel request) async {
    try {
      await _supabase
          .from('hair_requests')
          .insert(request.toMap())
          .select()
          .single();
    } catch (e) {
      throw DatabaseException.fromSupabaseException(e);
    }
  }

  // Get all hair requests
  Future<List<HairRequestModel>> getAllHairRequests() async {
    try {
      final response = await _supabase
          .from('hair_requests')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => HairRequestModel.fromMap(item))
          .toList();
    } catch (e) {
      throw DatabaseException.fromSupabaseException(e);
    }
  }

  // Get hair requests by user ID
  Future<List<HairRequestModel>> getHairRequestsByUserId(String userId) async {
    try {
      final response = await _supabase
          .from('hair_requests')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => HairRequestModel.fromMap(item))
          .toList();
    } catch (e) {
      throw DatabaseException.fromSupabaseException(e);
    }
  }

  // ========== KIDNEY REQUESTS ==========

  // Create a new kidney donation request
  Future<void> createKidneyRequest(KidneyRequestModel request) async {
    try {
      await _supabase
          .from('kidney_requests')
          .insert(request.toMap())
          .select()
          .single();
    } catch (e) {
      throw DatabaseException.fromSupabaseException(e);
    }
  }

  // Get all kidney requests
  Future<List<KidneyRequestModel>> getAllKidneyRequests() async {
    try {
      final response = await _supabase
          .from('kidney_requests')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => KidneyRequestModel.fromMap(item))
          .toList();
    } catch (e) {
      throw DatabaseException.fromSupabaseException(e);
    }
  }

  // Get kidney requests by user ID
  Future<List<KidneyRequestModel>> getKidneyRequestsByUserId(
    String userId,
  ) async {
    try {
      final response = await _supabase
          .from('kidney_requests')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => KidneyRequestModel.fromMap(item))
          .toList();
    } catch (e) {
      throw DatabaseException.fromSupabaseException(e);
    }
  }

  // ========== FUND REQUESTS ==========

  // Create a new fund donation request
  Future<void> createFundRequest(FundRequestModel request) async {
    try {
      await _supabase
          .from('fund_requests')
          .insert(request.toMap())
          .select()
          .single();
    } catch (e) {
      throw DatabaseException.fromSupabaseException(e);
    }
  }

  // Get all fund requests
  Future<List<FundRequestModel>> getAllFundRequests() async {
    try {
      final response = await _supabase
          .from('fund_requests')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => FundRequestModel.fromMap(item))
          .toList();
    } catch (e) {
      throw DatabaseException.fromSupabaseException(e);
    }
  }

  // Get fund requests by user ID
  Future<List<FundRequestModel>> getFundRequestsByUserId(String userId) async {
    try {
      final response = await _supabase
          .from('fund_requests')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => FundRequestModel.fromMap(item))
          .toList();
    } catch (e) {
      throw DatabaseException.fromSupabaseException(e);
    }
  }

  // Get fund requests by type (medical or charity)
  Future<List<FundRequestModel>> getFundRequestsByType(
    String requestType,
  ) async {
    try {
      final response = await _supabase
          .from('fund_requests')
          .select()
          .eq('request_type', requestType)
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => FundRequestModel.fromMap(item))
          .toList();
    } catch (e) {
      throw DatabaseException.fromSupabaseException(e);
    }
  }

  // ========== GENERIC METHODS ==========

  // Get requests by category type
  Future<List<dynamic>> getRequestsByCategory(String category) async {
    switch (category.toLowerCase()) {
      case 'blood':
        return await getAllBloodRequests();
      case 'hair':
        return await getAllHairRequests();
      case 'kidney':
        return await getAllKidneyRequests();
      case 'fund':
      case 'medical':
      case 'charity':
        return await getAllFundRequests();
      default:
        throw ArgumentError('Unknown category: $category');
    }
  }

  // Update request status (works for all types)
  Future<void> updateRequestStatus(
    String requestId,
    String status,
    String tableName,
  ) async {
    try {
      await _supabase
          .from(tableName)
          .update({
            'status': status,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', requestId);
    } catch (e) {
      throw DatabaseException.fromSupabaseException(e);
    }
  }

  // Delete request (works for all types)
  Future<void> deleteRequest(String requestId, String tableName) async {
    try {
      await _supabase.from(tableName).delete().eq('id', requestId);
    } catch (e) {
      throw DatabaseException.fromSupabaseException(e);
    }
  }
}
