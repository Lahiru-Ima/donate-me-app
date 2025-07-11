import 'package:donate_me_app/src/models/blood_request_model.dart';
import 'package:donate_me_app/src/models/hair_request_model.dart';
import 'package:donate_me_app/src/models/kidney_request_model.dart';
import 'package:donate_me_app/src/models/fund_request_model.dart';
import 'package:donate_me_app/src/services/donation_request_service.dart';
import 'package:flutter/material.dart';

class DonationRequestProvider extends ChangeNotifier {
  final DonationRequestService _donationRequestService =
      DonationRequestService();

  // State variables for different types of requests
  List<BloodRequestModel> _bloodRequests = [];
  List<HairRequestModel> _hairRequests = [];
  List<KidneyRequestModel> _kidneyRequests = [];
  List<FundRequestModel> _fundRequests = [];

  bool _isLoading = false;
  bool _isCreating = false;
  String? _error;

  // Getters
  List<BloodRequestModel> get bloodRequests => _bloodRequests;
  List<HairRequestModel> get hairRequests => _hairRequests;
  List<KidneyRequestModel> get kidneyRequests => _kidneyRequests;
  List<FundRequestModel> get fundRequests => _fundRequests;
  bool get isLoading => _isLoading;
  bool get isCreating => _isCreating;
  String? get error => _error;

  // Get urgent requests (high/critical urgency) for current category
  List<dynamic> getUrgentRequestsByCategory(String? category) {
    if (category == null) return [];

    List<dynamic> urgent = [];

    switch (category.toLowerCase()) {
      case 'blood':
        urgent.addAll(
          _bloodRequests
              .where(
                (request) =>
                    request.urgencyLevel.toLowerCase() == 'high' ||
                    request.urgencyLevel.toLowerCase() == 'critical' ||
                    request.isEmergency,
              )
              .map((request) => _convertToDisplayModel(request, 'Blood')),
        );
        break;
      case 'hair':
        urgent.addAll(
          _hairRequests
              .where(
                (request) =>
                    request.urgencyLevel.toLowerCase() == 'high' ||
                    request.urgencyLevel.toLowerCase() == 'critical',
              )
              .map((request) => _convertToDisplayModel(request, 'Hair')),
        );
        break;
      case 'kidney':
        urgent.addAll(
          _kidneyRequests
              .where(
                (request) =>
                    request.urgencyLevel.toLowerCase() == 'high' ||
                    request.urgencyLevel.toLowerCase() == 'critical' ||
                    request.isEmergency,
              )
              .map((request) => _convertToDisplayModel(request, 'Kidney')),
        );
        break;
      case 'fund':
        urgent.addAll(
          _fundRequests
              .where(
                (request) =>
                    request.urgencyLevel.toLowerCase() == 'high' ||
                    request.urgencyLevel.toLowerCase() == 'critical',
              )
              .map((request) => _convertToDisplayModel(request, 'Fund')),
        );
        break;
    }

    return urgent;
  }

  // Get community requests (low/medium urgency) for current category
  List<dynamic> getCommunityRequestsByCategory(String? category) {
    if (category == null) return [];

    List<dynamic> community = [];

    switch (category.toLowerCase()) {
      case 'blood':
        community.addAll(
          _bloodRequests
              .where(
                (request) =>
                    request.urgencyLevel.toLowerCase() == 'low' ||
                    request.urgencyLevel.toLowerCase() == 'medium',
              )
              .map((request) => _convertToDisplayModel(request, 'Blood')),
        );
        break;
      case 'hair':
        community.addAll(
          _hairRequests
              .where(
                (request) =>
                    request.urgencyLevel.toLowerCase() == 'low' ||
                    request.urgencyLevel.toLowerCase() == 'medium',
              )
              .map((request) => _convertToDisplayModel(request, 'Hair')),
        );
        break;
      case 'kidney':
        community.addAll(
          _kidneyRequests
              .where(
                (request) =>
                    request.urgencyLevel.toLowerCase() == 'low' ||
                    request.urgencyLevel.toLowerCase() == 'medium',
              )
              .map((request) => _convertToDisplayModel(request, 'Kidney')),
        );
        break;
      case 'fund':
        community.addAll(
          _fundRequests
              .where(
                (request) =>
                    request.urgencyLevel.toLowerCase() == 'low' ||
                    request.urgencyLevel.toLowerCase() == 'medium',
              )
              .map((request) => _convertToDisplayModel(request, 'Fund')),
        );
        break;
    }

    return community;
  }

