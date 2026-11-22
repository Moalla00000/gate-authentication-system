// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Gate';

  @override
  String welcome(String appName) {
    return 'Bienvenue sur $appName !\nCommençons.';
  }

  @override
  String get followSteps =>
      'Suivez les étapes pour apprendre comment tout fonctionne.';

  @override
  String get coolLetsGo => 'C\'EST PARTI';

  @override
  String get okGotcha => 'OK, COMPRIS';

  @override
  String get chooseLanguage => 'Choisissez votre langue';

  @override
  String get termsAndConditions => 'Termes et Conditions';

  @override
  String get acceptTerms => 'J\'accepte les termes et conditions';

  @override
  String get agreeToTermsToContinue =>
      'Veuillez accepter les conditions pour continuer.';

  @override
  String get next => 'SUIVANT';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get usernameRequired => 'Le nom d\'utilisateur est requis';

  @override
  String get min3Chars => 'Minimum 3 caractères';

  @override
  String get max20Chars => 'Maximum 20 caractères';

  @override
  String get invalidUsernameChars =>
      'Lettres, chiffres et underscores uniquement';

  @override
  String get chooseAvatar => 'Choisissez votre avatar';

  @override
  String get finish => 'TERMINER';

  @override
  String get serverUnreachable => 'SERVEUR INACCESSIBLE';

  @override
  String get retryConnection => 'RÉESSAYER LA CONNEXION';

  @override
  String get verifyInternet => 'Veuillez vérifier votre connexion internet.';

  @override
  String get establishingConnection =>
      'ÉTABLISSEMENT DE LA CONNEXION SÉCURISÉE...';

  @override
  String get syncInProgress => 'SYNCHRONISATION EN COURS...';

  @override
  String get permissionsTitle => 'Autorisations';

  @override
  String get permissionsSubtitle =>
      'Pour vous offrir la meilleure expérience, nous avons besoin de quelques autorisations.';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsDesc =>
      'Pour vous tenir au courant des dernières alertes et nouvelles.';

  @override
  String get location => 'Localisation';

  @override
  String get locationDesc =>
      'Pour vous montrer des informations et services pertinents près de vous.';

  @override
  String get granted => 'Autorisé';

  @override
  String get denied => 'Refusé';

  @override
  String get continueBtn => 'CONTINUER';

  @override
  String get skip => 'PASSER';
}
