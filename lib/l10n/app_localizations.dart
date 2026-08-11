import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ur.dart';

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
    Locale('ur'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Kinetik - BMI Calculator'**
  String get appTitle;

  /// No description provided for @bmiCalculator.
  ///
  /// In en, this message translates to:
  /// **'BMI Calculator'**
  String get bmiCalculator;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fill in the details below to get started'**
  String get createAccountSubtitle;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Don\'t worry, enter your email below to receive a secure password reset link.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @confirmPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the reset code sent to your email and choose your new password.'**
  String get confirmPasswordSubtitle;

  /// No description provided for @resetCode.
  ///
  /// In en, this message translates to:
  /// **'Reset Code'**
  String get resetCode;

  /// No description provided for @resetCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Paste the code from the email link'**
  String get resetCodeHint;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get orContinueWith;

  /// No description provided for @loginSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccessful;

  /// No description provided for @signupSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully!'**
  String get signupSuccessful;

  /// No description provided for @passwordResetSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent to your email!'**
  String get passwordResetSent;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully! You can now log in.'**
  String get passwordResetSuccess;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get invalidEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @enterValidName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get enterValidName;

  /// No description provided for @nameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get nameTooShort;

  /// No description provided for @enterValidAge.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid age'**
  String get enterValidAge;

  /// No description provided for @selectGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get selectGender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @cm.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get cm;

  /// No description provided for @ft.
  ///
  /// In en, this message translates to:
  /// **'ft'**
  String get ft;

  /// No description provided for @kg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get kg;

  /// No description provided for @lbs.
  ///
  /// In en, this message translates to:
  /// **'lbs'**
  String get lbs;

  /// No description provided for @calculateBmi.
  ///
  /// In en, this message translates to:
  /// **'Calculate BMI'**
  String get calculateBmi;

  /// No description provided for @yourBmi.
  ///
  /// In en, this message translates to:
  /// **'Your BMI'**
  String get yourBmi;

  /// No description provided for @yourBmiIs.
  ///
  /// In en, this message translates to:
  /// **'Your BMI is'**
  String get yourBmiIs;

  /// No description provided for @bmiCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get bmiCategory;

  /// No description provided for @underweight.
  ///
  /// In en, this message translates to:
  /// **'Underweight'**
  String get underweight;

  /// No description provided for @normalWeight.
  ///
  /// In en, this message translates to:
  /// **'Normal Weight'**
  String get normalWeight;

  /// No description provided for @overweight.
  ///
  /// In en, this message translates to:
  /// **'Overweight'**
  String get overweight;

  /// No description provided for @obesity.
  ///
  /// In en, this message translates to:
  /// **'Obesity'**
  String get obesity;

  /// No description provided for @healthAdvice.
  ///
  /// In en, this message translates to:
  /// **'Health Advice'**
  String get healthAdvice;

  /// No description provided for @underweightAdvice.
  ///
  /// In en, this message translates to:
  /// **'You are underweight. Consider consulting a nutritionist for a balanced weight-gain plan.'**
  String get underweightAdvice;

  /// No description provided for @normalWeightAdvice.
  ///
  /// In en, this message translates to:
  /// **'You have a healthy body weight. Good job maintaining a balanced lifestyle!'**
  String get normalWeightAdvice;

  /// No description provided for @overweightAdvice.
  ///
  /// In en, this message translates to:
  /// **'You are slightly overweight. Regular exercise and a balanced diet are recommended.'**
  String get overweightAdvice;

  /// No description provided for @obesityAdvice.
  ///
  /// In en, this message translates to:
  /// **'You are in the obese category. Please consult a healthcare professional for guidance.'**
  String get obesityAdvice;

  /// No description provided for @saveResult.
  ///
  /// In en, this message translates to:
  /// **'Save Result'**
  String get saveResult;

  /// No description provided for @resultSaved.
  ///
  /// In en, this message translates to:
  /// **'BMI result saved to history!'**
  String get resultSaved;

  /// No description provided for @result.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get result;

  /// No description provided for @reCalculate.
  ///
  /// In en, this message translates to:
  /// **'Re-Calculate'**
  String get reCalculate;

  /// No description provided for @shareText.
  ///
  /// In en, this message translates to:
  /// **'Share Text'**
  String get shareText;

  /// No description provided for @exportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get exportPdf;

  /// No description provided for @generalNutritionGuidelines.
  ///
  /// In en, this message translates to:
  /// **'General Nutrition Guidelines'**
  String get generalNutritionGuidelines;

  /// No description provided for @spoonacularMealPlan.
  ///
  /// In en, this message translates to:
  /// **'Spoonacular Meal Plan'**
  String get spoonacularMealPlan;

  /// No description provided for @spoonacularMealPlanSub.
  ///
  /// In en, this message translates to:
  /// **'Recommended daily meal options matching your target calories'**
  String get spoonacularMealPlanSub;

  /// No description provided for @mealPlanOffline.
  ///
  /// In en, this message translates to:
  /// **'Meal Plan Offline'**
  String get mealPlanOffline;

  /// No description provided for @mealPlanOfflineSub.
  ///
  /// In en, this message translates to:
  /// **'Please connect to the internet to load your custom daily meal plan options.'**
  String get mealPlanOfflineSub;

  /// No description provided for @protein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get protein;

  /// No description provided for @carbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get carbs;

  /// No description provided for @fat.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get fat;

  /// No description provided for @calories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get calories;

  /// No description provided for @bmrLabel.
  ///
  /// In en, this message translates to:
  /// **'BMR'**
  String get bmrLabel;

  /// No description provided for @tdeeLabel.
  ///
  /// In en, this message translates to:
  /// **'TDEE'**
  String get tdeeLabel;

  /// No description provided for @targetCaloriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get targetCaloriesLabel;

  /// No description provided for @breakfast.
  ///
  /// In en, this message translates to:
  /// **'Meal 1: Breakfast'**
  String get breakfast;

  /// No description provided for @lunch.
  ///
  /// In en, this message translates to:
  /// **'Meal 2: Lunch'**
  String get lunch;

  /// No description provided for @dinner.
  ///
  /// In en, this message translates to:
  /// **'Meal 3: Dinner'**
  String get dinner;

  /// No description provided for @viewRecipe.
  ///
  /// In en, this message translates to:
  /// **'View Recipe'**
  String get viewRecipe;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get min;

  /// No description provided for @servings.
  ///
  /// In en, this message translates to:
  /// **'servings'**
  String get servings;

  /// No description provided for @bmiHistory.
  ///
  /// In en, this message translates to:
  /// **'BMI History'**
  String get bmiHistory;

  /// No description provided for @noHistoryFound.
  ///
  /// In en, this message translates to:
  /// **'No past calculations found.'**
  String get noHistoryFound;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search Category or BMI Value...'**
  String get searchHint;

  /// No description provided for @allTime.
  ///
  /// In en, this message translates to:
  /// **'All Time'**
  String get allTime;

  /// No description provided for @last7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 Days'**
  String get last7Days;

  /// No description provided for @last30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 Days'**
  String get last30Days;

  /// No description provided for @olderRecords.
  ///
  /// In en, this message translates to:
  /// **'Older Records'**
  String get olderRecords;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get allCategories;

  /// No description provided for @noMatchingRecords.
  ///
  /// In en, this message translates to:
  /// **'No matching records found.'**
  String get noMatchingRecords;

  /// No description provided for @deleteRecord.
  ///
  /// In en, this message translates to:
  /// **'Delete Record?'**
  String get deleteRecord;

  /// No description provided for @deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this BMI calculation record? This action cannot be undone.'**
  String get deleteConfirm;

  /// No description provided for @exportPdfReport.
  ///
  /// In en, this message translates to:
  /// **'Export Full Report'**
  String get exportPdfReport;

  /// No description provided for @printReport.
  ///
  /// In en, this message translates to:
  /// **'Print Report'**
  String get printReport;

  /// No description provided for @recordDeleted.
  ///
  /// In en, this message translates to:
  /// **'Record deleted successfully'**
  String get recordDeleted;

  /// No description provided for @pdfExported.
  ///
  /// In en, this message translates to:
  /// **'PDF exported successfully!'**
  String get pdfExported;

  /// No description provided for @heightLabel.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get heightLabel;

  /// No description provided for @weightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weightLabel;

  /// No description provided for @calculatedOn.
  ///
  /// In en, this message translates to:
  /// **'Calculated on'**
  String get calculatedOn;

  /// No description provided for @shareOrExportRecord.
  ///
  /// In en, this message translates to:
  /// **'Share or Export Record'**
  String get shareOrExportRecord;

  /// No description provided for @shareAsText.
  ///
  /// In en, this message translates to:
  /// **'Share as Text'**
  String get shareAsText;

  /// No description provided for @shareAsTextSub.
  ///
  /// In en, this message translates to:
  /// **'Share the result as a text message'**
  String get shareAsTextSub;

  /// No description provided for @exportAsPdf.
  ///
  /// In en, this message translates to:
  /// **'Export as PDF'**
  String get exportAsPdf;

  /// No description provided for @exportAsPdfSub.
  ///
  /// In en, this message translates to:
  /// **'Download or print a formatted PDF report'**
  String get exportAsPdfSub;

  /// No description provided for @userProfile.
  ///
  /// In en, this message translates to:
  /// **'User Profile'**
  String get userProfile;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @dailyReminder.
  ///
  /// In en, this message translates to:
  /// **'Daily Reminder'**
  String get dailyReminder;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @urdu.
  ///
  /// In en, this message translates to:
  /// **'Urdu (اردو)'**
  String get urdu;

  /// No description provided for @testCrashlytics.
  ///
  /// In en, this message translates to:
  /// **'Test Firebase Crashlytics'**
  String get testCrashlytics;

  /// No description provided for @testCrashSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Trigger a test crash to verify console logs'**
  String get testCrashSubtitle;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirm;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdated;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get noInternetConnection;

  /// No description provided for @backOnline.
  ///
  /// In en, this message translates to:
  /// **'Back Online'**
  String get backOnline;

  /// No description provided for @reminderTitle.
  ///
  /// In en, this message translates to:
  /// **'BMI Check-in Reminder'**
  String get reminderTitle;

  /// No description provided for @reminderBody.
  ///
  /// In en, this message translates to:
  /// **'It\'s time to measure and record your BMI today!'**
  String get reminderBody;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Kinetik'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Monitor your body mass index, analyze trends chronologically, and take control of your health journey.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Explore BMI Classifications'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'Learn how weight classes correspond to health metrics and understand your target ranges.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Select Measurement Units'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred unit standard. This setting automatically configures all future inputs.'**
  String get onboardingDesc3;

  /// No description provided for @onboardingTitle4.
  ///
  /// In en, this message translates to:
  /// **'Safe Cloud Synchronization'**
  String get onboardingTitle4;

  /// No description provided for @onboardingDesc4.
  ///
  /// In en, this message translates to:
  /// **'Access and sync logs securely across all your devices, with local offline fallback options.'**
  String get onboardingDesc4;

  /// No description provided for @metricSystem.
  ///
  /// In en, this message translates to:
  /// **'Metric System'**
  String get metricSystem;

  /// No description provided for @metricUnits.
  ///
  /// In en, this message translates to:
  /// **'Kilograms (kg) & Centimeters (cm)'**
  String get metricUnits;

  /// No description provided for @imperialSystem.
  ///
  /// In en, this message translates to:
  /// **'Imperial System'**
  String get imperialSystem;

  /// No description provided for @imperialUnits.
  ///
  /// In en, this message translates to:
  /// **'Pounds (lbs) & Feet/Inches (ft/in)'**
  String get imperialUnits;

  /// No description provided for @preferredUnitSystem.
  ///
  /// In en, this message translates to:
  /// **'Your preferred measurement system'**
  String get preferredUnitSystem;

  /// No description provided for @dragSliderPreview.
  ///
  /// In en, this message translates to:
  /// **'Drag the slider to preview the BMI scale'**
  String get dragSliderPreview;
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
      <String>['en', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
