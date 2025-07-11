import 'package:donate_me_app/src/models/job_models/job_model.dart';
import 'package:donate_me_app/src/models/job_models/job_application_model.dart';
import 'package:donate_me_app/src/services/database_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class JobService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ========== JOB MANAGEMENT ==========

  /// Create a new job posting
  Future<void> createJob(JobModel job) async {
    try {
      await _supabase.from('jobs').insert(job.toMap()).select().single();
    } catch (e) {
      throw DatabaseException.fromSupabaseException(e);
    }
  }

  /// Get all active jobs
  Future<List<JobModel>> getAllJobs() async {
    try {
      final response = await _supabase
          .from('jobs')
          .select()
          .eq('status', 'active')
          .order('created_at', ascending: false);

      return (response as List).map((item) => JobModel.fromMap(item)).toList();
    } catch (e) {
      throw DatabaseException.fromSupabaseException(e);
    }
  }

  /// Get jobs by type
  Future<List<JobModel>> getJobsByType(String type) async {
    try {
      final response = await _supabase
          .from('jobs')
          .select()
          .eq('status', 'active')
          .eq('type', type)
          .order('created_at', ascending: false);

      return (response as List).map((item) => JobModel.fromMap(item)).toList();
    } catch (e) {
      throw DatabaseException.fromSupabaseException(e);
    }
  }

  /// Get jobs by location
  Future<List<JobModel>> getJobsByLocation(String location) async {
    try {
      final response = await _supabase
          .from('jobs')
          .select()
          .eq('status', 'active')
          .eq('location', location)
          .order('created_at', ascending: false);

      return (response as List).map((item) => JobModel.fromMap(item)).toList();
    } catch (e) {
      throw DatabaseException.fromSupabaseException(e);
    }
  }

  /// Get jobs by type and location
  Future<List<JobModel>> getJobsByTypeAndLocation(
    String type,
    String location,
  ) async {
    try {
      final response = await _supabase
          .from('jobs')
          .select()
          .eq('status', 'active')
          .eq('type', type)
          .eq('location', location)
          .order('created_at', ascending: false);

      return (response as List).map((item) => JobModel.fromMap(item)).toList();
    } catch (e) {
      throw DatabaseException.fromSupabaseException(e);
    }
  }

  /// Get urgent jobs
  Future<List<JobModel>> getUrgentJobs() async {
    try {
      final response = await _supabase
          .from('jobs')
          .select()
          .eq('status', 'active')
          .eq('urgent_hiring', true)
          .order('created_at', ascending: false);

      return (response as List).map((item) => JobModel.fromMap(item)).toList();
    } catch (e) {
      throw DatabaseException.fromSupabaseException(e);
    }
  }

  /// Get jobs by user ID (for employers)
  Future<List<JobModel>> getJobsByUserId(String userId) async {
    try {
      final response = await _supabase
          .from('jobs')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List).map((item) => JobModel.fromMap(item)).toList();
    } catch (e) {
      throw DatabaseException.fromSupabaseException(e);
    }
  }

  /// Get job by ID
  Future<JobModel?> getJobById(String jobId) async {
    try {
      final response = await _supabase
          .from('jobs')
          .select()
          .eq('id', jobId)
          .single();

      return JobModel.fromMap(response);
    } catch (e) {
      throw DatabaseException.fromSupabaseException(e);
    }
  }

  /// Update job
  Future<void> updateJob(String jobId, Map<String, dynamic> updates) async {
    try {
      await _supabase.from('jobs').update(updates).eq('id', jobId);
    } catch (e) {
      throw DatabaseException.fromSupabaseException(e);
    }
  }

  /// Update job status
  Future<void> updateJobStatus(String jobId, String status) async {
    try {
      await _supabase
          .from('jobs')
          .update({
            'status': status,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', jobId);
    } catch (e) {
      throw DatabaseException.fromSupabaseException(e);
    }
  }

  /// Delete job
  Future<void> deleteJob(String jobId) async {
    try {
      await _supabase.from('jobs').delete().eq('id', jobId);
    } catch (e) {
      throw DatabaseException.fromSupabaseException(e);
    }
  }

  // ========== JOB APPLICATION MANAGEMENT ==========

  /// Submit job application
  Future<void> submitJobApplication(JobApplicationModel application) async {
    try {
      await _supabase
          .from('job_applications')
          .insert(application.toMap())
          .select()
          .single();
    } catch (e) {
      throw DatabaseException.fromSupabaseException(e);
    }
  }

  /// Get applications for a job
  Future<List<JobApplicationModel>> getApplicationsForJob(String jobId) async {
    try {
      final response = await _supabase
          .from('job_applications')
          .select()
          .eq('job_id', jobId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => JobApplicationModel.fromMap(item))
          .toList();
    } catch (e) {
      throw DatabaseException.fromSupabaseException(e);
    }
  }

  /// Get applications by user ID (for job seekers)
  Future<List<JobApplicationModel>> getApplicationsByUserId(
    String userId,
  ) async {
    try {
      final response = await _supabase
          .from('job_applications')
          .select()
          .eq('applicant_user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => JobApplicationModel.fromMap(item))
          .toList();
    } catch (e) {
      throw DatabaseException.fromSupabaseException(e);
    }
  }

  /// Update application status
  Future<void> updateApplicationStatus(
    String applicationId,
    String status,
  ) async {
    try {
      await _supabase
          .from('job_applications')
          .update({
            'status': status,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', applicationId);
    } catch (e) {
      throw DatabaseException.fromSupabaseException(e);
    }
  }

  /// Check if user has already applied for a job
  Future<bool> hasUserAppliedForJob(String userId, String jobId) async {
    try {
      final response = await _supabase
          .from('job_applications')
          .select('id')
          .eq('applicant_user_id', userId)
          .eq('job_id', jobId)
          .limit(1);

      return (response as List).isNotEmpty;
    } catch (e) {
      throw DatabaseException.fromSupabaseException(e);
    }
  }

  /// Get application by ID
  Future<JobApplicationModel?> getApplicationById(String applicationId) async {
    try {
      final response = await _supabase
          .from('job_applications')
          .select()
          .eq('id', applicationId)
          .single();

      return JobApplicationModel.fromMap(response);
    } catch (e) {
      throw DatabaseException.fromSupabaseException(e);
    }
  }

  // ========== SEARCH AND FILTER ==========

  /// Search jobs by keyword
  Future<List<JobModel>> searchJobs(String keyword) async {
    try {
      final response = await _supabase
          .from('jobs')
          .select()
          .eq('status', 'active')
          .or(
            'title.ilike.%$keyword%,description.ilike.%$keyword%,type.ilike.%$keyword%',
          )
          .order('created_at', ascending: false);

      return (response as List).map((item) => JobModel.fromMap(item)).toList();
    } catch (e) {
      throw DatabaseException.fromSupabaseException(e);
    }
  }

  /// Get filtered jobs
  Future<List<JobModel>> getFilteredJobs({
    String? type,
    String? location,
    bool? urgentOnly,
  }) async {
    try {
      var query = _supabase.from('jobs').select().eq('status', 'active');

      if (type != null && type != 'All') {
        query = query.eq('type', type);
      }

      if (location != null && location != 'All') {
        query = query.eq('location', location);
      }

      if (urgentOnly == true) {
        query = query.eq('urgent_hiring', true);
      }

      final response = await query.order('created_at', ascending: false);

      return (response as List).map((item) => JobModel.fromMap(item)).toList();
    } catch (e) {
      throw DatabaseException.fromSupabaseException(e);
    }
  }
}
