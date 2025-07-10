// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Donate Me';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get createAccount => 'Create Account';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get fullName => 'Full Name';

  @override
  String get mobileNumber => 'Mobile Number';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get gender => 'Gender';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get enterYourEmail => 'Enter your email address';

  @override
  String get enterYourPassword => 'Enter your password';

  @override
  String get createAPassword => 'Create a password';

  @override
  String get confirmYourPassword => 'Confirm your password';

  @override
  String get enterYourFullName => 'Enter your full name';

  @override
  String get enterYourMobileNumber => 'Enter your mobile number';

  @override
  String get selectYourDateOfBirth => 'Select your date of birth';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get signInToContinue => 'Sign in to continue your journey of giving';

  @override
  String get joinUsToday => 'Join us to make a difference today';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get signUpHere => 'Sign up here';

  @override
  String get signInHere => 'Sign in here';

  @override
  String hiUser(String userName) {
    return 'Hi, $userName';
  }

  @override
  String get makeDifference => 'Make a difference today';

  @override
  String get categories => 'Categories';

  @override
  String get blood => 'Blood';

  @override
  String get hair => 'Hair';

  @override
  String get kidney => 'Kidney';

  @override
  String get fund => 'Fund';

  @override
  String get createRequest => 'Create Request';

  @override
  String get createBloodRequest => 'Create Blood Request';

  @override
  String get createHairRequest => 'Create Hair Request';

  @override
  String get createKidneyRequest => 'Create Kidney Request';

  @override
  String get createFundRequest => 'Create Fund Request';

  @override
  String get urgentRequests => 'Urgent Requests';

  @override
  String get communityRequests => 'Community Requests';

  @override
  String noRequestsAvailable(String category) {
    return 'No $category requests available';
  }

  @override
  String get createDonationRequest => 'Create Donation Request';

  @override
  String get requestBloodDonation => 'Request blood donation';

  @override
  String get requestHairDonation => 'Request hair donation';

  @override
  String get requestKidneyDonation => 'Request kidney donation';

  @override
  String get requestFinancialAssistance => 'Request financial assistance';

  @override
  String get cancel => 'Cancel';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get validEmailRequired => 'Please enter a valid email address';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get confirmPasswordRequired => 'Please confirm your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get fullNameRequired => 'Full name is required';

  @override
  String get mobileNumberRequired => 'Mobile number is required';

  @override
  String get validMobileNumber => 'Please enter a valid mobile number';

  @override
  String get dateOfBirthRequired => 'Date of birth is required';
}