  // Keep the old methods for backward compatibility (showing all categories)
  List<dynamic> get urgentRequests {
    List<dynamic> urgent = [];

    // Add urgent blood requests
    urgent.addAll(
      _bloodRequests
          .where(
            (request) =>
                request.urgencyLevel.toLowerCase() == 'high' ||
                request.urgencyLevel.toLowerCase() == 'critical' ||
                request.isEmergency,
          )
          .map((request) => _convertToDisplayModel(request, 'Blood')),
    );

    // Add urgent hair requests
    urgent.addAll(
      _hairRequests
          .where(
            (request) =>
                request.urgencyLevel.toLowerCase() == 'high' ||
                request.urgencyLevel.toLowerCase() == 'critical',
          )
          .map((request) => _convertToDisplayModel(request, 'Hair')),
    );

    // Add urgent kidney requests
    urgent.addAll(
      _kidneyRequests
          .where(
            (request) =>
                request.urgencyLevel.toLowerCase() == 'high' ||
                request.urgencyLevel.toLowerCase() == 'critical' ||
                request.isEmergency,
          )
          .map((request) => _convertToDisplayModel(request, 'Kidney')),
    );

    // Add urgent fund requests
    urgent.addAll(
      _fundRequests
          .where(
            (request) =>
                request.urgencyLevel.toLowerCase() == 'high' ||
                request.urgencyLevel.toLowerCase() == 'critical',
          )
          .map((request) => _convertToDisplayModel(request, 'Fund')),
    );

    return urgent;
  }

  // Get community requests (normal urgency) for current category
  List<dynamic> get communityRequests {
    List<dynamic> community = [];

    // Add community blood requests
    community.addAll(
      _bloodRequests
          .where(
            (request) =>
                request.urgencyLevel.toLowerCase() == 'low' ||
                request.urgencyLevel.toLowerCase() == 'medium',
          )
          .map((request) => _convertToDisplayModel(request, 'Blood')),
    );

    // Add community hair requests
    community.addAll(
      _hairRequests
          .where(
            (request) =>
                request.urgencyLevel.toLowerCase() == 'low' ||
                request.urgencyLevel.toLowerCase() == 'medium',
          )
          .map((request) => _convertToDisplayModel(request, 'Hair')),
    );

    // Add community kidney requests
    community.addAll(
      _kidneyRequests
          .where(
            (request) =>
                request.urgencyLevel.toLowerCase() == 'low' ||
                request.urgencyLevel.toLowerCase() == 'medium',
          )
          .map((request) => _convertToDisplayModel(request, 'Kidney')),
    );

    // Add community fund requests
    community.addAll(
      _fundRequests
          .where(
            (request) =>
                request.urgencyLevel.toLowerCase() == 'low' ||
                request.urgencyLevel.toLowerCase() == 'medium',
          )
          .map((request) => _convertToDisplayModel(request, 'Fund')),
    );

    return community;
  }

