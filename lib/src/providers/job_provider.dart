import 'package:flutter/material.dart';
import 'package:donate_me_app/src/models/job_models/job_model.dart';
import 'package:donate_me_app/src/models/job_models/job_application_model.dart';
import 'package:donate_me_app/src/services/job_service.dart';

class JobProvider extends ChangeNotifier {
  final JobService _jobService = JobService();

  // ========== STATE VARIABLES ==========
  List<JobModel> _jobs = [];
  List<JobApplicationModel> _applications = [];
  bool _isLoading = false;
  String? _error;

  // Filter states
  String _selectedType = 'All';
  String _selectedLocation = 'All';
  bool _urgentOnly = false;
  String _searchKeyword = '';

  // ========== GETTERS ==========
  List<JobModel> get jobs => _jobs;
  List<JobApplicationModel> get applications => _applications;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedType => _selectedType;
  String get selectedLocation => _selectedLocation;
  bool get urgentOnly => _urgentOnly;
  String get searchKeyword => _searchKeyword;

  // ========== FILTER OPTIONS ==========
  List<String> get jobTypes => [
    'All',
    'Full-time (8 hours/day)',
    'Part-time (4 hours/day)',
    'Overnight (10pm - 6am)',
    'Flexible hours',
    'Weekend only',
    'Weekdays only',
  ];

  List<String> get locations => [
    'All',
    'Colombo',
    'Gampaha',
    'Kalutara',
    'Kandy',
    'Galle',
    'Matara',
    'Hambantota',
    'Jaffna',
    'Kilinochchi',
    'Mannar',
    'Vavuniya',
    'Mullaitivu',
    'Batticaloa',
    'Ampara',
    'Trincomalee',
    'Kurunegala',
    'Puttalam',
    'Anuradhapura',
    'Polonnaruwa',
    'Badulla',
    'Moneragala',
    'Ratnapura',
    'Kegalle',
    'Nuwara Eliya',
    'Remote',
  ];

  // ========== JOB MANAGEMENT ==========

  /// Create a new job posting
  Future<bool> createJob(JobModel job) async {
    _setLoading(true);
    try {
      await _jobService.createJob(job);
      await fetchJobs();
      _clearError();
      return true;
    } catch (e) {
      _setError('Failed to create job: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Fetch all jobs
  Future<void> fetchJobs() async {
    _setLoading(true);
    try {
      _jobs = await _jobService.getAllJobs();
      _clearError();
      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch jobs: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Get jobs with current filters
  Future<void> fetchFilteredJobs() async {
    _setLoading(true);
    try {
      if (_searchKeyword.isNotEmpty) {
        _jobs = await _jobService.searchJobs(_searchKeyword);
      } else {
        _jobs = await _jobService.getFilteredJobs(
          type: _selectedType != 'All' ? _selectedType : null,
          location: _selectedLocation != 'All' ? _selectedLocation : null,
          urgentOnly: _urgentOnly,
        );
      }
      _clearError();
      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch filtered jobs: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Get jobs by user ID (for employers)
  Future<void> fetchJobsByUserId(String userId) async {
    _setLoading(true);
    try {
      _jobs = await _jobService.getJobsByUserId(userId);
      _clearError();
      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch user jobs: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // ========== JOB APPLICATION MANAGEMENT ==========

  /// Submit job application
  Future<bool> submitJobApplication(JobApplicationModel application) async {
    _setLoading(true);
    try {
      await _jobService.submitJobApplication(application);
      _clearError();
      return true;
    } catch (e) {
      _setError('Failed to submit application: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Get applications for a job
  Future<void> fetchApplicationsForJob(String jobId) async {
    _setLoading(true);
    try {
      _applications = await _jobService.getApplicationsForJob(jobId);
      _clearError();
      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch applications: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Get applications by user ID
  Future<void> fetchApplicationsByUserId(String userId) async {
    _setLoading(true);
    try {
      _applications = await _jobService.getApplicationsByUserId(userId);
      _clearError();
      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch user applications: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // ========== FILTER MANAGEMENT ==========

  /// Set job type filter
  void setTypeFilter(String type) {
    _selectedType = type;
    notifyListeners();
    fetchFilteredJobs();
  }

  /// Set location filter
  void setLocationFilter(String location) {
    _selectedLocation = location;
    notifyListeners();
    fetchFilteredJobs();
  }

  /// Toggle urgent jobs filter
  void toggleUrgentFilter() {
    _urgentOnly = !_urgentOnly;
    notifyListeners();
    fetchFilteredJobs();
  }

  /// Set search keyword
  void setSearchKeyword(String keyword) {
    _searchKeyword = keyword;
    notifyListeners();
    if (keyword.isEmpty) {
      fetchFilteredJobs();
    }
  }

  /// Search jobs
  Future<void> searchJobs() async {
    if (_searchKeyword.isNotEmpty) {
      await fetchFilteredJobs();
    }
  }

  /// Clear all filters
  void clearFilters() {
    _selectedType = 'All';
    _selectedLocation = 'All';
    _urgentOnly = false;
    _searchKeyword = '';
    notifyListeners();
    fetchJobs();
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
    notifyListeners();
  }

  /// Clear all data (useful for logout)
  void clearData() {
    _jobs.clear();
    _applications.clear();
    _selectedType = 'All';
    _selectedLocation = 'All';
    _urgentOnly = false;
    _searchKeyword = '';
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
