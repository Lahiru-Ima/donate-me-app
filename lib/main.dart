import 'package:donate_me_app/l10n/app_localizations.dart';
import 'package:donate_me_app/src/providers/auth_provider.dart';
import 'package:donate_me_app/src/providers/donation_request_provider.dart';
import 'package:donate_me_app/src/providers/job_provider.dart';
import 'package:donate_me_app/src/providers/locale_provider.dart';
import 'package:donate_me_app/src/providers/wishlist_provider.dart';
import 'package:donate_me_app/src/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => DonationRequestProvider()),
        ChangeNotifierProvider(create: (_) => JobProvider()),
        ChangeNotifierProvider(
          create: (_) {
            final provider = LocaleProvider();
            provider.initializeLocale();
            return provider;
          },
        ),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: RouterClass().router,
            title: 'Donate Me App',
            theme: ThemeData(useMaterial3: true),
            locale: localeProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en', 'US'), Locale('si', 'LK')],
          );
        },
      ),
    );
  }
}
