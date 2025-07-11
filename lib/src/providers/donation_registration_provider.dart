import 'package:flutter/foundation.dart';
import '../models/donation_models/donation_registration_model.dart';
import '../services/donation_registration_service.dart';

class DonationRegistrationProvider with ChangeNotifier {
  final DonationRegistrationService _service = DonationRegistrationService();

  List<DonationRegistrationModel> _registrations = [];
  List<DonationRegistrationModel> _userRegistrations = [];
  bool _isLoading = false;
  String? _error;
  Map<String, int> _statusCounts = {};

  // Getters
  List<DonationRegistrationModel> get registrations => _registrations;
  List<DonationRegistrationModel> get userRegistrations => _userRegistrations;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, int> get statusCounts => _statusCounts;

  // Create a new donation registration
  Future<bool> createDonationRegistration(
    DonationRegistrationModel registration,
  ) async {
    try {
      _setLoading(true);
      _clearError();

      final result = await _service.createDonationRegistration(registration);

      if (result != null) {
        _registrations.insert(0, result);
        _userRegistrations.insert(0, result);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError('Failed to create donation registration: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Fetch registrations by user ID
  Future<void> fetchUserRegistrations(String userId) async {
    try {
      _setLoading(true);
      _clearError();

      final registrations = await _service.getDonationRegistrationsByUserId(
        userId,
      );
      _userRegistrations = registrations;
      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch user registrations: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Fetch registrations by request ID
  Future<void> fetchRegistrationsByRequestId(String requestId) async {
    try {
      _setLoading(true);
      _clearError();

      final registrations = await _service.getDonationRegistrationsByRequestId(
        requestId,
      );
      _registrations = registrations;
      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch registrations by request ID: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Fetch registrations by category
  Future<void> fetchRegistrationsByCategory(String category) async {
    try {
      _setLoading(true);
      _clearError();

      final registrations = await _service.getDonationRegistrationsByCategory(
        category,
      );
      _registrations = registrations;
      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch registrations by category: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Fetch registrations by status
  Future<void> fetchRegistrationsByStatus(String status) async {
    try {
      _setLoading(true);
      _clearError();

      final registrations = await _service.getDonationRegistrationsByStatus(
        status,
      );
      _registrations = registrations;
      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch registrations by status: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Update registration status
  Future<bool> updateRegistrationStatus(
    String registrationId,
    String newStatus,
  ) async {
    try {
      _setLoading(true);
      _clearError();

      final updatedRegistration = await _service
          .updateDonationRegistrationStatus(registrationId, newStatus);

      if (updatedRegistration != null) {
        _updateRegistrationInLists(updatedRegistration);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError('Failed to update registration status: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update scheduled date
  Future<bool> updateScheduledDate(
    String registrationId,
    DateTime scheduledDate,
  ) async {
    try {
      _setLoading(true);
      _clearError();

      final updatedRegistration = await _service.updateScheduledDate(
        registrationId,
        scheduledDate,
      );

      if (updatedRegistration != null) {
        _updateRegistrationInLists(updatedRegistration);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError('Failed to update scheduled date: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete registration
  Future<bool> deleteRegistration(String registrationId) async {
    try {
      _setLoading(true);
      _clearError();

      final success = await _service.deleteDonationRegistration(registrationId);

      if (success) {
        _registrations.removeWhere((reg) => reg.id == registrationId);
        _userRegistrations.removeWhere((reg) => reg.id == registrationId);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError('Failed to delete registration: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Fetch all registrations (for admin)
  Future<void> fetchAllRegistrations() async {
    try {
      _setLoading(true);
      _clearError();

      final registrations = await _service.getAllDonationRegistrations();
      _registrations = registrations;
      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch all registrations: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Search registrations
  Future<void> searchRegistrations(String searchTerm) async {
    try {
      _setLoading(true);
      _clearError();

      final registrations = await _service.searchDonationRegistrations(
        searchTerm,
      );
      _registrations = registrations;
      notifyListeners();
    } catch (e) {
      _setError('Failed to search registrations: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Fetch status counts
  Future<void> fetchStatusCounts() async {
    try {
      final counts = await _service.getRegistrationCountsByStatus();
      _statusCounts = counts;
      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch status counts: $e');
    }
  }

  // Get registration by ID
  Future<DonationRegistrationModel?> getRegistrationById(
    String registrationId,
  ) async {
    try {
      _setLoading(true);
      _clearError();

      return await _service.getDonationRegistrationById(registrationId);
    } catch (e) {
      _setError('Failed to fetch registration: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Filter registrations by category
  List<DonationRegistrationModel> getRegistrationsByCategory(String category) {
    return _registrations.where((reg) => reg.category == category).toList();
  }

  // Filter registrations by status
  List<DonationRegistrationModel> getRegistrationsByStatus(String status) {
    return _registrations.where((reg) => reg.status == status).toList();
  }

  // Get pending registrations count
  int get pendingRegistrationsCount {
    return _registrations.where((reg) => reg.isPending).length;
  }

  // Get approved registrations count
  int get approvedRegistrationsCount {
    return _registrations.where((reg) => reg.isApproved).length;
  }

  // Helper methods
  void _updateRegistrationInLists(
    DonationRegistrationModel updatedRegistration,
  ) {
    final index = _registrations.indexWhere(
      (reg) => reg.id == updatedRegistration.id,
    );
    if (index != -1) {
      _registrations[index] = updatedRegistration;
    }

    final userIndex = _userRegistrations.indexWhere(
      (reg) => reg.id == updatedRegistration.id,
    );
    if (userIndex != -1) {
      _userRegistrations[userIndex] = updatedRegistration;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  // Clear all data
  void clear() {
    _registrations.clear();
    _userRegistrations.clear();
    _statusCounts.clear();
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}
