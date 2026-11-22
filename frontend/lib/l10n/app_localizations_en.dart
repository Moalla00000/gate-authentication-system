// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Gate';

  @override
  String welcome(String appName) {
    return 'Welcome to $appName!\nLet’s get started.';
  }

  @override
  String get followSteps => 'Follow the steps to learn how everything works.';

  @override
  String get coolLetsGo => 'COOL, LET\'S GO';

  @override
  String get okGotcha => 'OK, GOTCHA';

  @override
  String get chooseLanguage => 'Choose your language';

  @override
  String get termsAndConditions => 'Terms and Conditions';

  @override
  String get acceptTerms => 'I accept the terms and conditions';

  @override
  String get agreeToTermsToContinue => 'Please agree to the terms to continue.';

  @override
  String get next => 'NEXT';

  @override
  String get username => 'Username';

  @override
  String get usernameRequired => 'Username is required';

  @override
  String get min3Chars => 'Minimum 3 characters';

  @override
  String get max20Chars => 'Maximum 20 characters';

  @override
  String get invalidUsernameChars => 'Letters, numbers, and underscores only';

  @override
  String get chooseAvatar => 'Choose your avatar';

  @override
  String get finish => 'FINISH';

  @override
  String get serverUnreachable => 'SERVER UNREACHABLE';

  @override
  String get retryConnection => 'RETRY CONNECTION';

  @override
  String get verifyInternet => 'Please verify your internet connection.';

  @override
  String get establishingConnection => 'ESTABLISHING SECURE CONNECTION...';

  @override
  String get syncInProgress => 'SYNCHRONIZATION IN PROGRESS...';

  @override
  String get permissionsTitle => 'App Permissions';

  @override
  String get permissionsSubtitle =>
      'To give you the best experience, we need a few permissions.';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsDesc =>
      'To keep you updated with the latest alerts and news.';

  @override
  String get location => 'Location';

  @override
  String get locationDesc =>
      'To show you relevant information and services near you.';

  @override
  String get granted => 'Granted';

  @override
  String get denied => 'Denied';

  @override
  String get continueBtn => 'CONTINUE';

  @override
  String get skip => 'SKIP';
}