  // Helper method to convert any request model to display format
  dynamic _convertToDisplayModel(dynamic request, String category) {
    bool isUrgent = false;

    if (category == 'Blood' && request is BloodRequestModel) {
      isUrgent =
          request.urgencyLevel.toLowerCase() == 'high' ||
          request.urgencyLevel.toLowerCase() == 'critical' ||
          request.isEmergency;
    } else if (category == 'Kidney' && request is KidneyRequestModel) {
      isUrgent =
          request.urgencyLevel.toLowerCase() == 'high' ||
          request.urgencyLevel.toLowerCase() == 'critical' ||
          request.isEmergency;
    } else if (category == 'Hair' && request is HairRequestModel) {
      isUrgent =
          request.urgencyLevel.toLowerCase() == 'high' ||
          request.urgencyLevel.toLowerCase() == 'critical';
    } else if (category == 'Fund' && request is FundRequestModel) {
      isUrgent =
          request.urgencyLevel.toLowerCase() == 'high' ||
          request.urgencyLevel.toLowerCase() == 'critical';
    }

    return {
      'type': request.title,
      'location': request.location,
      'description': request.description,
      'category': category,
      'isUrgent': isUrgent,
      'id': request.id,
      'status': request.status,
      'createdAt': request.createdAt,
    };
  }

  // ========== BLOOD REQUESTS ==========

  // Load all blood requests
  Future<void> loadAllBloodRequests() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _bloodRequests = await _donationRequestService.getAllBloodRequests();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create a new blood request
  Future<bool> createBloodRequest(BloodRequestModel request) async {
    _isCreating = true;
    _error = null;
    notifyListeners();

    try {
      await _donationRequestService.createBloodRequest(request);
      await loadAllBloodRequests(); // Refresh the list
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }

  // ========== HAIR REQUESTS ==========

  // Load all hair requests
  Future<void> loadAllHairRequests() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _hairRequests = await _donationRequestService.getAllHairRequests();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create a new hair request
  Future<bool> createHairRequest(HairRequestModel request) async {
    _isCreating = true;
    _error = null;
    notifyListeners();

    try {
      await _donationRequestService.createHairRequest(request);
      await loadAllHairRequests(); // Refresh the list
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }

  // ========== KIDNEY REQUESTS ==========

  // Load all kidney requests
  Future<void> loadAllKidneyRequests() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _kidneyRequests = await _donationRequestService.getAllKidneyRequests();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create a new kidney request
  Future<bool> createKidneyRequest(KidneyRequestModel request) async {
    _isCreating = true;
    _error = null;
    notifyListeners();

    try {
      await _donationRequestService.createKidneyRequest(request);
      await loadAllKidneyRequests(); // Refresh the list
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }

  // ========== FUND REQUESTS ==========

  // Load all fund requests
  Future<void> loadAllFundRequests() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _fundRequests = await _donationRequestService.getAllFundRequests();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create a new fund request
  Future<bool> createFundRequest(FundRequestModel request) async {
    _isCreating = true;
    _error = null;
    notifyListeners();

    try {
      await _donationRequestService.createFundRequest(request);
      await loadAllFundRequests(); // Refresh the list
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }

  // Load fund requests by type (medical or charity)
  Future<void> loadFundRequestsByType(String requestType) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _fundRequests = await _donationRequestService.getFundRequestsByType(
        requestType,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ========== GENERIC METHODS ==========

  // Load requests by category
  Future<void> loadRequestsByCategory(String category) async {
    switch (category.toLowerCase()) {
      case 'blood':
        await loadAllBloodRequests();
        break;
      case 'hair':
        await loadAllHairRequests();
        break;
      case 'kidney':
        await loadAllKidneyRequests();
        break;
      case 'fund':
      case 'medical':
      case 'charity':
        await loadAllFundRequests();
        break;
      default:
        _error = 'Unknown category: $category';
        notifyListeners();
    }
  }

  // Get requests by category as dynamic list
  List<dynamic> getRequestsByCategory(String category) {
    switch (category.toLowerCase()) {
      case 'blood':
        return _bloodRequests;
      case 'hair':
        return _hairRequests;
      case 'kidney':
        return _kidneyRequests;
      case 'fund':
      case 'medical':
      case 'charity':
        return _fundRequests;
      default:
        return [];
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
