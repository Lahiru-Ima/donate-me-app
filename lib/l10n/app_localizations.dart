import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_si.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('si'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Donate Me'**
  String get appTitle;

  /// Sign in button text
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Sign up button text
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Create account button text
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// Email label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Confirm password label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Full name label
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Mobile number label
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// Date of birth label
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// Gender label
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// Male gender option
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// Female gender option
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// Email input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get enterYourEmail;

  /// Password input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// Password creation placeholder
  ///
  /// In en, this message translates to:
  /// **'Create a password'**
  String get createAPassword;

  /// Password confirmation placeholder
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmYourPassword;

  /// Full name input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterYourFullName;

  /// Mobile number input placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number'**
  String get enterYourMobileNumber;

  /// Date of birth input placeholder
  ///
  /// In en, this message translates to:
  /// **'Select your date of birth'**
  String get selectYourDateOfBirth;

  /// Welcome back title
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// Sign in subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue your journey of giving'**
  String get signInToContinue;

  /// Sign up subtitle
  ///
  /// In en, this message translates to:
  /// **'Join us to make a difference today'**
  String get joinUsToday;

  /// Don't have account question
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// Already have account question
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// Sign up link text
  ///
  /// In en, this message translates to:
  /// **'Sign up here'**
  String get signUpHere;

  /// Sign in link text
  ///
  /// In en, this message translates to:
  /// **'Sign in here'**
  String get signInHere;

  /// Greeting message with user name
  ///
  /// In en, this message translates to:
  /// **'Hi, {userName}'**
  String hiUser(String userName);

  /// Home screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Make a difference today'**
  String get makeDifference;

  /// Categories section title
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// Blood category
  ///
  /// In en, this message translates to:
  /// **'Blood'**
  String get blood;

  /// Hair category
  ///
  /// In en, this message translates to:
  /// **'Hair'**
  String get hair;

  /// Kidney category
  ///
  /// In en, this message translates to:
  /// **'Kidney'**
  String get kidney;

  /// Fund category
  ///
  /// In en, this message translates to:
  /// **'Fund'**
  String get fund;

  /// Create request button text
  ///
  /// In en, this message translates to:
  /// **'Create Request'**
  String get createRequest;

  /// Create blood request button
  ///
  /// In en, this message translates to:
  /// **'Create Blood Request'**
  String get createBloodRequest;

  /// Create hair request button
  ///
  /// In en, this message translates to:
  /// **'Create Hair Request'**
  String get createHairRequest;

  /// Create kidney request button
  ///
  /// In en, this message translates to:
  /// **'Create Kidney Request'**
  String get createKidneyRequest;

  /// Create fund request button
  ///
  /// In en, this message translates to:
  /// **'Create Fund Request'**
  String get createFundRequest;

  /// Urgent requests section title
  ///
  /// In en, this message translates to:
  /// **'Urgent Requests'**
  String get urgentRequests;

  /// Community requests section title
  ///
  /// In en, this message translates to:
  /// **'Community Requests'**
  String get communityRequests;

  /// No requests available message
  ///
  /// In en, this message translates to:
  /// **'No {category} requests available'**
  String noRequestsAvailable(String category);

  /// Create donation request dialog title
  ///
  /// In en, this message translates to:
  /// **'Create Donation Request'**
  String get createDonationRequest;

  /// Request blood donation subtitle
  ///
  /// In en, this message translates to:
  /// **'Request blood donation'**
  String get requestBloodDonation;

  /// Request hair donation subtitle
  ///
  /// In en, this message translates to:
  /// **'Request hair donation'**
  String get requestHairDonation;

  /// Request kidney donation subtitle
  ///
  /// In en, this message translates to:
  /// **'Request kidney donation'**
  String get requestKidneyDonation;

  /// Request financial assistance subtitle
  ///
  /// In en, this message translates to:
  /// **'Request financial assistance'**
  String get requestFinancialAssistance;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Email required validation message
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// Valid email required validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get validEmailRequired;

  /// Password required validation message
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// Password minimum length validation message
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// Confirm password required validation message
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get confirmPasswordRequired;

  /// Passwords do not match validation message
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Full name required validation message
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get fullNameRequired;

  /// Mobile number required validation message
  ///
  /// In en, this message translates to:
  /// **'Mobile number is required'**
  String get mobileNumberRequired;

  /// Valid mobile number validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid mobile number'**
  String get validMobileNumber;

  /// Date of birth required validation message
  ///
  /// In en, this message translates to:
  /// **'Date of birth is required'**
  String get dateOfBirthRequired;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'si'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'si':
      return AppLocalizationsSi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
