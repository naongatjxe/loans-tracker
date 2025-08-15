import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'utils/loan_provider.dart';
import 'pages/contract_page.dart';
import 'main_tabs.dart';
import 'theme/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Only set preferred orientations on mobile platforms
  if (!kIsWeb) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoanProvider()),
        ChangeNotifierProvider(create: (_) => ThemeController()),
      ],
      child: Consumer<ThemeController>(
        builder: (context, theme, child) {
          return MaterialApp(
            title: 'Loan Tracker Pro',
            debugShowCheckedModeBanner: false,
            themeMode: theme.mode,
            theme: ThemeData.light().copyWith(
              colorScheme: ColorScheme.fromSeed(seedColor: theme.accent),
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                elevation: 0,
                centerTitle: true,
                surfaceTintColor: Colors.transparent,
                shadowColor: Colors.transparent,
                titleTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  letterSpacing: 0.5,
                  color: Colors.black87,
                ),
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor: Colors.white,
                selectedItemColor: theme.accent,
                unselectedItemColor: Colors.grey.shade600,
                elevation: 8,
                type: BottomNavigationBarType.fixed,
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                ),
              ),
            ),
            darkTheme: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.fromSeed(
                seedColor: theme.accent,
                brightness: Brightness.dark,
              ),
              primaryColor: const Color(0xFF1E3A5F),
              scaffoldBackgroundColor: const Color(0xFF121212),
              appBarTheme: AppBarTheme(
                backgroundColor: const Color(0xFF121212),
                foregroundColor: Colors.white,
                elevation: 0,
                centerTitle: true,
                surfaceTintColor: Colors.transparent,
                shadowColor: Colors.transparent,
                titleTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  letterSpacing: 0.5,
                  color: Colors.white,
                ),
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor: const Color(0xFF1E1E1E),
                selectedItemColor: theme.accent,
                unselectedItemColor: Colors.grey.shade600,
                elevation: 8,
                type: BottomNavigationBarType.fixed,
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                ),
              ),
            ),
            home: const MainTabs(),
            routes: {'/contract': (context) => const ContractPage()},
          );
        },
      ),
    );
  }
}
