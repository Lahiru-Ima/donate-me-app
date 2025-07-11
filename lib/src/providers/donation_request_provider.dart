import 'package:donate_me_app/src/models/request_models/donation_request_model.dart';
import 'package:flutter/material.dart';
import 'package:donate_me_app/src/models/request_models/blood_request_model.dart';
import 'package:donate_me_app/src/models/request_models/hair_request_model.dart';
import 'package:donate_me_app/src/models/request_models/kidney_request_model.dart';
import 'package:donate_me_app/src/models/request_models/fund_request_model.dart';
import 'package:donate_me_app/src/services/donation_request_service.dart';

class DonationRequestProvider extends ChangeNotifier {
  final DonationRequestService _service = DonationRequestService();
  
  final Map<String, List<DonationRequestModel>> _requestsByCategory = {};
  bool _isLoading = false;
  bool _isCreating = false;
  String? _error;
  String? _currentCategory;

  // Getters
  bool get isLoading => _isLoading;
  bool get isCreating => _isCreating;
  String? get error => _error;
  String? get currentCategory => _currentCategory;

  List<DonationRequestModel> getRequestsForCategory(String category) {
    return _requestsByCategory[category.toLowerCase()] ?? [];
  }

  List<DonationRequestModel> getUrgentRequests(String category) {
    return getRequestsForCategory(category)
        .where((req) => req.isUrgent)
        .toList();
  }

  List<DonationRequestModel> getCommunityRequests(String category) {
    return getRequestsForCategory(category)
        .where((req) => !req.isUrgent)
        .toList();
  }

  // ========== LOADING METHODS ==========

