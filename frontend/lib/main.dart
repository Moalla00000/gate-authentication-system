import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gate_authentication_system/l10n/app_localizations.dart';
import 'router.dart';
import 'core/providers/language_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/constants/app_constants.dart';

/// The entry point for the Gate application.
/// Initializes necessary services like environment variables and Firebase
/// before running the app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables for configuration.
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("No .env file found");
  }

  // Initialize Firebase for authentication and other services.
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
    debugPrint(
      "Make sure to provide google-services.json or GoogleService-Info.plist",
    );
  }

  runApp(const ProviderScope(child: MyApp()));
}

/// The root widget of the application.
/// Configures routing and themes using Riverpod providers.
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(languageProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,

      // Localization
      locale: currentLocale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // Modern Material 3 theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ref.watch(themeProvider),

      // Router config
      routerConfig: ref.watch(routerProvider),
    );
  }
}
