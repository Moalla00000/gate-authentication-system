// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'Gate';

  @override
  String welcome(String appName) {
    return 'مرحباً بك في $appName!\nلنبدأ.';
  }

  @override
  String get followSteps => 'اتبع الخطوات لتتعلم كيف يعمل كل شيء.';

  @override
  String get coolLetsGo => 'حسناً، لننطلق';

  @override
  String get okGotcha => 'حسناً، فهمت';

  @override
  String get chooseLanguage => 'اختر لغتك';

  @override
  String get termsAndConditions => 'الشروط والأحكام';

  @override
  String get acceptTerms => 'أوافق على الشروط والأحكام';

  @override
  String get agreeToTermsToContinue => 'يرجى الموافقة على الشروط للمتابعة.';

  @override
  String get next => 'التالي';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get usernameRequired => 'اسم المستخدم مطلوب';

  @override
  String get min3Chars => '3 أحرف على الأقل';

  @override
  String get max20Chars => '20 حرفاً كحد أقصى';

  @override
  String get invalidUsernameChars => 'أحرف وأرقام وشرطات سفلية فقط';

  @override
  String get chooseAvatar => 'اختر صورتك الرمزية';

  @override
  String get finish => 'إنهاء';

  @override
  String get serverUnreachable => 'تعذر الاتصال بالخادم';

  @override
  String get retryConnection => 'إعادة المحاولة';

  @override
  String get verifyInternet => 'يرجى التحقق من اتصالك بالإنترنت.';

  @override
  String get establishingConnection => 'جاري إنشاء اتصال آمن...';

  @override
  String get syncInProgress => 'جاري المزامنة...';

  @override
  String get permissionsTitle => 'أذونات التطبيق';

  @override
  String get permissionsSubtitle =>
      'لنقدم لك أفضل تجربة، نحتاج إلى بعض الأذونات.';

  @override
  String get notifications => 'التنبيهات';

  @override
  String get notificationsDesc => 'لإبقائك على اطلاع بآخر التنبيهات والأخبار.';

  @override
  String get location => 'الموقع';

  @override
  String get locationDesc => 'لعرض المعلومات والخدمات ذات الصلة القريبة منك.';

  @override
  String get granted => 'مسموح';

  @override
  String get denied => 'مرفوض';

  @override
  String get continueBtn => 'استمرار';

  @override
  String get skip => 'تخطي';
}

/// The translations for Arabic, as used in Tunisia (`ar_TN`).
class AppLocalizationsArTn extends AppLocalizationsAr {
  AppLocalizationsArTn() : super('ar_TN');

  @override
  String get appName => 'Gate';

  @override
  String welcome(String appName) {
    return 'مرحباً بيك في $appName!\nيا الله نبداو.';
  }

  @override
  String get followSteps => 'تبع الخطوات باش تعرف كيفاش تخدم كل حاجة.';

  @override
  String get coolLetsGo => 'باهي، نمشيو';

  @override
  String get okGotcha => 'باهي، فهمت';

  @override
  String get chooseLanguage => 'اختار لغتك';

  @override
  String get termsAndConditions => 'الشروط والأحكام';

  @override
  String get acceptTerms => 'نوافق على الشروط والأحكام';

  @override
  String get agreeToTermsToContinue => 'لازم توافق على الشروط باش تكمل.';

  @override
  String get next => 'التعدي';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get usernameRequired => 'اسم المستخدم لازم منه';

  @override
  String get min3Chars => 'على الأقل 3 حروف';

  @override
  String get max20Chars => 'أكثر حاجة 20 حرف';

  @override
  String get invalidUsernameChars => 'حروف، أرقام، وشرطات سفلية بركة';

  @override
  String get chooseAvatar => 'اختار صورتك';

  @override
  String get finish => 'كملنا';

  @override
  String get serverUnreachable => 'السرفر ما يجاوبش';

  @override
  String get retryConnection => 'عاود جرب توا';

  @override
  String get verifyInternet => 'ثبت في الكونكسيون متاعك عيشك.';

  @override
  String get establishingConnection => 'قاعدين نكنكتيو...';

  @override
  String get syncInProgress => 'قاعدين نسبنكرو...';

  @override
  String get permissionsTitle => 'أذونات التطبيق';

  @override
  String get permissionsSubtitle =>
      'باش نعطيوك أحسن تجربة، نستحقو شوية أذونات.';

  @override
  String get notifications => 'التنبيهات';

  @override
  String get notificationsDesc => 'باش نخليوك فايق بآخر التنبيهات والأخبار.';

  @override
  String get location => 'البلاصة';

  @override
  String get locationDesc => 'باش نوريورك الحاجات والخدمات اللي قريبة ليك.';

  @override
  String get granted => 'مريقل';

  @override
  String get denied => 'لا';

  @override
  String get continueBtn => 'تعدى';

  @override
  String get skip => 'تخطي';
}