  Future<void> loadCategory(String category) async {
    if (_currentCategory == category && 
        _requestsByCategory.containsKey(category.toLowerCase()) &&
        !_isLoading) {
      return; // Already loaded and not currently loading
    }

    _isLoading = true;
    _error = null;
    _currentCategory = category;
    notifyListeners();

    try {
      final requests = await _loadRequestsForCategory(category);
      _requestsByCategory[category.toLowerCase()] = requests;
    } catch (e) {
      _error = 'Failed to load ${category.toLowerCase()} requests: ${e.toString()}';
      debugPrint('Error loading category $category: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<DonationRequestModel>> _loadRequestsForCategory(String category) async {
    switch (category.toLowerCase()) {
      case 'blood':
        final bloodRequests = await _service.getAllBloodRequests();
        return bloodRequests.map(_bloodToGeneric).toList();
      case 'hair':
        final hairRequests = await _service.getAllHairRequests();
        return hairRequests.map(_hairToGeneric).toList();
      case 'kidney':
        final kidneyRequests = await _service.getAllKidneyRequests();
        return kidneyRequests.map(_kidneyToGeneric).toList();
      case 'fund':
        final fundRequests = await _service.getAllFundRequests();
        return fundRequests.map(_fundToGeneric).toList();
      default:
        throw ArgumentError('Unknown category: $category');
    }
  }

  // ========== CREATION METHODS ==========

  /// Create a new blood donation request
  Future<bool> createBloodRequest(BloodRequestModel request) async {
    _isCreating = true;
    _error = null;
    notifyListeners();

    try {
      await _service.createBloodRequest(request);
      
      // Refresh the blood category data if it's currently loaded
      if (_requestsByCategory.containsKey('blood')) {
        await _refreshCategory('blood');
      }
      
      return true;
    } catch (e) {
      _error = 'Failed to create blood request: ${e.toString()}';
      debugPrint('Error creating blood request: $e');
      return false;
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }

  /// Create a new hair donation request
  Future<bool> createHairRequest(HairRequestModel request) async {
    _isCreating = true;
    _error = null;
    notifyListeners();

    try {
      await _service.createHairRequest(request);
      
      // Refresh the hair category data if it's currently loaded
      if (_requestsByCategory.containsKey('hair')) {
        await _refreshCategory('hair');
      }
      
      return true;
    } catch (e) {
      _error = 'Failed to create hair request: ${e.toString()}';
      debugPrint('Error creating hair request: $e');
      return false;
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }

  /// Create a new kidney donation request
  Future<bool> createKidneyRequest(KidneyRequestModel request) async {
    _isCreating = true;
    _error = null;
    notifyListeners();

    try {
      await _service.createKidneyRequest(request);
      
      // Refresh the kidney category data if it's currently loaded
      if (_requestsByCategory.containsKey('kidney')) {
        await _refreshCategory('kidney');
      }
      
      return true;
    } catch (e) {
      _error = 'Failed to create kidney request: ${e.toString()}';
      debugPrint('Error creating kidney request: $e');
      return false;
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }

  /// Create a new fund donation request
  Future<bool> createFundRequest(FundRequestModel request) async {
    _isCreating = true;
    _error = null;
    notifyListeners();

    try {
      await _service.createFundRequest(request);
      
      // Refresh the fund category data if it's currently loaded
      if (_requestsByCategory.containsKey('fund')) {
        await _refreshCategory('fund');
      }
      
      return true;
    } catch (e) {
      _error = 'Failed to create fund request: ${e.toString()}';
      debugPrint('Error creating fund request: $e');
      return false;
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }

  // ========== UPDATE METHODS ==========

  /// Update request status
  Future<bool> updateRequestStatus(String requestId, String status, String category) async {
    try {
      final tableName = _getTableName(category);
      await _service.updateRequestStatus(requestId, status, tableName);
      
      // Refresh the category data if it's currently loaded
      if (_requestsByCategory.containsKey(category.toLowerCase())) {
        await _refreshCategory(category);
      }
      
      return true;
    } catch (e) {
      _error = 'Failed to update request status: ${e.toString()}';
      debugPrint('Error updating request status: $e');
      notifyListeners();
      return false;
    }
  }

  /// Delete a request
  Future<bool> deleteRequest(String requestId, String category) async {
    try {
      final tableName = _getTableName(category);
      await _service.deleteRequest(requestId, tableName);
      
      // Refresh the category data if it's currently loaded
      if (_requestsByCategory.containsKey(category.toLowerCase())) {
        await _refreshCategory(category);
      }
      
      return true;
    } catch (e) {
      _error = 'Failed to delete request: ${e.toString()}';
      debugPrint('Error deleting request: $e');
      notifyListeners();
      return false;
    }
  }

  // ========== USER-SPECIFIC METHODS ==========

  /// Get requests created by a specific user
  Future<List<DonationRequestModel>> getUserRequests(String userId, String category) async {
    try {
      switch (category.toLowerCase()) {
        case 'blood':
          final bloodRequests = await _service.getBloodRequestsByUserId(userId);
          return bloodRequests.map(_bloodToGeneric).toList();
        case 'hair':
          final hairRequests = await _service.getHairRequestsByUserId(userId);
          return hairRequests.map(_hairToGeneric).toList();
        case 'kidney':
          final kidneyRequests = await _service.getKidneyRequestsByUserId(userId);
          return kidneyRequests.map(_kidneyToGeneric).toList();
        case 'fund':
          final fundRequests = await _service.getFundRequestsByUserId(userId);
          return fundRequests.map(_fundToGeneric).toList();
        default:
          throw ArgumentError('Unknown category: $category');
      }
    } catch (e) {
      _error = 'Failed to load user requests: ${e.toString()}';
      debugPrint('Error loading user requests: $e');
      notifyListeners();
      return [];
    }
  }

  /// Get all requests created by a specific user across all categories
  Future<Map<String, List<DonationRequestModel>>> getAllUserRequests(String userId) async {
    final Map<String, List<DonationRequestModel>> userRequests = {};
    
    try {
      // Load requests from all categories
      final categories = ['blood', 'hair', 'kidney', 'fund'];
      
      for (final category in categories) {
        userRequests[category] = await getUserRequests(userId, category);
      }
      
      return userRequests;
    } catch (e) {
      _error = 'Failed to load all user requests: ${e.toString()}';
      debugPrint('Error loading all user requests: $e');
      notifyListeners();
      return {};
    }
  }

  // ========== HELPER METHODS ==========

  String _getTableName(String category) {
    switch (category.toLowerCase()) {
      case 'blood':
        return 'blood_requests';
      case 'hair':
        return 'hair_requests';
      case 'kidney':
        return 'kidney_requests';
      case 'fund':
        return 'fund_requests';
      default:
        throw ArgumentError('Unknown category: $category');
    }
  }

  Future<void> _refreshCategory(String category) async {
    try {
      final requests = await _loadRequestsForCategory(category);
      _requestsByCategory[category.toLowerCase()] = requests;
      notifyListeners();
    } catch (e) {
      debugPrint('Error refreshing category $category: $e');
    }
  }

  // ========== CONVERSION METHODS ==========

  DonationRequestModel _bloodToGeneric(BloodRequestModel blood) {
    return DonationRequestModel(
      id: blood.id ?? '',
      title: blood.title,
      description: blood.description,
      location: blood.location,
      category: 'blood',
      isUrgent: blood.isEmergency || 
                blood.urgencyLevel.toLowerCase() == 'high' ||
                blood.urgencyLevel.toLowerCase() == 'critical',
      createdAt: blood.createdAt ?? DateTime.now(),
      additionalData: {
        'blood_group': blood.bloodGroup,
        'hospital': blood.hospital,
        'patient_name': blood.patientName,
        'patient_age': blood.patientAge,
        'units_needed': blood.unitsNeeded,
        'medical_condition': blood.medicalCondition,
        'doctor_name': blood.doctorName,
        'required_by_date': blood.requiredByDate.toIso8601String(),
        'contact_person': blood.contactPerson,
        'contact_phone': blood.contactPhone,
        'contact_email': blood.contactEmail,
        'is_emergency': blood.isEmergency,
        'urgency_level': blood.urgencyLevel,
        'status': blood.status,
      },
    );
  }

  DonationRequestModel _hairToGeneric(HairRequestModel hair) {
    return DonationRequestModel(
      id: hair.id ?? '',
      title: hair.title,
      description: hair.description,
      location: hair.location,
      category: 'hair',
      isUrgent: hair.urgencyLevel.toLowerCase() == 'high' ||
                hair.urgencyLevel.toLowerCase() == 'critical',
      createdAt: hair.createdAt ?? DateTime.now(),
      additionalData: {
        'organization': hair.organization,
        'hair_type': hair.hairType,
        'min_length': hair.minLength,
        'max_length': hair.maxLength,
        'hair_color': hair.hairColor,
        'purpose_category': hair.purposeCategory,
        'recipient_age': hair.recipientAge,
        'recipient_gender': hair.recipientGender,
        'medical_condition': hair.medicalCondition,
        'collection_method': hair.collectionMethod,
        'collection_location': hair.collectionLocation,
        'quantity_needed': hair.quantityNeeded,
        'contact_person': hair.contactPerson,
        'contact_phone': hair.contactPhone,
        'contact_email': hair.contactEmail,
        'urgency_level': hair.urgencyLevel,
        'status': hair.status,
      },
    );
  }

  DonationRequestModel _kidneyToGeneric(KidneyRequestModel kidney) {
    return DonationRequestModel(
      id: kidney.id ?? '',
      title: kidney.title,
      description: kidney.description,
      location: kidney.location,
      category: 'kidney',
      isUrgent: kidney.isEmergency || 
                kidney.urgencyLevel.toLowerCase() == 'high' ||
                kidney.urgencyLevel.toLowerCase() == 'critical',
      createdAt: kidney.createdAt ?? DateTime.now(),
      additionalData: {
        'hospital': kidney.hospital,
        'patient_name': kidney.patientName,
        'patient_age': kidney.patientAge,
        'kidney_failure_stage': kidney.kidneyFailureStage,
        'dialysis_frequency': kidney.dialysisFrequency,
        'blood_group': kidney.bloodGroup,
        'medical_condition': kidney.medicalCondition,
        'doctor_name': kidney.doctorName,
        'contact_person': kidney.contactPerson,
        'contact_phone': kidney.contactPhone,
        'contact_email': kidney.contactEmail,
        'is_emergency': kidney.isEmergency,
        'urgency_level': kidney.urgencyLevel,
        'status': kidney.status,
      },
    );
  }

  DonationRequestModel _fundToGeneric(FundRequestModel fund) {
    return DonationRequestModel(
      id: fund.id ?? '',
      title: fund.title,
      description: fund.description,
      location: '',
      category: 'fund',
      isUrgent: fund.urgencyLevel.toLowerCase() == 'high' ||
                fund.urgencyLevel.toLowerCase() == 'critical',
      createdAt: fund.createdAt ?? DateTime.now(),
      additionalData: {
        'request_type': fund.requestType,
        'purpose': fund.purpose,
        'urgency_level': fund.urgencyLevel,
        'status': fund.status,
      },
    );
  }

  // ========== UTILITY METHODS ==========

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> refresh() async {
    if (_currentCategory != null) {
      _requestsByCategory.remove(_currentCategory!.toLowerCase());
      await loadCategory(_currentCategory!);
    }
  }

  /// Clear all cached data
  void clearCache() {
    _requestsByCategory.clear();
    _currentCategory = null;
    _error = null;
    _isLoading = false;
    _isCreating = false;
    notifyListeners();
  }

  /// Force refresh a specific category
  Future<void> forceRefreshCategory(String category) async {
    _requestsByCategory.remove(category.toLowerCase());
    await loadCategory(category);
  }

  /// Check if a category is currently cached
  bool isCategoryCached(String category) {
    return _requestsByCategory.containsKey(category.toLowerCase());
  }

  /// Get total count of requests for a category
  int getCategoryRequestCount(String category) {
    return getRequestsForCategory(category).length;
  }

  /// Get urgent count for a category
  int getCategoryUrgentCount(String category) {
    return getUrgentRequests(category).length;
  }

  /// Get community count for a category
  int getCategoryCommunityCount(String category) {
    return getCommunityRequests(category).length;
  }
}