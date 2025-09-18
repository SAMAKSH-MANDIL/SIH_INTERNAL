import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'screens/language_selection_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/home_page.dart';
import 'theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with error handling
  bool firebaseInitialized = false;
  try {
    if (kIsWeb) {
      debugPrint('Skipping Firebase.initializeApp() on web. Configure Firebase for web to enable auth.');
    } else {
      await Firebase.initializeApp();
      firebaseInitialized = true;
      debugPrint('Firebase initialized successfully');
    }
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
    debugPrint('App will run in demo mode without Firebase');
    firebaseInitialized = false;
  }
  
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('hi'), Locale('bn'), Locale('kho')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MyApp(firebaseInitialized: firebaseInitialized),
    ),
  );
}

class MyApp extends StatefulWidget {
  final bool firebaseInitialized;
  
  const MyApp({Key? key, required this.firebaseInitialized}) : super(key: key);
  
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeController _themeController = ThemeController.instance;

  @override
  void initState() {
    super.initState();
    _themeController.addListener(_onThemeChanged);
    _themeController.load();
  }

  void _onThemeChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: tr("app_name"),
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
      ),
      themeMode: _themeController.themeMode,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: SplashScreen(firebaseInitialized: widget.firebaseInitialized),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  final bool firebaseInitialized;
  
  const AuthWrapper({Key? key, required this.firebaseInitialized}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If Firebase is not initialized, go directly to language selection
    if (!firebaseInitialized || kIsWeb) {
      debugPrint('AuthWrapper: Firebase not initialized, using demo mode');
      return const LanguageSelectionScreen();
    }
    
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        
        if (snapshot.hasData) {
          return const HomePage();
        }
        
        return const LanguageSelectionScreen();
      },
    );
  }
}