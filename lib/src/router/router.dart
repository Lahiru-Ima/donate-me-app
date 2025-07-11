import 'package:donate_me_app/src/common_widgets/error_404_screen.dart';
import 'package:donate_me_app/src/features/authentication/forgot_password_screen.dart';
import 'package:donate_me_app/src/features/authentication/sign_in_screen.dart';
import 'package:donate_me_app/src/features/authentication/sign_up_screen.dart';
import 'package:donate_me_app/src/features/home/home_screen.dart';
import 'package:donate_me_app/src/features/home/donation_details_screen.dart';
import 'package:donate_me_app/src/features/donation/blood_donation_form_screen.dart';
import 'package:donate_me_app/src/features/donation/kidney_donation_form_screen.dart';
import 'package:donate_me_app/src/features/donation/hair_donation_form_screen.dart';
import 'package:donate_me_app/src/features/donation/fund_donation_form_screen.dart';
import 'package:donate_me_app/src/features/create_post/create_blood_post_screen.dart';
import 'package:donate_me_app/src/features/create_post/create_hair_post_screen.dart';
import 'package:donate_me_app/src/features/create_post/create_kidney_post_screen.dart';
import 'package:donate_me_app/src/features/create_post/create_fund_post_screen.dart';
import 'package:donate_me_app/src/features/wishlist/wishlist_screen.dart';
import 'package:donate_me_app/src/features/schedule/schedule_screen.dart';
import 'package:donate_me_app/src/features/jobs/job_screen.dart';
import 'package:donate_me_app/src/features/jobs/post_job_screen.dart';
import 'package:donate_me_app/src/features/jobs/job_application_screen.dart';
import 'package:donate_me_app/src/features/profile/profile_screen.dart';
import 'package:donate_me_app/src/features/profile/edit_profile_screen.dart';
import 'package:donate_me_app/src/features/settings/settings_screen.dart';
import 'package:donate_me_app/src/features/splash/splash_screen.dart';
import 'package:donate_me_app/src/router/router_names.dart';
import 'package:donate_me_app/src/router/shell_navigation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:donate_me_app/src/models/job_models/job_model.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

class RouterClass {
  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    errorPageBuilder: (context, state) {
      return const MaterialPage(child: Error404Screen());
    },
    initialLocation: RouterNames.splash,
    routes: [
      // Authentication and Splash routes
      GoRoute(
        path: RouterNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouterNames.signin,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: RouterNames.signup,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: RouterNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: RouterNames.donationDetails,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return DonationDetailsScreen(requestData: extra ?? {});
        },
      ),
      GoRoute(
        path: RouterNames.bloodDonation,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return BloodDonationFormScreen(
            donationRequestId: extra?['id'] ?? '',
            type: extra?['type'] ?? 'Blood',
            location: extra?['location'] ?? '',
            description: extra?['description'] ?? '',
          );
        },
      ),
      GoRoute(
        path: RouterNames.kidneyDonation,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return KidneyDonationFormScreen(
            donationRequestId: extra?['id'] ?? '',
            type: extra?['type'] ?? 'Kidney',
            location: extra?['location'] ?? '',
            description: extra?['description'] ?? '',
          );
        },
      ),
      GoRoute(
        path: RouterNames.hairDonation,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return HairDonationFormScreen(
            donationRequestId: extra?['id'] ?? '',
            type: extra?['type'] ?? 'Hair',
            location: extra?['location'] ?? '',
            description: extra?['description'] ?? '',
          );
        },
      ),
      GoRoute(
        path: RouterNames.fundDonation,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return FundDonationFormScreen(
            donationRequestId: extra?['id'] ?? '',
            type: extra?['type'] ?? 'Fund',
            location: extra?['location'] ?? '',
            description: extra?['description'] ?? '',
          );
        },
      ),
      GoRoute(
        path: RouterNames.createBloodPost,
        builder: (context, state) => const CreateBloodPostScreen(),
      ),
      GoRoute(
        path: RouterNames.createHairPost,
        builder: (context, state) => const CreateHairPostScreen(),
      ),
      GoRoute(
        path: RouterNames.createKidneyPost,
        builder: (context, state) => const CreateKidneyPostScreen(),
      ),
      GoRoute(
        path: RouterNames.createFundPost,
        builder: (context, state) => const CreateFundPostScreen(),
      ),
      GoRoute(
        path: RouterNames.postJob,
        builder: (context, state) => const PostJobScreen(),
      ),
      GoRoute(
        path: RouterNames.jobApplication,
        builder: (context, state) {
          final job = state.extra as JobModel?;
          return JobApplicationScreen(job: job);
        },
      ),
      GoRoute(
        path: RouterNames.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: RouterNames.settings,
        builder: (context, state) => const SettingsScreen(),
      ),

      // Shell navigation for main app
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return ShellNavigation(child: child);
        },
        routes: [
          GoRoute(
            path: RouterNames.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: RouterNames.wishlist,
            builder: (context, state) => const WishlistScreen(),
          ),
          GoRoute(
            path: RouterNames.schedule,
            builder: (context, state) => const ScheduleScreen(),
          ),
          GoRoute(
            path: RouterNames.jobs,
            builder: (context, state) => const JobScreen(),
          ),
          GoRoute(
            path: RouterNames.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
}
